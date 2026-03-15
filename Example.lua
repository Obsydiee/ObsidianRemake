-- ╔══════════════════════════════════════════════════════════╗
-- ║         OBSIDIAN REMAKE — Example Script                ║
-- ║   Demonstrates semua fitur yang tersedia                ║
-- ╚══════════════════════════════════════════════════════════╝

-- Load Library
local repo    = "https://raw.githubusercontent.com/YOUR_USERNAME/ObsidianRemake/main/"
-- Atau load dari file lokal (di Roblox Studio):
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- Atau di Studio, require langsung:
-- local Library = require(script.Library)

local Options = Library.Options
local Toggles = Library.Toggles

-- ──────────────────────────────────────────────────────────────
-- BUAT WINDOW
-- ──────────────────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title        = "Obsidian Remake",
    Footer       = "v1.0.0 · Example",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center       = true,
    AutoShow     = true,
    Size         = UDim2.fromOffset(720, 500),
})

-- ──────────────────────────────────────────────────────────────
-- TABS
-- ──────────────────────────────────────────────────────────────
local MainTab     = Window:AddTab("Main",     "home")
local CombatTab   = Window:AddTab("Combat",   "sword")
local VisualTab   = Window:AddTab("Visual",   "eye")
local MiscTab     = Window:AddTab("Misc",     "wrench")
local SettingsTab = Window:AddTab("Settings", "settings")

-- ──────────────────────────────────────────────────────────────
-- MAIN TAB — Groupboxes
-- ──────────────────────────────────────────────────────────────
local LeftBox  = MainTab:AddLeftGroupbox("Player")
local RightBox = MainTab:AddRightGroupbox("Info")

-- ── Toggles ──
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

-- ── Slider ──
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

-- ── Divider ──
LeftBox:AddDivider()

-- ── Button ──
LeftBox:AddButton({
    Text    = "Teleport to Spawn",
    Tooltip = "Teleport ke spawn point",
    Func    = function()
        Library:Notify({
            Title   = "Teleport",
            Content = "Teleporting to spawn...",
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

-- ── Right side ──
RightBox:AddLabel("Obsidian Remake v1.0.0", false)
RightBox:AddLabel("Sebuah UI Library untuk Roblox\nyang terinspirasi dari Obsidian.\n\nFitur:\n• Toggle, Slider, Dropdown\n• Input, ColorPicker, Keybind\n• Tabbox, Notifikasi", true)

RightBox:AddDivider()

-- Status label yang bisa di-update
local statusLabel = RightBox:AddLabel("Status: Idle")

-- ──────────────────────────────────────────────────────────────
-- COMBAT TAB
-- ──────────────────────────────────────────────────────────────
local CombatLeft  = CombatTab:AddLeftGroupbox("Aimbot")
local CombatRight = CombatTab:AddRightGroupbox("Combat")

-- Toggle dengan ColorPicker (menggunakan Tabbox)
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
    Suffix   = "°",
})

CombatLeft:AddSlider("AimbotSmooth", {
    Text     = "Smoothness",
    Default  = 5,
    Min      = 0,
    Max      = 20,
    Rounding = 1,
})

CombatLeft:AddDropdown("AimbotPart", {
    Text   = "Target Part",
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

CombatRight:AddDivider()

CombatRight:AddButton({
    Text = "Notify Test",
    Func = function()
        Library:Notify({
            Title    = "Combat",
            Content  = "Aimbot aktif! FOV: " .. tostring(Options.AimbotFOV.Value),
            Duration = 4,
        })
    end,
})

-- ──────────────────────────────────────────────────────────────
-- VISUAL TAB — ESP & Colorpickers
-- ──────────────────────────────────────────────────────────────
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
    Text   = "Material",
    Default = "Neon",
    Values  = { "Neon", "ForceField", "Glass", "SmoothPlastic" },
})

VisualRight:AddToggle("Fullbright", {
    Text    = "Fullbright",
    Default = false,
})

-- ──────────────────────────────────────────────────────────────
-- MISC TAB — Dropdown, Input, Keybind
-- ──────────────────────────────────────────────────────────────
local MiscLeft  = MiscTab:AddLeftGroupbox("Utilities")
local MiscRight = MiscTab:AddRightGroupbox("Input & Keybinds")

-- Dropdown single
MiscLeft:AddDropdown("GameMode", {
    Text       = "Game Mode",
    Default    = "Normal",
    Values     = { "Normal", "Creative", "Spectator", "Hardcore" },
    Searchable = false,
})

-- Dropdown multi
MiscLeft:AddDropdown("ActiveFeatures", {
    Text   = "Active Features",
    Default = { "ESP", "Speed" },
    Values  = { "ESP", "Speed", "Fly", "Noclip", "Aimbot", "Chams" },
    Multi  = true,
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

-- Input
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

-- Keybinds
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

-- ──────────────────────────────────────────────────────────────
-- SETTINGS TAB — Tabbox example
-- ──────────────────────────────────────────────────────────────
local SettingsLeft  = SettingsTab:AddLeftGroupbox("UI Settings")
local SettingsRight = SettingsTab:AddRightGroupbox("About")

-- Tabbox dalam Settings
local SettingsTabbox = SettingsLeft:AddLeftTabbox and nil
-- (Tabbox on a Groupbox via parent column)

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

SettingsRight:AddLabel("Obsidian Remake", false)
SettingsRight:AddLabel("Version: 1.0.0\nAuthor: Your Name\nInspired by: deividcomsono/Obsidian\n\nGitHub: github.com/YOUR_USERNAME/ObsidianRemake", true)

-- ──────────────────────────────────────────────────────────────
-- OnChanged callbacks — SELALU di bawah deklarasi UI
-- ──────────────────────────────────────────────────────────────
Toggles.GodMode:OnChanged(function(value)
    -- Contoh: set MaxHealth sangat tinggi
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = value and math.huge or 100
        char.Humanoid.Health    = value and math.huge or 100
    end
end)

Toggles.InfiniteJump:OnChanged(function(value)
    -- Implementasi infinite jump
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

-- ──────────────────────────────────────────────────────────────
-- Welcome notification
-- ──────────────────────────────────────────────────────────────
task.wait(1)
Library:Notify({
    Title    = "Obsidian Remake",
    Content  = "Script berhasil diload! Tekan RightCtrl untuk toggle UI.",
    Duration = 5,
})
