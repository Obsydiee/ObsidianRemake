-- ╔══════════════════════════════════════════════════════════╗
-- ║       OBSIDIAN REMAKE — SaveManager  v1.0.1             ║
-- ║   Menyimpan & memuat konfigurasi user                   ║
-- ║   Full Lua 5.1 Compatible                               ║
-- ╚══════════════════════════════════════════════════════════╝

local SaveManager = {
    _library    = nil,
    _folder     = "ObsidianRemake",
    _subFolder  = nil,
    _ignored    = {},
    _configName = "default",
}

-- ── Helpers ──────────────────────────────────────────────────

local function GetFolderPath(self)
    local base = "ObsidianRemake-Configs/" .. self._folder
    if self._subFolder then
        base = base .. "/" .. self._subFolder
    end
    return base
end

-- Lua 5.1: tidak ada string:split(), pakai gmatch
local function SplitPath(path)
    local parts = {}
    for part in string.gmatch(path, "([^/]+)") do
        table.insert(parts, part)
    end
    return parts
end

local function EnsureFolder(path)
    if not isfolder or not makefolder then return end
    local parts   = SplitPath(path)
    local current = ""
    for _, part in ipairs(parts) do
        if current == "" then
            current = part
        else
            current = current .. "/" .. part
        end
        if not isfolder(current) then
            makefolder(current)
        end
    end
end

-- Serialize nilai ke tipe yang bisa di-JSON-kan
local function SerializeValue(val)
    local t = type(val)
    if t == "boolean" or t == "number" or t == "string" then
        return val
    elseif t == "userdata" then
        -- Color3
        if typeof(val) == "Color3" then
            return { __type = "Color3", R = val.R, G = val.G, B = val.B }
        end
        -- EnumItem (KeyCode dll.)
        if typeof(val) == "EnumItem" then
            return { __type = "EnumItem", value = tostring(val) }
        end
    elseif t == "table" then
        local copy = {}
        for k, v in next, val do
            copy[k] = SerializeValue(v)
        end
        return copy
    end
    return nil
end

-- Deserialize balik ke tipe aslinya
local function DeserializeValue(val)
    if type(val) == "table" then
        if val.__type == "Color3" then
            return Color3.new(val.R, val.G, val.B)
        elseif val.__type == "EnumItem" then
            -- Lua 5.1: pakai gmatch bukan :split()
            -- Format: "Enum.KeyCode.F"
            local parts = {}
            for p in string.gmatch(tostring(val.value), "([^%.]+)") do
                table.insert(parts, p)
            end
            if #parts == 3 then
                local ok, res = pcall(function()
                    return Enum[parts[2]][parts[3]]
                end)
                if ok and res then return res end
            end
            return Enum.KeyCode.Unknown
        else
            local copy = {}
            for k, v in next, val do
                copy[k] = DeserializeValue(v)
            end
            return copy
        end
    end
    return val
end

-- Cek apakah executor support filesystem
local function HasFileSystem()
    return (isfolder ~= nil) and (readfile ~= nil) and (writefile ~= nil)
end

-- ── API Utama ─────────────────────────────────────────────────

function SaveManager:SetLibrary(lib)
    self._library = lib
end

function SaveManager:SetFolder(folder)
    self._folder = folder
end

function SaveManager:SetSubFolder(sub)
    self._subFolder = sub
end

-- Tambahkan key yang tidak akan di-save
function SaveManager:IgnoreElements(...)
    local args = { ... }
    for _, v in ipairs(args) do
        self._ignored[v] = true
    end
end

function SaveManager:SaveConfig(name)
    name = name or self._configName

    if not self._library then
        warn("[SaveManager] Library belum di-set!")
        return
    end
    if not HasFileSystem() then
        warn("[SaveManager] Executor tidak support filesystem")
        if self._library then
            self._library:Notify({
                Title    = "SaveManager",
                Content  = "Executor tidak support filesystem!",
                Duration = 4,
            })
        end
        return
    end

    local path = GetFolderPath(self)
    EnsureFolder(path)

    local data = {}

    -- Simpan semua Toggles
    for k, obj in next, self._library.Toggles do
        if not self._ignored[k] then
            data["toggle_" .. k] = SerializeValue(obj.Value)
        end
    end

    -- Simpan semua Options
    for k, obj in next, self._library.Options do
        if not self._ignored[k] then
            data["option_" .. k] = SerializeValue(obj.Value)
        end
    end

    local encoded
    local ok, err = pcall(function()
        encoded = game:GetService("HttpService"):JSONEncode(data)
    end)
    if not ok then
        warn("[SaveManager] Gagal encode config:", err)
        return
    end

    local filePath = path .. "/" .. name .. ".json"
    local writeOk, writeErr = pcall(function()
        writefile(filePath, encoded)
    end)

    if not writeOk then
        warn("[SaveManager] Gagal tulis file:", writeErr)
        return
    end

    print("[SaveManager] Config disimpan:", filePath)
    self._library:Notify({
        Title    = "SaveManager",
        Content  = "Config \"" .. name .. "\" berhasil disimpan!",
        Duration = 3,
    })
end

function SaveManager:LoadConfig(name)
    name = name or self._configName

    if not self._library then
        warn("[SaveManager] Library belum di-set!")
        return
    end
    if not HasFileSystem() then
        warn("[SaveManager] Executor tidak support filesystem")
        return
    end

    local path     = GetFolderPath(self)
    local filePath = path .. "/" .. name .. ".json"

    if not isfile(filePath) then
        warn("[SaveManager] Config tidak ditemukan:", filePath)
        return
    end

    local content
    local readOk, readErr = pcall(function()
        content = readfile(filePath)
    end)
    if not readOk or not content then
        warn("[SaveManager] Gagal baca file:", readErr)
        return
    end

    local data
    local ok, err = pcall(function()
        data = game:GetService("HttpService"):JSONDecode(content)
    end)
    if not ok or not data then
        warn("[SaveManager] Gagal decode config:", err)
        return
    end

    -- Terapkan ke semua Toggles
    for k, obj in next, self._library.Toggles do
        local val = data["toggle_" .. k]
        if val ~= nil then
            pcall(function()
                obj:SetValue(DeserializeValue(val))
            end)
        end
    end

    -- Terapkan ke semua Options
    for k, obj in next, self._library.Options do
        local val = data["option_" .. k]
        if val ~= nil then
            pcall(function()
                obj:SetValue(DeserializeValue(val))
            end)
        end
    end

    print("[SaveManager] Config dimuat:", filePath)
    self._library:Notify({
        Title    = "SaveManager",
        Content  = "Config \"" .. name .. "\" berhasil dimuat!",
        Duration = 3,
    })
end

-- Ambil daftar nama config yang tersimpan
function SaveManager:ListConfigs()
    if not HasFileSystem() then return {} end
    local path = GetFolderPath(self)
    if not isfolder(path) then return {} end

    local configs = {}
    local ok, files = pcall(function() return listfiles(path) end)
    if not ok or not files then return {} end

    for _, file in ipairs(files) do
        -- Lua 5.1: string.match bukan :match()
        local name = string.match(file, "([^/\\]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
    return configs
end

-- Muat config bernama "autoload" (config yang di-auto-load)
function SaveManager:LoadAutoloadConfig()
    self:LoadConfig("autoload")
end

-- Simpan config saat ini sebagai autoload
function SaveManager:SetAutoloadConfig(name)
    name = name or self._configName
    if not HasFileSystem() then return end

    local path = GetFolderPath(self)
    EnsureFolder(path)

    local marker = path .. "/autoload_marker.txt"
    pcall(function()
        writefile(marker, name)
    end)

    if self._library then
        self._library:Notify({
            Title    = "SaveManager",
            Content  = "\"" .. name .. "\" diset sebagai autoload.",
            Duration = 3,
        })
    end
end

-- ── Buat UI di dalam Tab ─────────────────────────────────────
-- Dipanggil setelah semua elemen UI selesai dibuat
function SaveManager:BuildConfigSection(tab)
    local gb = tab:AddLeftGroupbox("Config Manager")

    gb:AddInput("SaveManager_ConfigName", {
        Text        = "Config Name",
        Default     = "default",
        Placeholder = "Nama config...",
        Finished    = false,
    })

    gb:AddDivider()

    gb:AddButton({
        Text = "Save Config",
        Func = function()
            local nameObj = self._library and self._library.Options["SaveManager_ConfigName"]
            local name    = (nameObj and nameObj.Value ~= "") and nameObj.Value or "default"
            self:SaveConfig(name)
        end,
    })

    gb:AddButton({
        Text = "Load Config",
        Func = function()
            local nameObj = self._library and self._library.Options["SaveManager_ConfigName"]
            local name    = (nameObj and nameObj.Value ~= "") and nameObj.Value or "default"
            self:LoadConfig(name)
        end,
    })

    gb:AddButton({
        Text = "Set as Autoload",
        Func = function()
            local nameObj = self._library and self._library.Options["SaveManager_ConfigName"]
            local name    = (nameObj and nameObj.Value ~= "") and nameObj.Value or "default"
            self:SetAutoloadConfig(name)
        end,
    })

    gb:AddDivider()

    local configDropdown = gb:AddDropdown("SaveManager_ConfigList", {
        Text    = "Saved Configs",
        Values  = self:ListConfigs(),
        Default = "",
    })

    gb:AddButton({
        Text = "Refresh List",
        Func = function()
            local list = self:ListConfigs()
            configDropdown:SetValues(list)
            if self._library then
                self._library:Notify({
                    Title    = "SaveManager",
                    Content  = "Ditemukan " .. tostring(#list) .. " config.",
                    Duration = 2,
                })
            end
        end,
    })

    gb:AddButton({
        Text = "Load Selected",
        Func = function()
            local sel = self._library and self._library.Options["SaveManager_ConfigList"]
            if sel and sel.Value ~= "" then
                -- Lua 5.1: pastikan Value adalah string
                self:LoadConfig(tostring(sel.Value))
            else
                if self._library then
                    self._library:Notify({
                        Title    = "SaveManager",
                        Content  = "Pilih config dari list dulu!",
                        Duration = 2,
                    })
                end
            end
        end,
    })
end

return SaveManager
