--- NoitaMpSettings.
--- Created by Ismoh.
--- DateTime: 14.02.2023 11:47

--- 'Imports'
local fu        = require("FileUtils")
local lfs       = require("lfs")
local winapi    = require("winapi")
local json      = require("json")
local Utils      = require("Utils")


-- NoitaMpSettings
NoitaMpSettings = {}

function NoitaMpSettings.clearAndCreateSettings()
    local cpc         = CustomProfiler.start("NoitaMpSettings.clearAndCreateSettings")
    local settingsDir = fu.GetAbsolutePathOfNoitaMpSettingsDirectory()
    if fu.Exists(settingsDir) then
        fu.RemoveContentOfDirectory(settingsDir)
        Logger.info(Logger.channels.initialize, ("Removed old settings in '%s'!"):format(settingsDir))
    else
        lfs.mkdir(settingsDir)
        Logger.info(Logger.channels.initialize, ("Created settings directory in '%s'!"):format(settingsDir))
    end
    CustomProfiler.stop("NoitaMpSettings.clearAndCreateSettings", cpc)
end

function NoitaMpSettings.writeSettings(key, value)
    local cpc = CustomProfiler.start("NoitaMpSettings.writeSettings")
    if Utils.IsEmpty(key) or type(key) ~= "string" then
        error(("'key' must not be nil or is not type of string!"):format(key), 2)
    end

    if Utils.IsEmpty(value) or type(value) ~= "string" then
        error(("'value' must not be nil or is not type of string!"):format(value), 2)
    end

    local pid = winapi.get_current_pid()

    local who = "CLIENT"
    if whoAmI then
        who = whoAmI()
    end
    local settingsFile = ("%s%s%s%s.json")
            :format(fu.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, who)

    if not fu.Exists(settingsFile) then
        fu.WriteFile(settingsFile, "{}")
    end

    local contentString = fu.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    contentJson[key]    = value

    fu.WriteFile(settingsFile, json.encode(contentJson))
    Logger.trace(Logger.channels.testing, ("Wrote custom setting: %s = %s"):format(key, value))

    local result = fu.ReadFile(settingsFile)
    CustomProfiler.stop("NoitaMpSettings.writeSettings", cpc)
    return result
end

function NoitaMpSettings.getSetting(key)
    local cpc          = CustomProfiler.start("NoitaMpSettings.getSetting")
    local pid          = winapi.get_current_pid()

    local settingsFile = ("%s%s%s%s.json")
            :format(fu.GetAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, whoAmI())

    if not fu.Exists(settingsFile) then
        fu.WriteFile(settingsFile, "{}")
    end

    local contentString = fu.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    if Utils.IsEmpty(contentJson[key]) then
        error(("Unable to find '%s' in NoitaMpSettings: %s"):format(key, contentString), 2)
    end
    local value = contentJson[key]
    CustomProfiler.stop("NoitaMpSettings.getSetting", cpc)
    return value
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NoitaMpSettings = NoitaMpSettings

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NoitaMpSettings