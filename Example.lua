-- ╔══════════════════════════════════════════════════════════╗
-- ║        OBSIDIAN REMAKE — Example Script  v1.0.1         ║
-- ║   Full Lua 5.1 Compatible — Delta/Solara/Synapse        ║
-- ╚══════════════════════════════════════════════════════════╝

-- ── Load Library ─────────────────────────────────────────────
local repo = "https://raw.githubusercontent.com/Obsydiee/ObsidianRemake/refs/heads/main/"

local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ── Setup SaveManager & ThemeManager ─────────────────────────
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("ObsidianRemake")
SaveManager:IgnoreElements("SaveManager_ConfigName", "SaveManager_ConfigList", "ThemeManager_Theme")

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("ObsidianRemake")

-- ── Buat Window ──────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title         = "Obsidian Remake",
    Footer        = "v1.0.1",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center        = true,
    AutoShow      = true,
    Size          = UDim2.fromOffset(720, 500),
})

-- ── Buat Tabs ────────────────────────────────────────────────
local MainTab     = Window:AddTab("Main")
local CombatTab   = Window:AddTab("Combat")
local VisualTab   = Window:AddTab("Visual")
local MiscTab     = Window:AddTab("Misc")
local SettingsTab = Window:AddTab("Settings")

-- ─────────────────────────────────────────────────────────────
-- MAIN TAB
-- ─────────────────────────────────────────────────────────────
local LeftBox  = MainTab:AddLeftGroupbox("Player")
local RightBox = MainTab:AddRightGroupbox("Info")

LeftBox:AddToggle("GodMode", {
    Text    = "God Mode",
    Default = false,
    Tooltip = "Membuat player tidak bisa mati",
    Risky   = true,
})

LeftBox:AddToggle("Noclip", {
    Text    = "Noclip",
    Default = false,
    Tooltip = "Menembus dinding",
})

LeftBox:AddToggle("InfiniteJump", {
    Text    = "Infinite Jump",
    Default = false,
})

LeftBox:AddSlider("WalkSpeed", {
    Text     = "Walk Speed",
    Default  = 16,
    Min      = 0,
    Max      = 250,
    Rounding = 0,
    Suffix   = " studs/s",
})

LeftBox:AddSlider("JumpPower", {
    Text     = "Jump Power",
    Default  = 50,
    Min      = 0,
    Max      = 300,
    Rounding = 0,
})

LeftBox:AddDivider()

LeftBox:AddButton({
    Text    = "Teleport to Spawn",
    Tooltip = "Teleport ke spawn point",
    Func    = function()
        Library:Notify({
            Title    = "Teleport",
            Content  = "Teleporting to spawn...",
            Duration = 3,
        })
    end,
})

LeftBox:AddButton({
    Text        = "Kill All Players",
    DoubleClick = true,
    Func        = function()
        Library:Notify("Kill All executed!")
    end,
}):AddButton({
    Text = "Kick All Players",
    Func = function()
        Library:Notify("Kick All executed!")
    end,
})

RightBox:AddLabel("Obsidian Remake v1.0.1", false)
RightBox:AddLabel(
    "UI Library untuk Roblox\nterinspirasi dari Obsidian.\n\nFitur:\n- Toggle & Checkbox\n- Slider, Button, Dropdown\n- Input, ColorPicker, Keybind\n- Tabbox & Notifikasi",
    true
)
RightBox:AddDivider()
local statusLabel = RightBox:AddLabel("Status: Idle")

-- ─────────────────────────────────────────────────────────────
-- COMBAT TAB
-- ─────────────────────────────────────────────────────────────
local CombatLeft  = CombatTab:AddLeftGroupbox("Aimbot")
local CombatRight = CombatTab:AddRightGroupbox("Combat")

CombatLeft:AddToggle("AimbotEnabled", {
    Text    = "Aimbot",
    Default = false,
})

CombatLeft:AddSlider("AimbotFOV", {
    Text     = "FOV",
    Default  = 120,
    Min      = 10,
    Max      = 400,
    Rounding = 0,
    Suffix   = " deg",
})

CombatLeft:AddSlider("AimbotSmooth", {
    Text     = "Smoothness",
    Default  = 5,
    Min      = 0,
    Max      = 20,
    Rounding = 1,
})

CombatLeft:AddDropdown("AimbotPart", {
    Text    = "Target Part",
    Default = "Head",
    Values  = { "Head", "HumanoidRootPart", "Torso", "LeftArm", "RightArm" },
})

CombatRight:AddToggle("SilentAim", {
    Text    = "Silent Aim",
    Default = false,
    Risky   = true,
})

CombatRight:AddSlider("HitChance", {
    Text     = "Hit Chance",
    Default  = 100,
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
})

CombatRight:AddToggle("AutoShoot", {
    Text    = "Auto Shoot",
    Default = false,
})

CombatRight:AddCheckbox("PredictMovement", {
    Text    = "Predict Movement",
    Default = false,
})

CombatRight:AddDivider()

CombatRight:AddButton({
    Text = "Notify FOV",
    Func = function()
        Library:Notify({
            Title    = "Combat",
            Content  = "FOV saat ini: " .. tostring(Options.AimbotFOV.Value),
            Duration = 3,
        })
    end,
})

-- ─────────────────────────────────────────────────────────────
-- VISUAL TAB
-- ─────────────────────────────────────────────────────────────
local VisualLeft  = VisualTab:AddLeftGroupbox("ESP")
local VisualRight = VisualTab:AddRightGroupbox("Chams")

VisualLeft:AddToggle("ESPEnabled", {
    Text    = "Player ESP",
    Default = false,
})

VisualLeft:AddColorpicker("ESPColor", {
    Text    = "ESP Color",
    Default = Color3.fromRGB(124, 58, 237),
})

VisualLeft:AddColorpicker("ESPBoxColor", {
    Text    = "Box Color",
    Default = Color3.fromRGB(255, 255, 255),
})

VisualLeft:AddToggle("ESPNames", {
    Text    = "Show Names",
    Default = true,
})

VisualLeft:AddToggle("ESPHealth", {
    Text    = "Show Health",
    Default = true,
})

VisualLeft:AddSlider("ESPDistance", {
    Text     = "Max Distance",
    Default  = 1000,
    Min      = 50,
    Max      = 5000,
    Rounding = 0,
    Suffix   = " studs",
})

VisualRight:AddToggle("ChamsEnabled", {
    Text    = "Player Chams",
    Default = false,
})

VisualRight:AddColorpicker("ChamsColor", {
    Text    = "Chams Color",
    Default = Color3.fromRGB(74, 222, 128),
})

VisualRight:AddDropdown("ChamsMaterial", {
    Text    = "Material",
    Default = "Neon",
    Values  = { "Neon", "ForceField", "Glass", "SmoothPlastic" },
})

VisualRight:AddToggle("Fullbright", {
    Text    = "Fullbright",
    Default = false,
})

-- ─────────────────────────────────────────────────────────────
-- MISC TAB
-- ─────────────────────────────────────────────────────────────
local MiscLeft  = MiscTab:AddLeftGroupbox("Utilities")
local MiscRight = MiscTab:AddRightGroupbox("Input & Keybinds")

MiscLeft:AddDropdown("GameMode", {
    Text    = "Game Mode",
    Default = "Normal",
    Values  = { "Normal", "Creative", "Spectator", "Hardcore" },
})

MiscLeft:AddDropdown("ActiveFeatures", {
    Text       = "Active Features",
    Default    = { "ESP", "Speed" },
    Values     = { "ESP", "Speed", "Fly", "Noclip", "Aimbot", "Chams" },
    Multi      = true,
    Searchable = true,
})

MiscLeft:AddDivider()

MiscLeft:AddToggle("AutoFarm", {
    Text    = "Auto Farm",
    Default = false,
})

MiscLeft:AddSlider("FarmDelay", {
    Text     = "Farm Delay",
    Default  = 0.5,
    Min      = 0.1,
    Max      = 5,
    Rounding = 1,
    Suffix   = "s",
})

MiscRight:AddInput("TargetPlayer", {
    Text        = "Target Player",
    Default     = "",
    Placeholder = "Username...",
    Numeric     = false,
    Finished    = false,
})

MiscRight:AddInput("TeleportX", {
    Text        = "Teleport X",
    Default     = "0",
    Placeholder = "X coordinate",
    Numeric     = true,
})

MiscRight:AddDivider()

MiscRight:AddKeybind("FlyKey", {
    Text    = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Mode    = "Toggle",
})

MiscRight:AddKeybind("SprintKey", {
    Text    = "Sprint",
    Default = Enum.KeyCode.LeftShift,
    Mode    = "Hold",
})

MiscRight:AddKeybind("NoclipKey", {
    Text    = "Noclip Toggle",
    Default = Enum.KeyCode.V,
    Mode    = "Toggle",
})

-- ─────────────────────────────────────────────────────────────
-- SETTINGS TAB
-- SaveManager & ThemeManager otomatis buat UI di sini
-- ─────────────────────────────────────────────────────────────
local SettingsLeft  = SettingsTab:AddLeftGroupbox("General")
local SettingsRight = SettingsTab:AddRightGroupbox("About")

SettingsLeft:AddToggle("ShowCustomCursor", {
    Text    = "Custom Cursor",
    Default = false,
})

SettingsLeft:AddSlider("UIOpacity", {
    Text     = "UI Opacity",
    Default  = 100,
    Min      = 10,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
})

SettingsLeft:AddDivider()

SettingsLeft:AddButton({
    Text = "Unload Script",
    Func = function()
        Library:Notify({ Title = "Unloading", Content = "Script akan diunload...", Duration = 2 })
        task.wait(2)
        Library:Unload()
    end,
})

-- SaveManager build UI (kiri, di bawah General)
SaveManager:BuildConfigSection(SettingsTab)

-- ThemeManager build UI (kanan)
ThemeManager:ApplyToTab(SettingsTab)

SettingsRight:AddLabel("Obsidian Remake", false)
SettingsRight:AddLabel(
    "Version  : 1.0.1\nAuthor   : Obsydiee\nInspired : deividcomsono\n\nGitHub   : github.com/Obsydiee/ObsidianRemake",
    true
)

-- ─────────────────────────────────────────────────────────────
-- OnChanged Callbacks
-- PENTING: selalu taruh di BAWAH semua deklarasi UI
-- ─────────────────────────────────────────────────────────────
Toggles.GodMode:OnChanged(function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if value then
            char.Humanoid.MaxHealth = math.huge
            char.Humanoid.Health    = math.huge
        else
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health    = 100
        end
    end
end)

Toggles.InfiniteJump:OnChanged(function(value)
    if value then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

Options.WalkSpeed:OnChanged(function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

Options.JumpPower:OnChanged(function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

Options.FlyKey:OnClick(function()
    Library:Notify({ Title = "Fly", Content = "Fly toggled!", Duration = 2 })
end)

Options.NoclipKey:OnClick(function()
    Toggles.Noclip:SetValue(not Toggles.Noclip.Value)
end)

Options.SprintKey:OnClick(function()
    -- Hold mode: OnClick = saat tombol ditekan
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 50
    end
end)

Options.UIOpacity:OnChanged(function(value)
    -- Sesuaikan transparansi window
    local win = Library._Window
    if win then
        win.BackgroundTransparency = 1 - (value / 100)
    end
end)

Toggles.AimbotEnabled:OnChanged(function(value)
    statusLabel:SetText("Status: " .. (value and "Aimbot ON" or "Idle"))
end)

-- ── Muat config autoload terakhir ────────────────────────────
SaveManager:LoadAutoloadConfig()

-- ── Welcome notif ────────────────────────────────────────────
task.wait(0.5)
Library:Notify({
    Title    = "Obsidian Remake",
    Content  = "Script loaded! Tekan RightCtrl untuk toggle UI.",
    Duration = 5,
})
