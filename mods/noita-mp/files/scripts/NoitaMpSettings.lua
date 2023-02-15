---
--- Created by Ismoh.
--- DateTime: 14.02.2023 11:47
---
-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------
local fu        = require("file_util")
local lfs       = require("lfs")
local winapi    = require("winapi")
local json      = require("json")
local util      = require("util")

------------------------------------------------------------------------------------------------------------------------
--- NoitaMpSettings
------------------------------------------------------------------------------------------------------------------------
NoitaMpSettings = {}

function NoitaMpSettings.clearAndCreateSettings()
    local cpc         = CustomProfiler.start("NoitaMpSettings.clearAndCreateSettings")
    local settingsDir = fu.getAbsolutePathOfNoitaMpSettingsDirectory()
    if fu.exists(settingsDir) then
        fu.removeContentOfDirectory(settingsDir)
        Logger.info(Logger.channels.initialize, ("Removed old settings in '%s'!"):format(settingsDir))
    else
        lfs.mkdir(settingsDir)
        Logger.info(Logger.channels.initialize, ("Created settings directory in '%s'!"):format(settingsDir))
    end
    CustomProfiler.stop("NoitaMpSettings.clearAndCreateSettings", cpc)
end

function NoitaMpSettings.writeSettings(key, value)
    if util.IsEmpty(key) or type(key) ~= "string" then
        error(("'key' must not be nil or is not type of string!"):format(key), 2)
    end

    if util.IsEmpty(value) or type(value) ~= "string" then
        error(("'value' must not be nil or is not type of string!"):format(value), 2)
    end

    local pid          = winapi.get_current_pid()

    local settingsFile = ("%s%s%s%s.lua")
            :format(fu.getAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, whoAmI())

    if not fu.exists(settingsFile) then
        fu.WriteFile(settingsFile, "{}")
    end

    local contentString = fu.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    contentJson[key]    = value

    fu.WriteFile(settingsFile, json.encode(contentJson))
    Logger.trace(Logger.channels.testing, ("Wrote custom setting: %s = %s"):format(key, value))

    return fu.ReadFile(settingsFile)
end

function NoitaMpSettings.getSetting(key)
    local pid          = winapi.get_current_pid()

    local settingsFile = ("%s%s%s%s.json")
            :format(fu.getAbsolutePathOfNoitaMpSettingsDirectory(), pathSeparator, pid, whoAmI())

    if not fu.exists(settingsFile) then
        fu.WriteFile(settingsFile, "{}")
    end

    local contentString = fu.ReadFile(settingsFile)
    local contentJson   = json.decode(contentString)

    if util.IsEmpty(contentJson[key]) then
        error(("Unable to find '%s' in NoitaMpSettings: %s"):format(key, contentString), 2)
    end
    return contentJson[key]
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NoitaMpSettings = NoitaMpSettings

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NoitaMpSettings