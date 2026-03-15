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
                clickCount += 1
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
        Position = UDim2.new(0, 0, 0, -6),
        Text   = "",
        ZIndex = 4,
    }, track)

    local function SetValue(v, silent)
        value = math.clamp(RoundNum(v, rounding), min, max)
        local p = (value - min) / math.max(max - min, 0.001)
        Tween(fill,  { Size     = UDim2.new(math.clamp(p,0,1), 0, 1, 0) }, 0.05)
        Tween(thumb, { Position = UDim2.new(math.clamp(p,0,1), -7, 0.5, -7) }, 0.05)
        valLabel.Text = RoundNum(value, rounding) .. suffix
        if not silent then
            if cbk then pcall(cbk, value) end
            for _, fn in next, listeners do pcall(fn, value) end
        end
    end

    local dragging = false
    local function UpdateFromInput(input)
        local trackAbsPos  = track.AbsolutePosition.X
        local trackAbsSize = track.AbsoluteSize.X
        local rel = (input.Position.X - trackAbsPos) / math.max(trackAbsSize, 1)
        rel = math.clamp(rel, 0, 1)
        SetValue(min + rel * (max - min))
    end

    clickZone.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateFromInput(i)
        end
    end)
    clickZone.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateFromInput(i)
        end
    end)

    self:_AddElement(wrapper)

    local obj = { Value = value, _listeners = listeners }
    function obj:SetValue(v) SetValue(v) end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    table.insert(listeners, function(v) obj.Value = v end)

    Library.Options[index] = obj
    return obj
end

-- ─── INPUT ───────────────────────────────────────────────────────────────────
function Groupbox:AddInput(index, cfg)
    cfg = cfg or {}
    local T           = Library.Theme
    local text        = cfg.Text        or index
    local default     = cfg.Default     or ""
    local placeholder = cfg.Placeholder or "Type here..."
    local numeric     = cfg.Numeric     or false
    local finished    = cfg.Finished    or false
    local maxLen      = cfg.MaxLength   or 200
    local cbk         = cfg.Callback
    local listeners   = {}

    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52),
    })

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, 0, 0, 18),
    }, wrapper)

    local inputBG = New("Frame", {
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 28),
        Position         = UDim2.new(0, 0, 0, 22),
    }, wrapper)
    AddCorner(inputBG, 6)
    AddStroke(inputBG, T.GroupBorder, 1)

    local box = New("TextBox", {
        Text              = default,
        PlaceholderText   = placeholder,
        Font              = Enum.Font.Gotham,
        TextSize          = 12,
        TextColor3        = T.Text,
        PlaceholderColor3 = T.TextDim,
        BackgroundTransparency = 1,
        TextXAlignment    = Enum.TextXAlignment.Left,
        Size              = UDim2.new(1, -12, 1, 0),
        Position          = UDim2.new(0, 6, 0, 0),
        ClearTextOnFocus  = cfg.ClearTextOnFocus or false,
    }, inputBG)

    box.Focused:Connect(function()
        Tween(inputBG, { BackgroundColor3 = T.ElementHover }, 0.1)
        AddStroke(inputBG, T.Accent, 1)
    end)
    box.FocusLost:Connect(function(enter)
        Tween(inputBG, { BackgroundColor3 = T.Element }, 0.1)
        if not finished or enter then
            local v = box.Text
            if numeric then
                v = tonumber(v) or 0
                box.Text = tostring(v)
            end
            if #box.Text > maxLen then box.Text = box.Text:sub(1, maxLen) end
            if cbk then pcall(cbk, v) end
            for _, fn in next, listeners do pcall(fn, v) end
        end
    end)
    if not finished then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if #box.Text > maxLen then box.Text = box.Text:sub(1, maxLen) end
            local v = numeric and (tonumber(box.Text) or 0) or box.Text
            if cbk then pcall(cbk, v) end
            for _, fn in next, listeners do pcall(fn, v) end
        end)
    end

    self:_AddElement(wrapper)

    local obj = { Value = default, _listeners = listeners }
    function obj:SetValue(v)
        box.Text = tostring(v)
        obj.Value = v
    end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    table.insert(listeners, function(v) obj.Value = v end)

    Library.Options[index] = obj
    return obj
end

-- ─── DROPDOWN ────────────────────────────────────────────────────────────────
function Groupbox:AddDropdown(index, cfg)
    cfg = cfg or {}
    local T          = Library.Theme
    local text       = cfg.Text       or index
    local values     = cfg.Values     or {}
    local multi      = cfg.Multi      or false
    local searchable = cfg.Searchable or false
    local cbk        = cfg.Callback
    local listeners  = {}
    local isOpen     = false

    -- Determine default
    local selected
    if multi then
        selected = type(cfg.Default) == "table" and cfg.Default or {}
    else
        selected = cfg.Default or values[1] or ""
    end

    local function GetDisplayText()
        if multi then
            if #selected == 0 then return "(none)" end
            return table.concat(selected, ", ")
        end
        return tostring(selected)
    end

    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 52),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
    })

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, 0, 0, 18),
    }, wrapper)

    -- Selected row button
    local rowBG = New("TextButton", {
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 28),
        Position         = UDim2.new(0, 0, 0, 22),
        Text             = "",
    }, wrapper)
    AddCorner(rowBG, 6)
    AddStroke(rowBG, T.GroupBorder, 1)

    local selLabel = New("TextLabel", {
        Text           = GetDisplayText(),
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.TextDim,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate   = Enum.TextTruncate.AtEnd,
        Size           = UDim2.new(1, -28, 1, 0),
        Position       = UDim2.new(0, 8, 0, 0),
    }, rowBG)

    New("TextLabel", {
        Text     = "▾",
        Font     = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = T.TextDim,
        BackgroundTransparency = 1,
        Size     = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -22, 0, 0),
    }, rowBG)

    -- Dropdown panel (absolute positioned below)
    local panel = New("Frame", {
        BackgroundColor3 = T.Dropdown,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 0, 54),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Visible          = false,
        ZIndex           = 20,
        ClipsDescendants = false,
    }, wrapper)
    AddCorner(panel, 6)
    AddStroke(panel, T.GroupBorder, 1)
    AddPadding(panel, 4, 4, 4, 4)

    local panelList = New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 2),
    }, panel)

    -- Search box (optional)
    local searchBox
    if searchable then
        local searchBG = New("Frame", {
            BackgroundColor3 = T.Element,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 24),
            ZIndex           = 21,
        }, panel)
        AddCorner(searchBG, 5)

        searchBox = New("TextBox", {
            Text              = "",
            PlaceholderText   = "Search...",
            Font              = Enum.Font.Gotham,
            TextSize          = 11,
            TextColor3        = T.Text,
            PlaceholderColor3 = T.TextDim,
            BackgroundTransparency = 1,
            TextXAlignment    = Enum.TextXAlignment.Left,
            Size              = UDim2.new(1, -10, 1, 0),
            Position          = UDim2.new(0, 5, 0, 0),
            ZIndex            = 22,
        }, searchBG)
    end

    -- Build items
    local itemFrames = {}
    local function BuildItems()
        for _, f in next, itemFrames do f:Destroy() end
        itemFrames = {}

        local filter = searchBox and searchBox.Text:lower() or ""

        for _, v in ipairs(values) do
            if filter == "" or tostring(v):lower():find(filter, 1, true) then
                local isSelected = multi and table.find(selected, v) or (v == selected)

                local item = New("TextButton", {
                    Text             = "",
                    BackgroundColor3 = isSelected and T.TabActive or T.DropdownItem,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 26),
                    ZIndex           = 21,
                }, panel)
                AddCorner(item, 5)

                New("TextLabel", {
                    Text           = tostring(v),
                    Font           = Enum.Font.Gotham,
                    TextSize       = 12,
                    TextColor3     = isSelected and T.Text or T.TextDim,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size           = UDim2.new(1, -8, 1, 0),
                    Position       = UDim2.new(0, 8, 0, 0),
                    ZIndex         = 22,
                }, item)

                item.MouseEnter:Connect(function()
                    if not isSelected then
                        Tween(item, { BackgroundColor3 = T.ElementHover }, 0.08)
                    end
                end)
                item.MouseLeave:Connect(function()
                    if not isSelected then
                        Tween(item, { BackgroundColor3 = T.DropdownItem }, 0.08)
                    end
                end)

                item.MouseButton1Click:Connect(function()
                    if multi then
                        local idx = table.find(selected, v)
                        if idx then
                            table.remove(selected, idx)
                        else
                            table.insert(selected, v)
                        end
                    else
                        selected = v
                        isOpen   = false
                        panel.Visible = false
                    end
                    selLabel.Text = GetDisplayText()
                    BuildItems()
                    if cbk then pcall(cbk, selected) end
                    for _, fn in next, listeners do pcall(fn, selected) end
                end)

                table.insert(itemFrames, item)
            end
        end
    end
    BuildItems()

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(BuildItems)
    end

    rowBG.MouseEnter:Connect(function()
        Tween(rowBG, { BackgroundColor3 = T.ElementHover }, 0.1)
    end)
    rowBG.MouseLeave:Connect(function()
        Tween(rowBG, { BackgroundColor3 = T.Element }, 0.1)
    end)
    rowBG.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        panel.Visible = isOpen
        if isOpen and searchBox then
            searchBox.Text = ""
            BuildItems()
        end
    end)

    self:_AddElement(wrapper)

    local obj = { Value = selected, _listeners = listeners }
    function obj:SetValue(v)
        selected = v
        selLabel.Text = GetDisplayText()
        BuildItems()
        obj.Value = v
    end
    function obj:SetValues(v)
        values = v
        BuildItems()
    end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    table.insert(listeners, function(v) obj.Value = v end)

    Library.Options[index] = obj
    return obj
end

-- ─── COLOR PICKER ────────────────────────────────────────────────────────────
function Groupbox:AddColorpicker(index, cfg)
    cfg = cfg or {}
    local T           = Library.Theme
    local text        = cfg.Text         or index
    local default     = cfg.Default      or Color3.fromRGB(255, 255, 255)
    local cbk         = cfg.Callback
    local listeners   = {}
    local value       = default

    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
    })

    New("TextLabel", {
        Text           = text,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, -36, 1, 0),
        Position       = UDim2.new(0, 2, 0, 0),
    }, wrapper)

    -- Color preview button
    local preview = New("TextButton", {
        BackgroundColor3 = value,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 26, 0, 22),
        Position         = UDim2.new(1, -28, 0.5, -11),
        Text             = "",
    }, wrapper)
    AddCorner(preview, 5)
    AddStroke(preview, T.GroupBorder, 1)

    -- Simple color picker panel (HSV)
    local pickerOpen = false
    local panel = New("Frame", {
        BackgroundColor3 = T.Dropdown,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 160),
        Position         = UDim2.new(0, 0, 0, 34),
        Visible          = false,
        ZIndex           = 25,
    }, wrapper)
    AddCorner(panel, 8)
    AddStroke(panel, T.GroupBorder, 1)
    AddPadding(panel, 8, 8, 8, 8)

    local panelLayout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6) }, panel)

    -- Color display + HEX input
    local colorRow = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,24), LayoutOrder = 0 }, panel)
    local colorDisplay = New("Frame", {
        BackgroundColor3 = value,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 24, 1, 0),
        ZIndex           = 26,
    }, colorRow)
    AddCorner(colorDisplay, 5)

    local hexBG = New("Frame", {
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, -30, 1, 0),
        Position         = UDim2.new(0, 30, 0, 0),
        ZIndex           = 26,
    }, colorRow)
    AddCorner(hexBG, 5)

    local function ColorToHex(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R * 255),
            math.floor(c.G * 255),
            math.floor(c.B * 255))
    end

    local hexBox = New("TextBox", {
        Text              = ColorToHex(value),
        Font              = Enum.Font.Code,
        TextSize          = 11,
        TextColor3        = T.Text,
        PlaceholderColor3 = T.TextDim,
        BackgroundTransparency = 1,
        TextXAlignment    = Enum.TextXAlignment.Left,
        Size              = UDim2.new(1, -8, 1, 0),
        Position          = UDim2.new(0, 5, 0, 0),
        ZIndex            = 27,
    }, hexBG)

    -- RGB sliders
    local channels = { {name="R", key="R"}, {name="G", key="G"}, {name="B", key="B"} }
    local channelSliders = {}

    local function UpdateColor(newColor, silent)
        value = newColor
        preview.BackgroundColor3      = newColor
        colorDisplay.BackgroundColor3 = newColor
        hexBox.Text = ColorToHex(newColor)
        if not silent then
            if cbk then pcall(cbk, newColor) end
            for _, fn in next, listeners do pcall(fn, newColor) end
        end
    end

    for i, ch in ipairs(channels) do
        local sliderRow = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,18), LayoutOrder = i }, panel)

        New("TextLabel", {
            Text = ch.name, Font = Enum.Font.GothamBold,
            TextSize = 10, TextColor3 = T.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 12, 1, 0), ZIndex = 26,
        }, sliderRow)

        local sTrack = New("Frame", {
            BackgroundColor3 = T.SliderBG,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, -46, 0, 6),
            Position         = UDim2.new(0, 14, 0.5, -3),
            ZIndex           = 26,
        }, sliderRow)
        AddCorner(sTrack, 3)

        local channelValue = value[ch.key]
        local sFill = New("Frame", {
            BackgroundColor3 = i == 1 and Color3.fromRGB(239,68,68) or (i == 2 and Color3.fromRGB(74,222,128) or Color3.fromRGB(96,165,250)),
            BorderSizePixel  = 0,
            Size             = UDim2.new(channelValue, 0, 1, 0),
            ZIndex           = 27,
        }, sTrack)
        AddCorner(sFill, 3)

        local valLbl = New("TextLabel", {
            Text = tostring(math.floor(channelValue * 255)),
            Font = Enum.Font.Code, TextSize = 10, TextColor3 = T.TextDim,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            Size = UDim2.new(0, 28, 1, 0),
            Position = UDim2.new(1, -28, 0, 0), ZIndex = 26,
        }, sliderRow)

        local cz = New("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-46,0,16), Position = UDim2.new(0,14,0.5,-8),
            Text = "", ZIndex = 28,
        }, sliderRow)

        local dragging = false
        local function updateSlider(input)
            local abs = sTrack.AbsolutePosition.X
            local sz  = sTrack.AbsoluteSize.X
            local rel = math.clamp((input.Position.X - abs) / math.max(sz, 1), 0, 1)
            sFill.Size = UDim2.new(rel, 0, 1, 0)
            valLbl.Text = tostring(math.floor(rel * 255))
            channelSliders[ch.key] = rel
            local r = channelSliders["R"] or value.R
            local g = channelSliders["G"] or value.G
            local b = channelSliders["B"] or value.B
            UpdateColor(Color3.new(r, g, b))
        end

        channelSliders[ch.key] = channelValue
        cz.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(i)
            end
        end)
        cz.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(i)
            end
        end)
    end

    hexBox.FocusLost:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16) or 0
            local g = tonumber(hex:sub(3,4), 16) or 0
            local b = tonumber(hex:sub(5,6), 16) or 0
            UpdateColor(Color3.fromRGB(r, g, b))
        end
    end)

    preview.MouseButton1Click:Connect(function()
        pickerOpen = not pickerOpen
        panel.Visible = pickerOpen
    end)

    self:_AddElement(wrapper)

    local obj = { Value = value, Transparency = 0, _listeners = listeners }
    function obj:SetValue(v) UpdateColor(v) end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    table.insert(listeners, function(v) obj.Value = v end)

    Library.Options[index] = obj
    return obj
end

-- ─── KEYBIND ─────────────────────────────────────────────────────────────────
function Groupbox:AddKeybind(index, cfg)
    cfg = cfg or {}
    local T         = Library.Theme
    local text      = cfg.Text    or index
    local default   = cfg.Default or Enum.KeyCode.Unknown
    local mode      = cfg.Mode    or "Toggle"
    local cbk       = cfg.Callback
    local listeners = {}
    local clickCBs  = {}
    local keyValue  = default
    local active    = false
    local listening = false

    local row = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,30) })

    New("TextLabel", {
        Text = text, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = T.Text, BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0,2,0,0),
    }, row)

    local keyBtn = New("TextButton", {
        Text             = tostring(keyValue.Name):gsub("(%a)([%w_']*)", function(f,r) return f:upper()..r:lower() end),
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextColor3       = T.TextDim,
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 82, 0, 22),
        Position         = UDim2.new(1, -84, 0.5, -11),
    }, row)
    AddCorner(keyBtn, 5)
    AddStroke(keyBtn, T.GroupBorder, 1)

    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text      = "..."
        keyBtn.TextColor3 = T.Accent
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keyValue = input.KeyCode
                local name = tostring(keyValue.Name):gsub("(%a)([%w_']*)", function(f,r) return f:upper()..r:lower() end)
                keyBtn.Text = name
                keyBtn.TextColor3 = T.TextDim
                listening = false
                for _, fn in next, listeners do pcall(fn, keyValue, {}) end
                return
            end
        else
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyValue then
                if mode == "Hold" then
                    active = true
                    if cbk then pcall(cbk, true) end
                    for _, fn in next, clickCBs do pcall(fn) end
                elseif mode == "Toggle" then
                    active = not active
                    if cbk then pcall(cbk, active) end
                    for _, fn in next, clickCBs do pcall(fn) end
                end
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if mode == "Hold" and input.UserInputType == Enum.UserInputType.Keyboard
                and input.KeyCode == keyValue then
            active = false
            if cbk then pcall(cbk, false) end
        end
    end)

    self:_AddElement(row)

    local obj = { Value = keyValue, Modifiers = {}, _listeners = listeners }
    function obj:SetValue(k) keyValue = k end
    function obj:OnChanged(fn) table.insert(listeners, fn) end
    function obj:OnClick(fn)   table.insert(clickCBs, fn) end
    table.insert(listeners, function(v) obj.Value = v end)

    Library.Options[index] = obj
    return obj
end

-- ─── TABBOX ──────────────────────────────────────────────────────────────────
local Tabbox = {}
Tabbox.__index = Tabbox

function Tabbox.new(parent)
    local T = Library.Theme
    local self = setmetatable({}, Tabbox)

    local wrapper = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
    }, parent)

    local tabBar = New("Frame", {
        BackgroundColor3 = T.TabBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 26),
    }, wrapper)
    AddCorner(tabBar, 6)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 2),
    }, tabBar)
    AddPadding(tabBar, 3, 3, 3, 3)

    local contentArea = New("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 0, 28),
        AutomaticSize    = Enum.AutomaticSize.Y,
    }, wrapper)

    self._tabBar     = tabBar
    self._contentArea = contentArea
    self._tabs        = {}
    self._activeTab   = nil

    return self
end

function Tabbox:AddTab(name)
    local T = Library.Theme
    local tabBtn = New("TextButton", {
        Text             = name,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 11,
        TextColor3       = T.TextDim,
        BackgroundColor3 = T.TabInactive,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 0, 1, 0),
        AutomaticSize    = Enum.AutomaticSize.X,
        AutoButtonColor  = false,
    }, self._tabBar)
    AddCorner(tabBtn, 4)
    AddPadding(tabBtn, 0, 0, 8, 8)

    -- Tab content (a fake Groupbox)
    local contentFrame = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible       = false,
    }, self._contentArea)

    local list = New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 6),
    }, contentFrame)
    AddPadding(contentFrame, 4, 0, 0, 0)

    local tabObj = setmetatable({ _content = contentFrame, _list = list }, Groupbox)
    tabObj._AddElement = function(_, elem)
        elem.Parent = contentFrame
    end

    -- Wire button
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in next, self._tabs do
            t._content.Visible = false
            t._btn.BackgroundColor3 = T.TabInactive
            t._btn.TextColor3       = T.TextDim
        end
        contentFrame.Visible          = true
        tabBtn.BackgroundColor3       = T.TabActive
        tabBtn.TextColor3             = T.Text
        self._activeTab               = tabObj
    end)

    tabObj._btn = tabBtn
    table.insert(self._tabs, tabObj)

    -- Auto-select first tab
    if #self._tabs == 1 then
        contentFrame.Visible    = true
        tabBtn.BackgroundColor3 = T.TabActive
        tabBtn.TextColor3       = T.Text
        self._activeTab         = tabObj
    end

    return tabObj
end

-- ─── TAB CREATION ────────────────────────────────────────────────────────────
local Tab = {}
Tab.__index = Tab

function Tab.new(name, contentParent)
    local self = setmetatable({}, Tab)
    self._content = contentParent
    self._name    = name
    self._left    = nil
    self._right   = nil
    return self
end

function Tab:_EnsureColumns()
    if self._columns then return end
    local T = Library.Theme

    local cols = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, self._content)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 8),
    }, cols)

    local left = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder   = 0,
    }, cols)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6) }, left)

    local right = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder   = 1,
    }, cols)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6) }, right)

    self._columns = cols
    self._left    = left
    self._right   = right
end

function Tab:AddLeftGroupbox(name)
    self:_EnsureColumns()
    local gb = Groupbox.new(name, self._left)
    return gb
end

function Tab:AddRightGroupbox(name)
    self:_EnsureColumns()
    local gb = Groupbox.new(name, self._right)
    return gb
end

function Tab:AddLeftTabbox()
    self:_EnsureColumns()
    return Tabbox.new(self._left)
end

function Tab:AddRightTabbox()
    self:_EnsureColumns()
    return Tabbox.new(self._right)
end

-- ─── WINDOW ──────────────────────────────────────────────────────────────────
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local T          = self.Theme
    local title      = cfg.Title       or "ObsidianRemake"
    local footer     = cfg.Footer      or ""
    local size       = cfg.Size        or UDim2.fromOffset(720, 500)
    local center     = cfg.Center      ~= false
    local autoShow   = cfg.AutoShow    ~= false
    local toggleKey  = cfg.ToggleKeybind or Enum.KeyCode.RightControl
    local notifSide  = cfg.NotifySide  or "Right"

    -- ScreenGui
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local sg = New("ScreenGui", {
        Name             = "ObsidianRemake",
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset   = true,
    }, pg)
    self._ScreenGui = sg

    -- Main window frame
    local win = New("Frame", {
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        Size             = size,
        Position         = center and UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
                                   or UDim2.fromOffset(100, 100),
        Visible          = autoShow,
    }, sg)
    AddCorner(win, 10)
    AddStroke(win, T.GroupBorder, 1)
    New("UISizeConstraint", {
        MinSize = Vector2.new(400, 300),
        MaxSize = Vector2.new(1200, 800),
    }, win)
    self._Window = win

    -- ── Title bar ──
    local titleBar = New("Frame", {
        BackgroundColor3 = T.Header,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 44),
        ZIndex           = 2,
    }, win)
    New("UICorner", { CornerRadius = UDim.new(0, 9) }, titleBar)
    -- bottom-round fix
    New("Frame", {
        BackgroundColor3 = T.Header,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0.5, 0),
        Position         = UDim2.new(0, 0, 0.5, 0),
        ZIndex           = 2,
    }, titleBar)

    -- Accent line under title bar
    local accentLine = New("Frame", {
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 1, -2),
        ZIndex           = 3,
    }, titleBar)

    -- Title text
    New("TextLabel", {
        Text           = title,
        Font           = Enum.Font.GothamBold,
        TextSize       = 14,
        TextColor3     = T.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, -80, 1, 0),
        Position       = UDim2.new(0, 14, 0, 0),
        ZIndex         = 3,
    }, titleBar)

    -- Footer
    if footer ~= "" then
        New("TextLabel", {
            Text           = footer,
            Font           = Enum.Font.Gotham,
            TextSize       = 10,
            TextColor3     = T.TextDim,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            Size           = UDim2.new(0, 120, 1, 0),
            Position       = UDim2.new(1, -160, 0, 0),
            ZIndex         = 3,
        }, titleBar)
    end

    -- Close button
    local closeBtn = New("TextButton", {
        Text             = "✕",
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextColor3       = T.TextDim,
        BackgroundColor3 = T.Element,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 26, 0, 26),
        Position         = UDim2.new(1, -34, 0.5, -13),
        ZIndex           = 4,
    }, titleBar)
    AddCorner(closeBtn, 5)
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, { BackgroundColor3 = T.Red, TextColor3 = T.White }, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, { BackgroundColor3 = T.Element, TextColor3 = T.TextDim }, 0.1)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(win, { BackgroundTransparency = 1 }, 0.2)
        task.wait(0.2)
        win.Visible = false
        win.BackgroundTransparency = 0
    end)

    MakeDraggable(win, titleBar)

    -- ── Tab bar ──
    local tabBar = New("Frame", {
        BackgroundColor3 = T.TabBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, -24, 0, 34),
        Position         = UDim2.new(0, 12, 0, 50),
        ZIndex           = 2,
    }, win)
    AddCorner(tabBar, 8)
    AddStroke(tabBar, T.GroupBorder, 1)

    local tabList = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 4),
    }, tabBar)
    AddPadding(tabBar, 4, 4, 6, 6)

    -- ── Scrollable content area ──
    local scrollFrame = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1, -24, 1, -98),
        Position               = UDim2.new(0, 12, 0, 92),
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        ScrollBarThickness     = 4,
        ScrollBarImageColor3   = T.Scrollbar,
        ZIndex                 = 1,
    }, win)

    local contentList = New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 6),
    }, scrollFrame)

    -- ── Tab management ──
    local tabs       = {}
    local activePage = nil

    local windowObj = {
        _win         = win,
        _sg          = sg,
        _tabs        = tabs,
        _tabBar      = tabBar,
        _scrollFrame = scrollFrame,
        _library     = self,
    }

    function windowObj:AddTab(name, _icon)
        local T2 = Library.Theme
        -- Tab button
        local btn = New("TextButton", {
            Text             = name,
            Font             = Enum.Font.GothamSemibold,
            TextSize         = 12,
            TextColor3       = T2.TextDim,
            BackgroundColor3 = T2.TabInactive,
            BorderSizePixel  = 0,
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            AutoButtonColor  = false,
            ZIndex           = 3,
        }, tabBar)
        AddCorner(btn, 6)
        AddPadding(btn, 0, 0, 10, 10)

        -- Content page
        local page = New("Frame", {
            BackgroundTransparency = 1,
            Size          = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible       = false,
        }, scrollFrame)
        AddPadding(page, 4, 4, 0, 0)

        local tab = Tab.new(name, page)
        tab._btn  = btn
        tab._page = page

        local function SelectTab()
            -- deselect all
            for _, t in next, tabs do
                t._page.Visible          = false
                t._btn.BackgroundColor3  = T2.TabInactive
                t._btn.TextColor3        = T2.TextDim
            end
            page.Visible           = true
            btn.BackgroundColor3   = T2.TabActive
            btn.TextColor3         = T2.Text
            activePage             = tab
        end

        btn.MouseButton1Click:Connect(SelectTab)
        btn.MouseEnter:Connect(function()
            if activePage ~= tab then
                Tween(btn, { BackgroundColor3 = T2.ElementHover }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activePage ~= tab then
                Tween(btn, { BackgroundColor3 = T2.TabInactive }, 0.1)
            end
        end)

        table.insert(tabs, tab)

        -- Select first tab automatically
        if #tabs == 1 then
            SelectTab()
        end

        return tab
    end

    function windowObj:AddKeyTab(name)
        return self:AddTab(name)
    end

    -- Toggle visibility with keybind
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Keyboard
                and input.KeyCode == toggleKey then
            win.Visible = not win.Visible
        end
    end)

    return windowObj
end

-- ─── NOTIFY ──────────────────────────────────────────────────────────────────
function Library:Notify(cfg)
    if type(cfg) == "string" then cfg = { Content = cfg } end
    cfg = cfg or {}
    local T        = self.Theme
    local title    = cfg.Title    or self.Name
    local content  = cfg.Content  or ""
    local duration = cfg.Duration or 4

    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local sg = pg:FindFirstChild("ObsidianRemake_Notifs")
    if not sg then
        sg = New("ScreenGui", {
            Name = "ObsidianRemake_Notifs",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
        }, pg)
        local holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 290, 1, -20),
            Position = UDim2.new(1, -302, 0, 10),
            AnchorPoint = Vector2.new(0, 0),
        }, sg)
        New("UIListLayout", {
            SortOrder            = Enum.SortOrder.LayoutOrder,
            VerticalAlignment    = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment  = Enum.HorizontalAlignment.Right,
            Padding              = UDim.new(0, 6),
        }, holder)
        sg:SetAttribute("Holder", holder:GetFullName())
    end

    local holder = sg:FindFirstChildWhichIsA("Frame")
    if not holder then return end

    local notif = New("Frame", {
        BackgroundColor3 = T.NotifBG,
        BackgroundTransparency = 0.05,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
    }, holder)
    AddCorner(notif, 8)
    AddStroke(notif, T.NotifAccent, 1)
    AddPadding(notif, 10, 10, 12, 12)

    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) }, notif)

    -- Accent dot + title
    local titleRow = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,16), LayoutOrder = 0 }, notif)
    New("Frame", {
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 6, 0, 6),
        Position         = UDim2.new(0, 0, 0.5, -3),
    }, titleRow)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, titleRow:FindFirstChildOfClass("Frame"))
    New("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = T.Text, BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        LayoutOrder = 0,
    }, titleRow)

    New("TextLabel", {
        Text = content, Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = T.TextDim, BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
    }, notif)

    -- Progress bar
    local barBG = New("Frame", {
        BackgroundColor3 = T.GroupBorder, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2), LayoutOrder = 2,
    }, notif)
    AddCorner(barBG, 1)
    local bar = New("Frame", {
        BackgroundColor3 = T.Accent, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
    }, barBG)
    AddCorner(bar, 1)

    Tween(bar, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        Tween(notif, { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) }, 0.25)
        task.wait(0.25)
        notif:Destroy()
    end)
end

-- ─── Unload ──────────────────────────────────────────────────────────────────
function Library:Unload()
    if self._ScreenGui then
        self._ScreenGui:Destroy()
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local notifSg = pg:FindFirstChild("ObsidianRemake_Notifs")
        if notifSg then notifSg:Destroy() end
    end
    self.Toggles = {}
    self.Options  = {}
end

return Library
