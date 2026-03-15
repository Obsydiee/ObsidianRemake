-- ╔══════════════════════════════════════════════╗
-- ║      OBSIDIAN REMAKE — ThemeManager          ║
-- ║   Ganti & simpan tema warna UI               ║
-- ╚══════════════════════════════════════════════╝

local ThemeManager = {
    _library = nil,
    _folder  = "ObsidianRemake",
}

-- ─── Built-in Themes ─────────────────────────────────────────
ThemeManager.BuiltinThemes = {

    ["Obsidian"] = {
        Background   = Color3.fromRGB(14, 14, 21),
        Header       = Color3.fromRGB(20, 20, 32),
        TabBar       = Color3.fromRGB(18, 18, 28),
        TabActive    = Color3.fromRGB(30, 22, 52),
        Accent       = Color3.fromRGB(124, 58, 237),
        GroupBG      = Color3.fromRGB(18, 18, 28),
        GroupBorder  = Color3.fromRGB(40, 40, 62),
        Text         = Color3.fromRGB(220, 220, 240),
        TextDim      = Color3.fromRGB(110, 110, 150),
        ToggleOn     = Color3.fromRGB(124, 58, 237),
        SliderFill   = Color3.fromRGB(124, 58, 237),
    },

    ["Midnight Blue"] = {
        Background   = Color3.fromRGB(10, 14, 26),
        Header       = Color3.fromRGB(14, 20, 38),
        TabBar       = Color3.fromRGB(12, 18, 32),
        TabActive    = Color3.fromRGB(18, 30, 60),
        Accent       = Color3.fromRGB(59, 130, 246),
        GroupBG      = Color3.fromRGB(12, 18, 34),
        GroupBorder  = Color3.fromRGB(30, 48, 80),
        Text         = Color3.fromRGB(210, 224, 255),
        TextDim      = Color3.fromRGB(100, 130, 180),
        ToggleOn     = Color3.fromRGB(59, 130, 246),
        SliderFill   = Color3.fromRGB(59, 130, 246),
    },

    ["Emerald"] = {
        Background   = Color3.fromRGB(10, 20, 14),
        Header       = Color3.fromRGB(14, 28, 20),
        TabBar       = Color3.fromRGB(12, 24, 16),
        TabActive    = Color3.fromRGB(16, 38, 26),
        Accent       = Color3.fromRGB(16, 185, 129),
        GroupBG      = Color3.fromRGB(12, 22, 16),
        GroupBorder  = Color3.fromRGB(30, 60, 42),
        Text         = Color3.fromRGB(200, 240, 220),
        TextDim      = Color3.fromRGB(90, 150, 110),
        ToggleOn     = Color3.fromRGB(16, 185, 129),
        SliderFill   = Color3.fromRGB(16, 185, 129),
    },

    ["Rose"] = {
        Background   = Color3.fromRGB(22, 10, 14),
        Header       = Color3.fromRGB(32, 14, 20),
        TabBar       = Color3.fromRGB(28, 12, 16),
        TabActive    = Color3.fromRGB(50, 18, 28),
        Accent       = Color3.fromRGB(244, 63, 94),
        GroupBG      = Color3.fromRGB(26, 12, 16),
        GroupBorder  = Color3.fromRGB(70, 28, 40),
        Text         = Color3.fromRGB(255, 220, 228),
        TextDim      = Color3.fromRGB(160, 90, 110),
        ToggleOn     = Color3.fromRGB(244, 63, 94),
        SliderFill   = Color3.fromRGB(244, 63, 94),
    },

    ["Mono"] = {
        Background   = Color3.fromRGB(12, 12, 14),
        Header       = Color3.fromRGB(18, 18, 22),
        TabBar       = Color3.fromRGB(16, 16, 18),
        TabActive    = Color3.fromRGB(28, 28, 34),
        Accent       = Color3.fromRGB(200, 200, 220),
        GroupBG      = Color3.fromRGB(16, 16, 20),
        GroupBorder  = Color3.fromRGB(42, 42, 52),
        Text         = Color3.fromRGB(230, 230, 240),
        TextDim      = Color3.fromRGB(120, 120, 140),
        ToggleOn     = Color3.fromRGB(180, 180, 200),
        SliderFill   = Color3.fromRGB(180, 180, 200),
    },

    ["Cyberpunk"] = {
        Background   = Color3.fromRGB(8, 8, 16),
        Header       = Color3.fromRGB(12, 12, 24),
        TabBar       = Color3.fromRGB(10, 10, 20),
        TabActive    = Color3.fromRGB(16, 16, 36),
        Accent       = Color3.fromRGB(250, 204, 21),
        GroupBG      = Color3.fromRGB(10, 10, 20),
        GroupBorder  = Color3.fromRGB(60, 50, 10),
        Text         = Color3.fromRGB(255, 245, 200),
        TextDim      = Color3.fromRGB(150, 130, 60),
        ToggleOn     = Color3.fromRGB(250, 204, 21),
        SliderFill   = Color3.fromRGB(250, 204, 21),
    },
}

-- ─── Apply theme to Library ───────────────────────────────────
function ThemeManager:ApplyTheme(name)
    if not self._library then
        warn("[ThemeManager] Library belum di-set!")
        return
    end

    local theme = self.BuiltinThemes[name]
    if not theme then
        warn("[ThemeManager] Tema tidak ditemukan:", name)
        return
    end

    -- Merge into Library.Theme
    for k, v in next, theme do
        self._library.Theme[k] = v
    end

    if self._library then
        self._library:Notify({
            Title   = "Theme",
            Content = 'Tema "' .. name .. '" diterapkan! Restart script untuk efek penuh.',
            Duration = 4,
        })
    end
end

function ThemeManager:SetLibrary(lib)
    self._library = lib
end

function ThemeManager:SetFolder(folder)
    self._folder = folder
end

function ThemeManager:GetThemeNames()
    local names = {}
    for k in next, self.BuiltinThemes do
        table.insert(names, k)
    end
    table.sort(names)
    return names
end

-- ─── Build UI in a tab ───────────────────────────────────────
function ThemeManager:ApplyToTab(tab)
    local gb = tab:AddRightGroupbox("Theme Manager")

    local themeNames = self:GetThemeNames()

    gb:AddDropdown("ThemeManager_Theme", {
        Text   = "Select Theme",
        Values = themeNames,
        Default = themeNames[1] or "Obsidian",
    })

    gb:AddButton({
        Text = "🎨 Apply Theme",
        Func = function()
            local sel = self._library and self._library.Options["ThemeManager_Theme"]
            if sel and sel.Value then
                self:ApplyTheme(sel.Value)
            end
        end,
    })

    gb:AddDivider()
    gb:AddLabel("Catatan: Ubah tema lalu restart\nscript untuk mendapat efek penuh.", true)
end

return ThemeManager
