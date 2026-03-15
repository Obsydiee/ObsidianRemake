-- ╔══════════════════════════════════════════════════════════╗
-- ║          OBSIDIAN REMAKE UI LIBRARY  v1.0.0             ║
-- ║       Inspired by Obsidian (deividcomsono/Obsidian)     ║
-- ║       Clean, modular Roblox UI Library                  ║
-- ╚══════════════════════════════════════════════════════════╝

local Library = {
    Version  = "1.0.0",
    Name     = "ObsidianRemake",
    Toggles  = {},   -- indexed by string key
    Options  = {},   -- indexed by string key
    _Window  = nil,
    _ScreenGui = nil,
}

-- ─── Services ────────────────────────────────────────────────────────────────
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UIS            = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local TextService    = game:GetService("TextService")
local LocalPlayer    = Players.LocalPlayer

-- ─── Theme ───────────────────────────────────────────────────────────────────
Library.Theme = {
    Background   = Color3.fromRGB(14, 14, 21),
    Header       = Color3.fromRGB(20, 20, 32),
    TabBar       = Color3.fromRGB(18, 18, 28),
    TabActive    = Color3.fromRGB(30, 22, 52),
    TabInactive  = Color3.fromRGB(22, 22, 34),
    Accent       = Color3.fromRGB(124, 58, 237),
    AccentHover  = Color3.fromRGB(139, 92, 246),
    GroupBG      = Color3.fromRGB(18, 18, 28),
    GroupBorder  = Color3.fromRGB(40, 40, 62),
    GroupHeader  = Color3.fromRGB(22, 22, 36),
    Element      = Color3.fromRGB(26, 26, 40),
    ElementHover = Color3.fromRGB(34, 34, 52),
    Text         = Color3.fromRGB(220, 220, 240),
    TextDim      = Color3.fromRGB(110, 110, 150),
    TextDisabled = Color3.fromRGB(60, 60, 88),
    ToggleOn     = Color3.fromRGB(124, 58, 237),
    ToggleOff    = Color3.fromRGB(46, 46, 70),
    SliderFill   = Color3.fromRGB(124, 58, 237),
    SliderBG     = Color3.fromRGB(36, 36, 56),
    Divider      = Color3.fromRGB(36, 36, 56),
    Red          = Color3.fromRGB(239, 68, 68),
    Green        = Color3.fromRGB(74, 222, 128),
    White        = Color3.fromRGB(255, 255, 255),
    Scrollbar    = Color3.fromRGB(60, 60, 90),
    Dropdown     = Color3.fromRGB(16, 16, 26),
    DropdownItem = Color3.fromRGB(22, 22, 34),
    NotifBG      = Color3.fromRGB(20, 20, 32),
    NotifAccent  = Color3.fromRGB(124, 58, 237),
}

-- ─── Helpers ─────────────────────────────────────────────────────────────────
local function Tween(obj, goal, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        goal
    ):Play()
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in next, props do
        if k ~= "Parent" then obj[k] = v end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function AddCorner(parent, radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, parent)
end

local function AddStroke(parent, color, thickness)
    return New("UIStroke", {
        Color     = color or Library.Theme.GroupBorder,
        Thickness = thickness or 1,
    }, parent)
end

local function AddPadding(parent, top, bottom, left, right)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 6),
        PaddingBottom = UDim.new(0, bottom or 6),
        PaddingLeft   = UDim.new(0, left   or 8),
        PaddingRight  = UDim.new(0, right  or 8),
    }, parent)
end

local function MakeDraggable(frame, handle)
    local dragging, startFramePos, startMousePos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startFramePos  = frame.Position
            startMousePos  = i.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - startMousePos
            frame.Position = UDim2.new(
                startFramePos.X.Scale, startFramePos.X.Offset + d.X,
                startFramePos.Y.Scale, startFramePos.Y.Offset + d.Y
            )
        end
    end)
end

local function RoundNum(n, dec)
    local m = 10^(dec or 0)
    return math.floor(n * m + 0.5) / m
end

-- ─── Tooltip helper ──────────────────────────────────────────────────────────
local function AttachTooltip(element, text)
    if not text or text == "" then return end
    local T = Library.Theme
    local sg = Library._ScreenGui
    if not sg then return end

    local tip = New("Frame", {
        BackgroundColor3 = T.Dropdown,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.XY,
        ZIndex           = 100,
        Visible          = false,
    }, sg)
    AddCorner(tip, 5)
    AddStroke(tip, T.GroupBorder, 1)
    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 11,
        TextColor3     = T.TextDim,
        BackgroundTransparency = 1,
        Size           = UDim2.new(0, 0, 0, 0),
        AutomaticSize  = Enum.AutomaticSize.XY,
        ZIndex         = 101,
    }, tip)
    AddPadding(tip, 4, 4, 8, 8)

    element.MouseMoved:Connect(function(x, y)
        tip.Position = UDim2.new(0, x + 14, 0, y + 14)
        tip.Visible  = true
    end)
    element.MouseLeave:Connect(function()
        tip.Visible = false
    end)
end

-- ─── GROUPBOX ────────────────────────────────────────────────────────────────
local Groupbox = {}
Groupbox.__index = Groupbox

function Groupbox.new(name, parent)
    local T = Library.Theme
    local self = setmetatable({}, Groupbox)

    -- Outer wrapper
    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, parent)

    -- Box
    local box = New("Frame", {
        BackgroundColor3 = T.GroupBG,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
    }, wrapper)
    AddCorner(box, 8)
    AddStroke(box, T.GroupBorder, 1)

    -- Header
    local header = New("Frame", {
        BackgroundColor3 = T.GroupHeader,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 30),
        ZIndex           = 2,
    }, box)
    New("UICorner", { CornerRadius = UDim.new(0, 7) }, header)

    -- Title in header
    New("TextLabel", {
        Text           = name,
        Font           = Enum.Font.GothamBold,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, -36, 1, 0),
        Position       = UDim2.new(0, 10, 0, 0),
        ZIndex         = 3,
    }, header)

    -- Collapse button
    local collapseBtn = New("TextButton", {
        Text            = "−",
        Font            = Enum.Font.GothamBold,
        TextSize        = 14,
        TextColor3      = T.TextDim,
        BackgroundTransparency = 1,
        Size            = UDim2.new(0, 28, 0, 28),
        Position        = UDim2.new(1, -30, 0.5, -14),
        ZIndex          = 3,
    }, header)

    -- Content frame
    local content = New("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 0, 30),
        AutomaticSize    = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
    }, box)
    AddPadding(content, 6, 8, 6, 6)

    -- List layout for elements
    local list = New("UIListLayout", {
        SortOrder  = Enum.SortOrder.LayoutOrder,
        Padding    = UDim.new(0, 4),
    }, content)

    -- Collapse logic
    local collapsed = false
    collapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        collapseBtn.Text = collapsed and "+" or "−"
        content.Visible = not collapsed
        Tween(box, { BackgroundTransparency = collapsed and 0.3 or 0 }, 0.15)
    end)

    self._box     = box
    self._content = content
    self._list    = list

    return self
end

function Groupbox:_AddElement(elem)
    elem.Parent = self._content
end

-- ─── LABEL ───────────────────────────────────────────────────────────────────
function Groupbox:AddLabel(text, doesWrap)
    local T = Library.Theme
    local cfg = type(text) == "table" and text or { Text = text }
    local lbl = New("TextLabel", {
        Text           = cfg.Text or "",
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.TextDim,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped    = cfg.DoesWrap or doesWrap or false,
        Size           = UDim2.new(1, -4, 0, 0),
        AutomaticSize  = Enum.AutomaticSize.Y,
    })
    AddPadding(lbl, 1, 1, 2, 2)
    self:_AddElement(lbl)

    return {
        SetText = function(_, t) lbl.Text = t end,
        Instance = lbl,
    }
end

-- ─── DIVIDER ─────────────────────────────────────────────────────────────────
function Groupbox:AddDivider()
    local T = Library.Theme
    local div = New("Frame", {
        BackgroundColor3 = T.Divider,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, -8, 0, 1),
    })
    AddCorner(div, 1)
    self:_AddElement(div)
    return div
end

-- ─── BUTTON ──────────────────────────────────────────────────────────────────
function Groupbox:AddButton(cfg)
    cfg = cfg or {}
    local T        = Library.Theme
    local text     = cfg.Text    or "Button"
    local func     = cfg.Func    or function() end
    local tooltip  = cfg.Tooltip
    local dblClick = cfg.DoubleClick or false
    local disabled = cfg.Disabled   or false

    local btn = New("TextButton", {
        Text             = text,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 12,
        TextColor3       = disabled and T.TextDisabled or T.Text,
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 30),
        AutoButtonColor  = false,
    })
    AddCorner(btn, 6)
    AddStroke(btn, T.GroupBorder, 1)

    if tooltip then AttachTooltip(btn, tooltip) end

    local clickCount = 0
    if not disabled then
        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundColor3 = T.ElementHover }, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundColor3 = T.Element }, 0.1)
            clickCount = 0
        end)
        btn.MouseButton1Click:Connect(function()
            if dblClick then
                clickCount = clickCount + 1
                if clickCount < 2 then
                    btn.TextColor3 = T.TextDim
                    btn.Text       = "Click again to confirm"
                    task.delay(2, function()
                        if clickCount < 2 then
                            btn.Text       = text
                            btn.TextColor3 = T.Text
                            clickCount     = 0
                        end
                    end)
                    return
                end
            end
            clickCount = 0
            btn.Text   = text
            btn.TextColor3 = T.Text
            Tween(btn, { BackgroundColor3 = T.Accent }, 0.07)
            task.wait(0.07)
            Tween(btn, { BackgroundColor3 = T.ElementHover }, 0.1)
            local ok, err = pcall(func)
            if not ok then warn("[ObsidianRemake] Button error:", err) end
        end)
    end

    self:_AddElement(btn)

    local btnObj = { _parent = self, _instance = btn }
    function btnObj:AddButton(cfg2)
        return self._parent:AddButton(cfg2)
    end
    return btnObj
end

-- ─── TOGGLE ──────────────────────────────────────────────────────────────────
function Groupbox:AddToggle(index, cfg)
    cfg = cfg or {}
    local T       = Library.Theme
    local text    = cfg.Text    or index
    local value   = cfg.Default ~= nil and cfg.Default or false
    local tooltip = cfg.Tooltip
    local risky   = cfg.Risky   or false
    local cbk     = cfg.Callback
    local listeners = {}

    -- Row frame
    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
    })

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = risky and T.Red or T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, -52, 1, 0),
        Position       = UDim2.new(0, 2, 0, 0),
    }, row)

    -- Track (background pill)
    local track = New("Frame", {
        BackgroundColor3 = value and T.ToggleOn or T.ToggleOff,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 36, 0, 20),
        Position         = UDim2.new(1, -40, 0.5, -10),
    }, row)
    AddCorner(track, 10)

    -- Knob
    local knob = New("Frame", {
        BackgroundColor3 = T.White,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
    }, track)
    AddCorner(knob, 7)

    -- Invisible clickable overlay on full row
    local clickArea = New("TextButton", {
        BackgroundTransparency = 1,
        Size   = UDim2.new(1, 0, 1, 0),
        Text   = "",
        ZIndex = 5,
    }, row)

    if tooltip then AttachTooltip(row, tooltip) end

    local function SetValue(v, silent)
        value = v
        Tween(track, { BackgroundColor3 = v and T.ToggleOn or T.ToggleOff }, 0.15)
        Tween(knob,  { Position = v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }, 0.15)
        if not silent then
            if cbk then pcall(cbk, v) end
            for _, fn in next, listeners do pcall(fn, v) end
        end
    end

    clickArea.MouseButton1Click:Connect(function()
        SetValue(not value)
    end)

    self:_AddElement(row)

    local toggleObj = {
        Value      = value,
        _listeners = listeners,
        _row       = row,
        _setVal    = SetValue,
    }
    function toggleObj:SetValue(v) SetValue(v) end
    function toggleObj:OnChanged(fn)
        table.insert(listeners, fn)
    end
    -- Keep .Value synced
    table.insert(listeners, function(v)
        toggleObj.Value = v
    end)

    -- Sub-pickers can be attached to a toggle
    function toggleObj:AddColorPicker(idx, pcfg)
        return Groupbox.AddColorpicker(self._gb or Groupbox, idx, pcfg)
    end
    function toggleObj:AddKeyPicker(idx, pcfg)
        return Groupbox.AddKeybind(self._gb or Groupbox, idx, pcfg)
    end

    Library.Toggles[index]        = toggleObj
    return toggleObj
end

-- ─── CHECKBOX ────────────────────────────────────────────────────────────────
function Groupbox:AddCheckbox(index, cfg)
    cfg = cfg or {}
    local T       = Library.Theme
    local text    = cfg.Text    or index
    local value   = cfg.Default ~= nil and cfg.Default or false
    local cbk     = cfg.Callback
    local listeners = {}

    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 26),
    })

    local box = New("Frame", {
        BackgroundColor3 = value and T.Accent or T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(1, -20, 0.5, -8),
    }, row)
    AddCorner(box, 4)
    AddStroke(box, T.GroupBorder, 1)

    local check = New("TextLabel", {
        Text           = "✓",
        Font           = Enum.Font.GothamBold,
        TextSize       = 11,
        TextColor3     = T.White,
        BackgroundTransparency = 1,
        Size           = UDim2.new(1, 0, 1, 0),
        Visible        = value,
    }, box)

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, -28, 1, 0),
        Position       = UDim2.new(0, 2, 0, 0),
    }, row)

    local clickArea = New("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "", ZIndex = 5,
    }, row)

    local function SetValue(v, silent)
        value = v
        Tween(box, { BackgroundColor3 = v and T.Accent or T.Element }, 0.12)
        check.Visible = v
        if not silent then
            if cbk then pcall(cbk, v) end
            for _, fn in next, listeners do pcall(fn, v) end
        end
    end

    clickArea.MouseButton1Click:Connect(function() SetValue(not value) end)
    self:_AddElement(row)

    local obj = { Value = value, _listeners = listeners }
    function obj:SetValue(v) SetValue(v) end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    table.insert(listeners, function(v) obj.Value = v end)
    Library.Toggles[index] = obj
    return obj
end

-- ─── SLIDER ──────────────────────────────────────────────────────────────────
function Groupbox:AddSlider(index, cfg)
    cfg = cfg or {}
    local T        = Library.Theme
    local text     = cfg.Text     or index
    local min      = cfg.Min      or 0
    local max      = cfg.Max      or 100
    local default  = cfg.Default  ~= nil and cfg.Default or min
    local rounding = cfg.Rounding ~= nil and cfg.Rounding or 0
    local suffix   = cfg.Suffix   or ""
    local cbk      = cfg.Callback
    local listeners = {}
    local value    = math.clamp(default, min, max)

    -- Wrapper
    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 44),
    })

    -- Header row
    local header = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
    }, wrapper)

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(0.6, 0, 1, 0),
    }, header)

    local valLabel = New("TextLabel", {
        Text           = RoundNum(value, rounding) .. suffix,
        Font           = Enum.Font.GothamBold,
        TextSize       = 11,
        TextColor3     = T.Accent,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right,
        Size           = UDim2.new(0.4, 0, 1, 0),
        Position       = UDim2.new(0.6, 0, 0, 0),
    }, header)

    -- Track
    local track = New("Frame", {
        BackgroundColor3 = T.SliderBG,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 0, 22),
    }, wrapper)
    AddCorner(track, 4)

    -- Fill
    local pct = (value - min) / math.max(max - min, 0.001)
    local fill = New("Frame", {
        BackgroundColor3 = T.SliderFill,
        BorderSizePixel  = 0,
        Size             = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0),
    }, track)
    AddCorner(fill, 4)

    -- Thumb
    local thumb = New("Frame", {
        BackgroundColor3 = T.White,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new(math.clamp(pct, 0, 1), -7, 0.5, -7),
        ZIndex           = 3,
    }, track)
    AddCorner(thumb, 7)

    -- Click zone
    local clickZone = New("TextButton", {
        BackgroundTransparency = 1,
        Size   = UDim2.new(1, 0, 0, 20),
        Position = UDim
