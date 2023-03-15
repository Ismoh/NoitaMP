---
--- Created by Ismoh-PC.
--- DateTime: 20.01.2023 22:45
---
-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- "Imports"
----------------------------------------

----------------------------------------
--- Logger
----------------------------------------
--- Class for being able to log per level
Logger          = {}

Logger.level    = {
    off   = "off",
    trace = "trace",
    debug = "debug",
    info  = "info",
    warn  = "warn"
}

Logger.channels = {
    entity              = "entity",
    globals             = "globals",
    guid                = "guid",
    network             = "network",
    nuid                = "nuid",
    vsc                 = "vsc",
    profiler            = "profiler",
    initialize          = "initialize",
    testing             = "testing",
    cache               = "cache",
    entitySerialisation = "entitySerialisation"
}

--- Main function for logging, which simply uses `print()`.
--- By the way, if you want to log error, simply use `error()`.
--- @param level string Possible values = off, trace, debug, info, warn
--- @param channel string Defined in Logger.channels.
--- @param message string Message text to `print()`. Use `Logger.log("debug", Logger.channels.entity, ("Debug message with string directive %s. Yay!"):format("FooBar"))`
--- @return boolean true if logged, false if not logged
function Logger.log(level, channel, message)
    if not level then
        error("Unable to log, because 'level' must not be nil!", 2)
    end
    if not Logger.level[level] then
        error(("Unable to log, because log level '%s' is not valid!"):format(level), 2)
    end
    if not channel then
        error("Unable to log, because 'channel' must not be nil!", 2)
    end
    if not Logger.channels[channel] then
        error(("Unable to log, because log channel '%s' is not valid!"):format(channel), 2)
    end
    if not message then
        error("Unable to log, because 'message' must not be nil!", 2)
    end
    -- string.contains is not available in NoitaComponents and Logger.lua is also used in NoitaComponents.
    if string.contains and message:contains("%") then
        error("There is a directive (%) in your log message. Use string.format! Message = '" .. message .. "'", 2)
    end

    if string.lower(level) == "off" then
        return false
    end

    local logLevelOfSettings = ModSettingGet(("noita-mp.log_level_%s"):format(channel)) -- i.e.: { "debug, info, warn", "DEBUG" }
    if not logLevelOfSettings then
        error(("Looks like you missed to add 'noita-mp.log_level_%s' in settings.lua"):format(channel), 2)
    end

    -- Stupid workaround fix for stupid ModSettings:
    -- default_value cannot be a table and is a string, i.e. default_value = "OFF"
    if type(logLevelOfSettings) == "string" then
        logLevelOfSettings = { logLevelOfSettings, logLevelOfSettings }
    end

    if string.contains and not string.contains(logLevelOfSettings[1], level)
            -- string.contains is not available in NoitaComponents and Logger.lua is also used in NoitaComponents.
            or not string.find(logLevelOfSettings[1]:lower(), level:lower(), 1, true) then
        return false
    end

    local msg
    if require then
        channel         = string.ExtendOrCutStringToLength(channel, 10, " ")
        level           = string.ExtendOrCutStringToLength(level, 5, " ")
        local time      = os.date("%X")
        -- add file name to logs: https://stackoverflow.com/a/48469960/3493998
        local file_name = debug.getinfo(2, "S").source:sub(2)
        file_name       = file_name:match("^.*/(.*)$") or file_name
        msg             = ("%s [%s][%s] %s \n(in %s)"):format(time, level, channel, message, file_name)
    else
        msg = ("%s [%s][%s] %s"):format("--:--:--", level, channel, message)
    end

    print(msg)
    return true
end

function Logger.trace(channel, formattedMessage)
    return Logger.log(Logger.level.trace, channel, formattedMessage)
end

---
function Logger.debug(channel, formattedMessage)
    return Logger.log(Logger.level.debug, channel, formattedMessage)
end

function Logger.info(channel, formattedMessage)
    return Logger.log(Logger.level.info, channel, formattedMessage)
end

function Logger.warn(channel, formattedMessage)
    return Logger.log(Logger.level.warn, channel, formattedMessage)
end

Logger.trace(Logger.channels.initialize, "Logger was initialized!")

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.Logger = Logger

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Logger