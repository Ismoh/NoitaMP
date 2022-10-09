dofile_once("mods/noita-mp/files/scripts/extensions/string_extensions.lua")

if not logger then
    -- logger is usually initialised by unsafe API, which isnt available in Noita Components.
    logger          = {}

    logger.channels = {
        entity  = "entity",
        globals = "globals",
        guid    = "guid",
        network = "network",
        nuid    = "nuid",
        vsc     = "vsc",
    }

    local file      = "unknown script - please define this in your Noita Component"

    local function log(level, channel, message)
        if ModSettingGet("noita-mp.toggle_logger") == false then
            return
        end

        local logLevelOfSettings = nil
        if channel then
            -- also have a look on init_logger.lua
            logLevelOfSettings = tostring(ModSettingGet(("noita-mp.log_level_%s"):format(channel)))
            if not logLevelOfSettings:contains(level) then
                return false
            end
        end

        channel   = string.ExtendOrCutStringToLength(channel, 7, " ")
        level     = string.ExtendOrCutStringToLength(level, 5, " ")

        local msg = ("%s [%s][%s] %s ( in %s )"):format("00:00:00", channel, level, message, file)

        if logLevelOfSettings ~= nil and logLevelOfSettings:find(level) then
            print(msg)
        end
    end

    function logger:setFile(luaScriptName)
        file = luaScriptName
    end

    function logger:debug(channel, text, ...)
        if ... then
            text = text:format(...)
        end
        log("debug", channel, text)
    end

    function logger:warn(channel, text, ...)
        if ... then
            text = text:format(...)
        end
        log("warn", channel, text)
    end

    function logger:info(channel, text, ...)
        if ... then
            text = text:format(...)
        end
        log("info", channel, text)
    end

    function logger:error(channel, text, ...)
        if ... then
            text = text:format(...)
        end
        log("error", channel, text)
    end

    logger:debug(nil, "logger isn't available in (%s). Setting dump logger up!", file)
end
