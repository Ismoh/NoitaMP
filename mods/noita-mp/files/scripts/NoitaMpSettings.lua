--- NoitaMpSettings: Replacement for Noita ModSettings.
--- @class NoitaMpSettings
local NoitaMpSettings     = {
    --[[ Imports ]]

    ---@type CustomProfiler
    customProfiler = nil,
    ---@type Gui
    gui = nil,
    ---@type FileUtils
    fileUtils = nil,
    ---@type json
    json = nil,
    ---@type LuaFileSystem
    lfs = nil,
    ---@type Logger
    logger = nil,
    ---@type Utils
    utils = nil,
    ---@type winapi
    winapi = nil,

    --[[ Attributes ]]

    ---Settings cache. Makes it possible to access settings without reading the file every time.
    cachedSettings = {}
}

---Converts a value to the given dataType.
---@private
---@param self NoitaMpSettings required
---@param value any required
---@param dataType string required! Must be one of "boolean" or "number". If not set, "string" is default.
---@return boolean|number|string value converted to dataType
local convertToDataType   = function(self, value, dataType)
    local cpc = self.customProfiler:start("NoitaMpSettings.convertToDataType")
    if not self.utils.IsEmpty(dataType) then
        if dataType == "boolean" then
            if self.utils.IsEmpty(value) then
                self.customProfiler:stop("NoitaMpSettings.convertToDataType", cpc)
                return false
            end
            self.customProfiler:stop("NoitaMpSettings.convertToDataType", cpc)
            return toBoolean(value)
        end
        if dataType == "number" then
            if self.utils.IsEmpty(value) then
                self.customProfiler:stop("NoitaMpSettings.convertToDataType", cpc)
                return 0
            end
            self.customProfiler:stop("NoitaMpSettings.convertToDataType", cpc)
            return tonumber(value)
        end
    end
    self.customProfiler:stop("NoitaMpSettings.convertToDataType", cpc)
    return tostring(value)
end

local once                = false
---Returns the path to the settings file.
---@private
---@param self NoitaMpSettings required
---@return string path
local getSettingsFilePath = function(self)
    local path = ("%s%ssettings.json"):format(self.fileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator)

    if self:isMoreThanOneNoitaProcessRunning() then
        local defaultSettings = nil
        if self.fileUtils.Exists(path) and not once then
            defaultSettings = self.fileUtils.ReadFile(path)
        end
        path = ("%s%slocal%ssettings-%s.json")
            :format(self.fileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pathSeparator, self.winapi.get_current_pid())
        if defaultSettings then
            self.fileUtils.WriteFile(path, defaultSettings)
            once = true
        end
    end
    return path
end

---Checks if more than one Noita process is running.
---@return boolean true if more than one Noita process is running.
function NoitaMpSettings:isMoreThanOneNoitaProcessRunning()
    local cpc = self.customProfiler:start("NoitaMpSettings.isMoreThanOneNoitaProcessRunning")
    local pids = self.winapi.get_processes()
    local noitaCount = 0
    for _, pid in ipairs(pids) do
        local P = self.winapi.process_from_id(pid)
        local name = P:get_process_name(true)
        if name and string.contains(name, ("Noita%snoita"):format(pathSeparator)) then
            noitaCount = noitaCount + 1
        end
        P:close()
    end
    self.customProfiler:stop("NoitaMpSettings.isMoreThanOneNoitaProcessRunning", cpc)
    return noitaCount > 1
end

---Removes all settings and creates a new settings file.
function NoitaMpSettings:clearAndCreateSettings()
    local cpc         = self.customProfiler:start("NoitaMpSettings.clearAndCreateSettings")
    local settingsDir = ("%s%slocal"):format(self.fileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator) --FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory()
    if self.fileUtils.Exists(settingsDir) then
        self.fileUtils.RemoveContentOfDirectory(settingsDir)
        self.logger:info(self.logger.channels.initialize, ("Removed old settings in '%s'!"):format(settingsDir))
    else
        self.lfs.mkdir(settingsDir)
        self.logger:info(self.logger.channels.initialize, ("Created settings directory in '%s'!"):format(settingsDir))
    end
    self.customProfiler:stop("NoitaMpSettings.clearAndCreateSettings", cpc)
end

---Sets a setting. Saves the settings to the settings file and returns the new updated cached settings.
---@param key string required
---@param value any required
---@return table self.cachedSettings
function NoitaMpSettings:set(key, value)
    local cpc = self.customProfiler:start("NoitaMpSettings.set")
    if self.utils.IsEmpty(key) or type(key) ~= "string" then
        error(("'key' must not be nil or is not type of string!"):format(key), 2)
    end

    local settingsFilePath = getSettingsFilePath(self)
    if self.utils.IsEmpty(self.cachedSettings) or not self.fileUtils.Exists(settingsFilePath) then
        self:load()
    end

    self.cachedSettings[key] = value

    self.customProfiler:stop("NoitaMpSettings.set", cpc)
    return self.cachedSettings
end

---Returns a setting from the settings file converted to the given dataType. If the setting does not exist, it will be created with the default empty value.
---@param key string required
---@param dataType string required! Must be one of "boolean" or "number". If not set, "string" is default.
---@return boolean|string|number
function NoitaMpSettings:get(key, dataType)
    local cpc = self.customProfiler:start("NoitaMpSettings.get")

    local settingsFilePath = getSettingsFilePath(self)
    if self.utils.IsEmpty(self.cachedSettings) or not self.fileUtils.Exists(settingsFilePath) then
        self:load()
    end

    if self.utils.IsEmpty(self.cachedSettings[key]) then
        --error(("Unable to find '%s' in NoitaMpSettings: %s"):format(key, contentString), 2)
        self.customProfiler:stop("NoitaMpSettings.get", cpc)
        return convertToDataType(self, "", dataType)
    end
    self.customProfiler:stop("NoitaMpSettings.get", cpc)
    return convertToDataType(self, self.cachedSettings[key], dataType)
end

---Loads the settings from the settings file and put those into the cached settings.
function NoitaMpSettings:load()
    local settingsFilePath = getSettingsFilePath(self)

    if not self.fileUtils.Exists(settingsFilePath) then
        self:save()
    end

    local contentString = self.fileUtils.ReadFile(settingsFilePath)
    self.cachedSettings = self.json.decode(contentString)
end

function NoitaMpSettings:save()
    local settingsFilePath = getSettingsFilePath(self)

    if self.utils.IsEmpty(self.cachedSettings["pid"]) then
        self.cachedSettings["pid"] = self.winapi.get_current_pid()
    end

    self.fileUtils.WriteFile(settingsFilePath, self.json.encode(self.cachedSettings))
    if self.gui then
        self.gui.setShowSettingsSaved(true)
    end
end

---NoitaMpSettings constructor.
---@param noitaMpSettings NoitaMpSettings|nil
---@param customProfiler CustomProfiler|nil
---@param gui Gui required
---@param fileUtils FileUtils|nil
---@param json json|nil
---@param lfs LuaFileSystem|nil
---@param logger Logger|nil
---@param utils Utils|nil
---@param winapi winapi|nil
---@return NoitaMpSettings
function NoitaMpSettings:new(noitaMpSettings, customProfiler, gui, fileUtils, json, lfs, logger, utils, winapi)
    ---@class NoitaMpSettings
    noitaMpSettings = setmetatable(noitaMpSettings or self, NoitaMpSettings)

    -- Initialize all imports to avoid recursive imports
    if not noitaMpSettings.customProfiler then
        noitaMpSettings.customProfiler = customProfiler or require("CustomProfiler"):new(nil, nil, self, nil, nil, nil, nil)
    end
    local cpc = noitaMpSettings.customProfiler:start("NoitaMpSettings:new")

    if not noitaMpSettings.gui then
        noitaMpSettings.gui = gui --or error("NoitaMpSettings:new requires a Gui object", 2)
    end

    if not noitaMpSettings.fileUtils then
        noitaMpSettings.fileUtils = fileUtils or self.customProfiler.fileUtils or require("FileUtils") --:new()
    end

    if not noitaMpSettings.json then
        noitaMpSettings.json = json or require("json")
    end

    if not noitaMpSettings.lfs then
        noitaMpSettings.lfs = lfs or require("lfs")
    end

    if not noitaMpSettings.logger then
        noitaMpSettings.logger = logger or require("Logger"):new(nil, self.customProfiler)
    end

    if not noitaMpSettings.utils then
        noitaMpSettings.utils = utils or self.customProfiler.utils or require("Utils") --:new()
    end

    if not noitaMpSettings.winapi then
        noitaMpSettings.winapi = winapi or self.customProfiler.winapi or require("winapi")
    end

    noitaMpSettings.customProfiler:stop("ExampleClass:new", cpc)
    return noitaMpSettings
end

return NoitaMpSettings
