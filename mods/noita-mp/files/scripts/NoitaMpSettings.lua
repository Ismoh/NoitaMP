--- NoitaMpSettings: Replacement for Noita ModSettings.
--- @class NoitaMpSettings
local NoitaMpSettings     = {
    --[[ Attributes ]]

    ---Settings cache. Makes it possible to access settings without reading the file every time.
    cachedSettings = {},
    checkForMultipleNoitaInstances = true,
    multipleNoitaProcessesRunning = false,
    settingsFilePath = nil,
}

---Converts a value to the given dataType.
---@private
---@param self NoitaMpSettings required
---@param value any required
---@param dataType string required! Must be one of "boolean" or "number". If not set, "string" is default.
---@return boolean|number|string|nil value converted to dataType or nil, when value is not set.
local convertToDataType   = function(self, value, dataType)
    if not self.utils:isEmpty(dataType) then
        if dataType == "boolean" then
            if self.utils:isEmpty(value) then
                return false
            end
            return toBoolean(value)
        end
        if dataType == "number" then
            if self.utils:isEmpty(value) then
                return 0
            end
            return tonumber(value)
        end
    end
    return tostring(value)
end

---Returns the path to the settings file.
---@private
---@param self NoitaMpSettings required
---@return string path
local getSettingsFilePath = function(self)
    local path = self.settingsFilePath
    if self.checkForMultipleNoitaInstances or
        not path
    then
        path = ("%s%ssettings.json"):format(self.fileUtils:GetAbsolutePathOfNoitaMpSettingsDirectory(self), pathSeparator)

        if self:isMoreThanOneNoitaProcessRunning() then
            local defaultSettings = nil
            if self.fileUtils:Exists(path) and not once then
                defaultSettings = self.fileUtils:ReadFile(path)
            end
            path = ("%s%slocal%ssettings-%s.json")
                :format(self.fileUtils:GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pathSeparator, self.winapi.get_current_pid())
            if defaultSettings then
                self.fileUtils:WriteFile(path, defaultSettings)
                once = true
            end
        end

        self.checkForMultipleNoitaInstances = false
        self.settingsFilePath = path
    end
    return path
end

---Checks if more than one Noita process is running.
---@return boolean true if more than one Noita process is running.
function NoitaMpSettings:isMoreThanOneNoitaProcessRunning()
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
    self.multipleNoitaProcessesRunning = noitaCount > 1
    return self.multipleNoitaProcessesRunning
end

---Removes all settings and creates a new settings file.
function NoitaMpSettings:clearAndCreateSettings()
    local settingsDir = ("%s%slocal"):format(self.fileUtils:GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator) --FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory()
    if self.fileUtils:Exists(settingsDir) then
        self.fileUtils:RemoveContentOfDirectory(settingsDir)
        self.logger:info(self.logger.channels.initialize, ("Removed old settings in '%s'!"):format(settingsDir))
    else
        self.lfs.mkdir(settingsDir)
        self.logger:info(self.logger.channels.initialize, ("Created settings directory in '%s'!"):format(settingsDir))
    end
end

---Sets a setting. Saves the settings to the settings file and returns the new updated cached settings.
---@param key string required
---@param value any required
---@return table self.cachedSettings
function NoitaMpSettings:set(key, value)
    if self.utils:isEmpty(key) or type(key) ~= "string" then
        error(("'key' must not be nil or is not type of string!"):format(key), 2)
    end

    local settingsFilePath = getSettingsFilePath(self)
    if self.utils:isEmpty(self.cachedSettings) or not self.fileUtils:Exists(settingsFilePath) then
        self:load()
    end

    self.cachedSettings[key] = value

    return self.cachedSettings
end

---Returns a setting from the settings file converted to the given dataType. If the setting does not exist, it will be created with the default empty value.
---@param key string required
---@param dataType string required! Must be one of "boolean" or "number". If not set, "string" is default.
---@return boolean|string|number|nil value converted to dataType or nil, when value is not set.
function NoitaMpSettings:get(key, dataType)
    local settingsFilePath = getSettingsFilePath(self)
    if not self.settingsFileExists or self.utils:isEmpty(self.cachedSettings) then
        self.settingsFileExists = self.fileUtils:Exists(settingsFilePath)
        self:load()
    end

    if self.utils:isEmpty(self.cachedSettings[key]) then
        --error(("Unable to find '%s' in NoitaMpSettings: %s"):format(key, contentString), 2)
        return convertToDataType(self, "", dataType)
    end
    return convertToDataType(self, self.cachedSettings[key], dataType)
end

---Loads the settings from the settings file and put those into the cached settings.
function NoitaMpSettings:load()
    local settingsFilePath = getSettingsFilePath(self)

    if not self.fileUtils:Exists(settingsFilePath) then
        self:save()
    end

    local contentString = self.fileUtils:ReadFile(settingsFilePath)
    self.cachedSettings = self.json.decode(contentString)
end

function NoitaMpSettings:save()
    local settingsFilePath = getSettingsFilePath(self)

    if self.utils:isEmpty(self.cachedSettings["noita-mp.pid"]) then
        self.cachedSettings["noita-mp.pid"] = self.winapi.get_current_pid()
    end

    self.fileUtils:WriteFile(settingsFilePath, self.json.encode(self.cachedSettings))
    if self.gui and self.gui.setShowSettingsSaved then
        self.gui:setShowSettingsSaved(true)
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

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not noitaMpSettings.utils then
        noitaMpSettings.utils = utils or require("Utils"):new(nil)
    end

    if not noitaMpSettings.json then
        noitaMpSettings.json = json or require("json")
    end

    if not noitaMpSettings.lfs then
        noitaMpSettings.lfs = lfs or require("lfs")
    end

    if not noitaMpSettings.winapi then
        noitaMpSettings.winapi = winapi or require("winapi")
    end

    if not noitaMpSettings.customProfiler then
        ---@type CustomProfiler
        ---@see CustomProfiler
        noitaMpSettings.customProfiler = customProfiler or
            require("CustomProfiler")
            :new(nil, nil, noitaMpSettings, nil, nil, noitaMpSettings.utils,
                noitaMpSettings.winapi)
    end

    if not noitaMpSettings.gui then
        noitaMpSettings.gui = gui or error("NoitaMpSettings:new requires a Gui object", 2)
    end

    if not noitaMpSettings.logger then
        noitaMpSettings.logger = logger or
            require("Logger")
            :new(nil, noitaMpSettings)
    end

    if not noitaMpSettings.fileUtils then
        noitaMpSettings.fileUtils = fileUtils or noitaMpSettings.customProfiler.fileUtils or
            require("FileUtils")
            :new(nil, noitaMpSettings.customProfiler, noitaMpSettings.logger, noitaMpSettings, nil,
                noitaMpSettings.utils)
    end

    return noitaMpSettings
end

return NoitaMpSettings
