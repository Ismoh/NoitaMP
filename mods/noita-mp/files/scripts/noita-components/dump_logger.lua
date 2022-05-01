if not logger then -- logger is usually initialised by unsafe API, which isnt available in Noita Components.
    logger = {}

    local file = "unkown script - please define this in your Noita Component"

    local function log(log_level, text)
        local setting_log_level = tostring(ModSettingGetNextValue("noita-mp.log_level"))

        if setting_log_level ~= nil and setting_log_level:find(log_level) then
            print(text)
        end
    end

    function logger:setFile(luaScriptName)
        file = luaScriptName
    end

    function logger:debug(text, ...)
        local msg = "00:00:00 [debug] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("debug", msg)
    end

    function logger:warn(text, ...)
        local msg = "00:00:00 [warn] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("warn", msg)
    end

    function logger:info(text, ...)
        local msg = "00:00:00 [info] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("info", msg)
    end

    function logger:error(text, ...)
        local msg = "00:00:00 [error] " .. text .. " in (" .. file .. ".lua)"
        if ... then
            msg = msg:format(...)
        end
        log("error", msg)
    end

    logger:debug("logger isn't available in (%s). Setting dump logger up!", file)
end
