-- ╔══════════════════════════════════════════════╗
-- ║       OBSIDIAN REMAKE — SaveManager          ║
-- ║   Menyimpan & memuat konfigurasi user        ║
-- ╚══════════════════════════════════════════════╝

local SaveManager = {
    _library    = nil,
    _folder     = "ObsidianRemake",
    _subFolder  = nil,
    _ignored    = {},
    _configName = "default",
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ─── Helpers ─────────────────────────────────────────────────
local function GetFolderPath(self)
    local base = "ObsidianRemake-Configs/" .. self._folder
    if self._subFolder then
        base = base .. "/" .. self._subFolder
    end
    return base
end

local function EnsureFolder(path)
    local parts = path:split("/")
    local current = ""
    for _, part in ipairs(parts) do
        current = current == "" and part or (current .. "/" .. part)
        if not isfolder(current) then
            makefolder(current)
        end
    end
end

local function SerializeValue(val)
    local t = type(val)
    if t == "boolean" or t == "number" or t == "string" then
        return val
    elseif t == "userdata" then
        -- Color3
        if typeof(val) == "Color3" then
            return { __type = "Color3", R = val.R, G = val.G, B = val.B }
        end
        -- EnumItem (KeyCode, etc.)
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

local function DeserializeValue(val)
    if type(val) == "table" then
        if val.__type == "Color3" then
            return Color3.new(val.R, val.G, val.B)
        elseif val.__type == "EnumItem" then
            -- parse "Enum.KeyCode.F" style
            local parts = val.value:split(".")
            if #parts == 3 then
                local ok, res = pcall(function()
                    return Enum[parts[2]][parts[3]]
                end)
                if ok then return res end
            end
            return Enum.KeyCode.Unknown
        else
            local copy = {}
            for k, v in next, val do copy[k] = DeserializeValue(v) end
            return copy
        end
    end
    return val
end

-- ─── API ─────────────────────────────────────────────────────

function SaveManager:SetLibrary(lib)
    self._library = lib
end

function SaveManager:SetFolder(folder)
    self._folder = folder
end

function SaveManager:SetSubFolder(sub)
    self._subFolder = sub
end

function SaveManager:IgnoreElements(...)
    for _, v in ipairs({...}) do
        self._ignored[v] = true
    end
end

function SaveManager:SaveConfig(name)
    name = name or self._configName
    if not self._library then
        warn("[SaveManager] Library belum di-set!")
        return
    end

    local path = GetFolderPath(self)
    if not (isfolder and writefile) then
        warn("[SaveManager] Executor tidak support file system")
        return
    end

    EnsureFolder(path)

    local data = {}

    -- Save Toggles
    for k, obj in next, self._library.Toggles do
        if not self._ignored[k] then
            data["toggle_" .. k] = SerializeValue(obj.Value)
        end
    end

    -- Save Options
    for k, obj in next, self._library.Options do
        if not self._ignored[k] then
            data["option_" .. k] = SerializeValue(obj.Value)
        end
    end

    local encoded
    local ok, err = pcall(function()
        -- Basic JSON-like encoding using game's HttpService
        encoded = game:GetService("HttpService"):JSONEncode(data)
    end)

    if not ok then
        warn("[SaveManager] Gagal encode config:", err)
        return
    end

    local filePath = path .. "/" .. name .. ".json"
    writefile(filePath, encoded)
    print("[SaveManager] Config disimpan:", filePath)

    if self._library then
        self._library:Notify({
            Title   = "SaveManager",
            Content = 'Config "' .. name .. '" berhasil disimpan!',
            Duration = 3,
        })
    end
end

function SaveManager:LoadConfig(name)
    name = name or self._configName
    if not self._library then
        warn("[SaveManager] Library belum di-set!")
        return
    end

    local path = GetFolderPath(self)
    if not (isfile and readfile) then
        warn("[SaveManager] Executor tidak support file system")
        return
    end

    local filePath = path .. "/" .. name .. ".json"
    if not isfile(filePath) then
        warn("[SaveManager] Config tidak ditemukan:", filePath)
        return
    end

    local content = readfile(filePath)
    local data
    local ok, err = pcall(function()
        data = game:GetService("HttpService"):JSONDecode(content)
    end)

    if not ok or not data then
        warn("[SaveManager] Gagal decode config:", err)
        return
    end

    -- Load Toggles
    for k, obj in next, self._library.Toggles do
        local val = data["toggle_" .. k]
        if val ~= nil then
            pcall(function() obj:SetValue(DeserializeValue(val)) end)
        end
    end

    -- Load Options
    for k, obj in next, self._library.Options do
        local val = data["option_" .. k]
        if val ~= nil then
            pcall(function() obj:SetValue(DeserializeValue(val)) end)
        end
    end

    print("[SaveManager] Config dimuat:", filePath)

    if self._library then
        self._library:Notify({
            Title   = "SaveManager",
            Content = 'Config "' .. name .. '" berhasil dimuat!',
            Duration = 3,
        })
    end
end

function SaveManager:ListConfigs()
    local path = GetFolderPath(self)
    if not listfiles then return {} end
    if not isfolder(path) then return {} end

    local configs = {}
    for _, file in ipairs(listfiles(path)) do
        local name = file:match("([^/\\]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
    return configs
end

function SaveManager:LoadAutoloadConfig()
    self:LoadConfig("autoload")
end

-- ─── Build UI section in a tab ───────────────────────────────
function SaveManager:BuildConfigSection(tab)
    local gb = tab:AddLeftGroupbox("Config Manager")

    -- Config name input
    gb:AddInput("SaveManager_ConfigName", {
        Text        = "Config Name",
        Default     = "default",
        Placeholder = "Nama config...",
        Finished    = false,
    })

    gb:AddDivider()

    gb:AddButton({
        Text = "💾 Save Config",
        Func = function()
            local nameObj = self._library and self._library.Options["SaveManager_ConfigName"]
            local name    = nameObj and nameObj.Value or "default"
            self:SaveConfig(name)
        end,
    })

    gb:AddButton({
        Text = "📂 Load Config",
        Func = function()
            local nameObj = self._library and self._library.Options["SaveManager_ConfigName"]
            local name    = nameObj and nameObj.Value or "default"
            self:LoadConfig(name)
        end,
    })

    gb:AddButton({
        Text = "🔄 Load Autoload",
        Func = function()
            self:LoadAutoloadConfig()
        end,
    })

    -- Config list dropdown (refresh on open)
    local configDropdown = gb:AddDropdown("SaveManager_ConfigList", {
        Text   = "Saved Configs",
        Values = self:ListConfigs(),
        Default = "",
    })

    gb:AddButton({
        Text = "🔃 Refresh List",
        Func = function()
            local list = self:ListConfigs()
            configDropdown:SetValues(list)
            if self._library then
                self._library:Notify({
                    Title   = "SaveManager",
                    Content = "Ditemukan " .. #list .. " config.",
                    Duration = 2,
                })
            end
        end,
    })
end

return SaveManager
