-- ╔══════════════════════════════════════════════════════════╗
-- ║      OBSIDIAN REMAKE — ThemeManager  v1.0.1             ║
-- ║   Ganti & simpan tema warna UI                          ║
-- ║   Full Lua 5.1 Compatible                               ║
-- ╚══════════════════════════════════════════════════════════╝

local ThemeManager = {
    _library = nil,
    _folder  = "ObsidianRemake",
}

-- ── Built-in Themes ───────────────────────────────────────────
-- Setiap tema hanya perlu override key yang berubah.
-- Key yang tersedia sama persis dengan Library.Theme.
ThemeManager.BuiltinThemes = {

    ["Obsidian"] = {
        Background   = Color3.fromRGB(14, 14, 21),
        Header       = Color3.fromRGB(20, 20, 32),
        TabBar       = Color3.fromRGB(18, 18, 28),
        TabActive    = Color3.fromRGB(30, 22, 52),
        TabInactive  = Color3.fromRGB(22, 22, 34),
        Accent       = Color3.fromRGB(124, 58, 237),
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
        Dropdown     = Color3.fromRGB(16, 16, 26),
        DropdownItem = Color3.fromRGB(22, 22, 34),
        NotifBG      = Color3.fromRGB(20, 20, 32),
        NotifAccent  = Color3.fromRGB(124, 58, 237),
    },

    ["Midnight Blue"] = {
        Background   = Color3.fromRGB(10, 14, 26),
        Header       = Color3.fromRGB(14, 20, 38),
        TabBar       = Color3.fromRGB(12, 18, 32),
        TabActive    = Color3.fromRGB(18, 30, 60),
        TabInactive  = Color3.fromRGB(16, 22, 40),
        Accent       = Color3.fromRGB(59, 130, 246),
        GroupBG      = Color3.fromRGB(12, 18, 34),
        GroupBorder  = Color3.fromRGB(30, 48, 80),
        GroupHeader  = Color3.fromRGB(16, 24, 44),
        Element      = Color3.fromRGB(18, 26, 50),
        ElementHover = Color3.fromRGB(24, 36, 64),
        Text         = Color3.fromRGB(210, 224, 255),
        TextDim      = Color3.fromRGB(100, 130, 180),
        TextDisabled = Color3.fromRGB(50, 70, 110),
        ToggleOn     = Color3.fromRGB(59, 130, 246),
        ToggleOff    = Color3.fromRGB(30, 50, 90),
        SliderFill   = Color3.fromRGB(59, 130, 246),
        SliderBG     = Color3.fromRGB(24, 40, 72),
        Divider      = Color3.fromRGB(24, 40, 72),
        Dropdown     = Color3.fromRGB(10, 16, 30),
        DropdownItem = Color3.fromRGB(16, 24, 44),
        NotifBG      = Color3.fromRGB(12, 18, 34),
        NotifAccent  = Color3.fromRGB(59, 130, 246),
    },

    ["Emerald"] = {
        Background   = Color3.fromRGB(10, 20, 14),
        Header       = Color3.fromRGB(14, 28, 20),
        TabBar       = Color3.fromRGB(12, 24, 16),
        TabActive    = Color3.fromRGB(16, 38, 26),
        TabInactive  = Color3.fromRGB(14, 28, 20),
        Accent       = Color3.fromRGB(16, 185, 129),
        GroupBG      = Color3.fromRGB(12, 22, 16),
        GroupBorder  = Color3.fromRGB(30, 60, 42),
        GroupHeader  = Color3.fromRGB(14, 28, 20),
        Element      = Color3.fromRGB(16, 30, 22),
        ElementHover = Color3.fromRGB(20, 40, 28),
        Text         = Color3.fromRGB(200, 240, 220),
        TextDim      = Color3.fromRGB(90, 150, 110),
        TextDisabled = Color3.fromRGB(50, 80, 60),
        ToggleOn     = Color3.fromRGB(16, 185, 129),
        ToggleOff    = Color3.fromRGB(24, 60, 44),
        SliderFill   = Color3.fromRGB(16, 185, 129),
        SliderBG     = Color3.fromRGB(20, 50, 36),
        Divider      = Color3.fromRGB(20, 50, 36),
        Dropdown     = Color3.fromRGB(10, 18, 12),
        DropdownItem = Color3.fromRGB(14, 26, 18),
        NotifBG      = Color3.fromRGB(12, 22, 16),
        NotifAccent  = Color3.fromRGB(16, 185, 129),
    },

    ["Rose"] = {
        Background   = Color3.fromRGB(22, 10, 14),
        Header       = Color3.fromRGB(32, 14, 20),
        TabBar       = Color3.fromRGB(28, 12, 16),
        TabActive    = Color3.fromRGB(50, 18, 28),
        TabInactive  = Color3.fromRGB(32, 14, 20),
        Accent       = Color3.fromRGB(244, 63, 94),
        GroupBG      = Color3.fromRGB(26, 12, 16),
        GroupBorder  = Color3.fromRGB(70, 28, 40),
        GroupHeader  = Color3.fromRGB(32, 14, 22),
        Element      = Color3.fromRGB(36, 16, 22),
        ElementHover = Color3.fromRGB(48, 20, 30),
        Text         = Color3.fromRGB(255, 220, 228),
        TextDim      = Color3.fromRGB(160, 90, 110),
        TextDisabled = Color3.fromRGB(80, 40, 55),
        ToggleOn     = Color3.fromRGB(244, 63, 94),
        ToggleOff    = Color3.fromRGB(70, 28, 40),
        SliderFill   = Color3.fromRGB(244, 63, 94),
        SliderBG     = Color3.fromRGB(60, 24, 34),
        Divider      = Color3.fromRGB(60, 24, 34),
        Dropdown     = Color3.fromRGB(18, 8, 12),
        DropdownItem = Color3.fromRGB(28, 12, 18),
        NotifBG      = Color3.fromRGB(22, 10, 14),
        NotifAccent  = Color3.fromRGB(244, 63, 94),
    },

    ["Mono"] = {
        Background   = Color3.fromRGB(12, 12, 14),
        Header       = Color3.fromRGB(18, 18, 22),
        TabBar       = Color3.fromRGB(16, 16, 18),
        TabActive    = Color3.fromRGB(28, 28, 34),
        TabInactive  = Color3.fromRGB(20, 20, 24),
        Accent       = Color3.fromRGB(200, 200, 220),
        GroupBG      = Color3.fromRGB(16, 16, 20),
        GroupBorder  = Color3.fromRGB(42, 42, 52),
        GroupHeader  = Color3.fromRGB(20, 20, 26),
        Element      = Color3.fromRGB(24, 24, 30),
        ElementHover = Color3.fromRGB(32, 32, 40),
        Text         = Color3.fromRGB(230, 230, 240),
        TextDim      = Color3.fromRGB(120, 120, 140),
        TextDisabled = Color3.fromRGB(60, 60, 75),
        ToggleOn     = Color3.fromRGB(180, 180, 200),
        ToggleOff    = Color3.fromRGB(50, 50, 65),
        SliderFill   = Color3.fromRGB(180, 180, 200),
        SliderBG     = Color3.fromRGB(40, 40, 52),
        Divider      = Color3.fromRGB(40, 40, 52),
        Dropdown     = Color3.fromRGB(10, 10, 14),
        DropdownItem = Color3.fromRGB(18, 18, 22),
        NotifBG      = Color3.fromRGB(16, 16, 20),
        NotifAccent  = Color3.fromRGB(180, 180, 200),
    },

    ["Cyberpunk"] = {
        Background   = Color3.fromRGB(8, 8, 16),
        Header       = Color3.fromRGB(12, 12, 24),
        TabBar       = Color3.fromRGB(10, 10, 20),
        TabActive    = Color3.fromRGB(28, 24, 8),
        TabInactive  = Color3.fromRGB(14, 14, 26),
        Accent       = Color3.fromRGB(250, 204, 21),
        GroupBG      = Color3.fromRGB(10, 10, 20),
        GroupBorder  = Color3.fromRGB(60, 50, 10),
        GroupHeader  = Color3.fromRGB(14, 14, 28),
        Element      = Color3.fromRGB(16, 16, 30),
        ElementHover = Color3.fromRGB(26, 22, 8),
        Text         = Color3.fromRGB(255, 245, 200),
        TextDim      = Color3.fromRGB(150, 130, 60),
        TextDisabled = Color3.fromRGB(70, 60, 20),
        ToggleOn     = Color3.fromRGB(250, 204, 21),
        ToggleOff    = Color3.fromRGB(50, 42, 10),
        SliderFill   = Color3.fromRGB(250, 204, 21),
        SliderBG     = Color3.fromRGB(40, 34, 8),
        Divider      = Color3.fromRGB(40, 34, 8),
        Dropdown     = Color3.fromRGB(6, 6, 14),
        DropdownItem = Color3.fromRGB(12, 12, 22),
        NotifBG      = Color3.fromRGB(10, 10, 20),
        NotifAccent  = Color3.fromRGB(250, 204, 21),
    },
}

-- ── API ───────────────────────────────────────────────────────

function ThemeManager:SetLibrary(lib)
    self._library = lib
end

function ThemeManager:SetFolder(folder)
    self._folder = folder
end

-- Ambil list nama tema (sorted A-Z)
function ThemeManager:GetThemeNames()
    local names = {}
    for k in next, self.BuiltinThemes do
        table.insert(names, k)
    end
    table.sort(names)
    return names
end

-- Terapkan tema berdasarkan nama ke Library.Theme
-- Catatan: perubahan warna tidak langsung berlaku pada UI yang
-- sudah terbuat. Restart script untuk efek penuh.
function ThemeManager:ApplyTheme(name)
    if not self._library then
        warn("[ThemeManager] Library belum di-set!")
        return false
    end

    local theme = self.BuiltinThemes[name]
    if not theme then
        warn("[ThemeManager] Tema tidak ditemukan: " .. tostring(name))
        return false
    end

    -- Merge semua key tema ke Library.Theme
    for k, v in next, theme do
        self._library.Theme[k] = v
    end

    print("[ThemeManager] Tema diterapkan:", name)

    self._library:Notify({
        Title    = "Theme Manager",
        Content  = "Tema \"" .. name .. "\" diterapkan!\nRestart script untuk efek penuh.",
        Duration = 4,
    })

    return true
end

-- Simpan preferensi tema ke file (opsional, butuh filesystem)
function ThemeManager:SaveTheme(name)
    if not writefile or not isfolder then return end
    local path = "ObsidianRemake-Configs/" .. self._folder
    if not isfolder(path) then
        -- buat folder jika belum ada
        local parts = {}
        for p in string.gmatch(path, "([^/]+)") do
            table.insert(parts, p)
        end
        local cur = ""
        for _, p in ipairs(parts) do
            cur = cur == "" and p or (cur .. "/" .. p)
            if not isfolder(cur) then makefolder(cur) end
        end
    end
    pcall(function()
        writefile(path .. "/theme.txt", name)
    end)
end

-- Muat preferensi tema dari file
function ThemeManager:LoadSavedTheme()
    if not readfile or not isfile then return end
    local path = "ObsidianRemake-Configs/" .. self._folder .. "/theme.txt"
    if not isfile(path) then return end
    local ok, name = pcall(function() return readfile(path) end)
    if ok and name and name ~= "" then
        -- Lua 5.1: string.gsub untuk trim whitespace
        name = string.gsub(name, "^%s*(.-)%s*$", "%1")
        self:ApplyTheme(name)
    end
end

-- ── Buat UI di dalam Tab ─────────────────────────────────────
function ThemeManager:ApplyToTab(tab)
    local gb         = tab:AddRightGroupbox("Theme Manager")
    local themeNames = self:GetThemeNames()

    -- Default ke "Obsidian" kalau ada, atau item pertama
    local defaultTheme = "Obsidian"
    local foundDefault = false
    for _, n in ipairs(themeNames) do
        if n == defaultTheme then
            foundDefault = true
            break
        end
    end
    if not foundDefault then
        defaultTheme = themeNames[1] or ""
    end

    gb:AddDropdown("ThemeManager_Theme", {
        Text    = "Select Theme",
        Values  = themeNames,
        Default = defaultTheme,
    })

    gb:AddButton({
        Text = "Apply Theme",
        Func = function()
            local sel = self._library and self._library.Options["ThemeManager_Theme"]
            if sel and sel.Value and sel.Value ~= "" then
                local ok = self:ApplyTheme(tostring(sel.Value))
                if ok then
                    self:SaveTheme(tostring(sel.Value))
                end
            else
                if self._library then
                    self._library:Notify({
                        Title    = "Theme Manager",
                        Content  = "Pilih tema dulu dari dropdown!",
                        Duration = 2,
                    })
                end
            end
        end,
    })

    gb:AddDivider()

    gb:AddLabel(
        "Pilih tema lalu klik Apply.\nRestart script untuk efek penuh.",
        true
    )

    -- Auto-load tema tersimpan saat UI dibuat
    self:LoadSavedTheme()
end

return ThemeManager
