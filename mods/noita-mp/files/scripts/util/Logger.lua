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

Logger.channels = {
    entity     = "entity",
    globals    = "globals",
    guid       = "guid",
    network    = "network",
    nuid       = "nuid",
    vsc        = "vsc",
    profiler   = "profiler",
    initialize = "initialize"
}

--- Main function for logging, which simply uses `print()`.
--- By the way, if you want to log error, simply use `error()`.
--- @param level string Possible values = off, trace, debug, info, warn
--- @param channel string Defined in Logger.channels.
--- @param message string Message text to `print()`. Use `Logger.log("debug", Logger.channels.entity, ("Debug message with string directive %s. Yay!"):format("FooBar"))`
local function log(level, channel, message)
    if level == "off" then
        return
    end

    if message:contains("%") then
        error("There is a directive (%) in your log message. Use string.format! Message = '" .. message .. "'", 2)
    end

    local logLevelOfSettings = nil
    if channel then
        logLevelOfSettings = tostring(ModSettingGet(("noita-mp.log_level_%s"):format(channel)))
        if not logLevelOfSettings:contains(level) then
            return false
        end
    end

    channel = string.ExtendOrCutStringToLength(channel, 8, " ")
    level   = string.ExtendOrCutStringToLength(level, 5, " ")

    local msg
    if require then
        local time      = os.date("%X")
        -- add file name to logs: https://stackoverflow.com/a/48469960/3493998
        local file_name = debug.getinfo(2, "S").source:sub(2)
        file_name       = file_name:match("^.*/(.*)$") or file_name
        msg             = ("%s [%s][%s] %s \n(in %s)")
                :format(time, channel, level, message, file_name)
    else
        msg = ("%s [%s][%s] %s")
                :format("--:--:--", channel, level, message)
    end

    if logLevelOfSettings ~= nil and logLevelOfSettings:find(level) then
        print(msg)
    end
end

function Logger.trace(channel, formattedMessage)
    log("trace", channel, formattedMessage)
end

---
function Logger.debug(channel, formattedMessage)
    log("debug", channel, formattedMessage)
end

function Logger.warn(channel, formattedMessage)
    log("warn", channel, formattedMessage)
end

function Logger.info(channel, formattedMessage)
    log("info", channel, formattedMessage)
end

Logger.trace(Logger.channels.initialize, "Logger was initialized!")

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.Logger = Logger

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Logger