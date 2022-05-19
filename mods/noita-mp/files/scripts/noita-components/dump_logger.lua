dofile_once("mods/noita-mp/files/scripts/extensions/string_extensions.lua")

if not logger then -- logger is usually initialised by unsafe API, which isnt available in Noita Components.
    logger = {}

    logger.channels = {
        entity = "entity",
        globals = "globals",
        guid = "guid",
        network = "network",
        nuid = "nuid",
        vsc = "vsc",
    }

    local file = "unkown script - please define this in your Noita Component"

    local function log(log_level, channel, text)
        local logLevelOfSettings = nil

        if channel then -- also have a look on init_logger.lua
            logLevelOfSettings = tostring(ModSettingGet(("noita-mp.log_level_%s"):format(channel)))
            if not logLevelOfSettings:contains(log_level) then
                return false
            end
        end

        if logLevelOfSettings ~= nil and logLevelOfSettings:find(log_level) then
            print(text)
        end
    end

    function logger:setFile(luaScriptName)
        file = luaScriptName
    end

    function logger:debug(channel, text, ...)
        local msg = "00:00:00 [debug] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("debug", channel, msg)
    end

    function logger:warn(channel, text, ...)
        local msg = "00:00:00 [warn] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("warn", channel, msg)
    end

    function logger:info(channel, text, ...)
        local msg = "00:00:00 [info] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("info", channel, msg)
    end

    function logger:error(channel, text, ...)
        local msg = "00:00:00 [error] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("error", channel, msg)
    end

    logger:debug(nil, "logger isn't available in (%s). Setting dump logger up!", file)
end
