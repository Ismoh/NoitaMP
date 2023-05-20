--- NoitaMpSettings: Replacement for Noita ModSettings.
--- @class NoitaMpSettings
local NoitaMpSettings = {}

local lfs             = require("lfs")
local winapi          = require("winapi")
local json            = require("json")


function NoitaMpSettings.clearAndCreateSettings()
    local cpc         = CustomProfiler.start("NoitaMpSettings.clearAndCreateSettings")
    local settingsDir = FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory()
    if FileUtils.Exists(settingsDir) then
        FileUtils.RemoveContentOfDirectory(settingsDir)
        Logger.info(Logger.channels.initialize, ("Removed old settings in '%s'!"):format(settingsDir))
    else
        lfs.mkdir(settingsDir)
        Logger.info(Logger.channels.initialize, ("Created settings directory in '%s'!"):format(settingsDir))
    end
    CustomProfiler.stop("NoitaMpSettings.clearAndCreateSettings", cpc)
end

function NoitaMpSettings.set(key, value)
    local cpc = CustomProfiler.start("NoitaMpSettings.set")
    if Utils.IsEmpty(key) or type(key) ~= "string" then
        error(("'key' must not be nil or is not type of string!"):format(key), 2)
    end

    if type(value) ~= "string" then
        error(("'value' is not type of string!"):format(value), 2)
    end

    local pid = winapi.get_current_pid()

    local who = "CLIENT"
    if whoAmI then
        who = whoAmI()
    end
    local settingsFile = ("%s%s%s%s.json")
        :format(FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, who)

    if not FileUtils.Exists(settingsFile) then
        FileUtils.WriteFile(settingsFile, "{}")
    end

    local contentString = FileUtils.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    contentJson[key]    = value

    FileUtils.WriteFile(settingsFile, json.encode(contentJson))
    Logger.trace(Logger.channels.testing, ("Wrote custom setting: %s = %s"):format(key, value))

    local result = FileUtils.ReadFile(settingsFile)
    CustomProfiler.stop("NoitaMpSettings.set", cpc)
    return result
end

function NoitaMpSettings.get(key)
    local cpc          = CustomProfiler.start("NoitaMpSettings.get")
    local pid          = winapi.get_current_pid()

    local settingsFile = ("%s%s%s%s.json")
        :format(FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, whoAmI())

    if not FileUtils.Exists(settingsFile) then
        FileUtils.WriteFile(settingsFile, "{}")
    end

    local contentString = FileUtils.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    if Utils.IsEmpty(contentJson[key]) then
        --error(("Unable to find '%s' in NoitaMpSettings: %s"):format(key, contentString), 2)
        CustomProfiler.stop("NoitaMpSettings.get", cpc)
        return ""
    end
    local value = contentJson[key]
    CustomProfiler.stop("NoitaMpSettings.get", cpc)
    return value
end

return NoitaMpSettings

