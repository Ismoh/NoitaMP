NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")

if not logger then -- logger is usually initialised by unsafe API, which isnt available in Noita Components.
    print("logger isn't available in GlobalsUtils, looks like a Noita Component is using GlobalsUtils.")
    logger = {}
    function logger:debug(text, ...)
        local log = "00:00:00 [debug] LuaComponentDisAndEnabler.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end

    function logger:warn(text, ...)
        local log = "00:00:00 [warn] LuaComponentDisAndEnabler.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end

    function logger:error(text, ...)
        local log = "00:00:00 [error] LuaComponentDisAndEnabler.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end
end

function enabled_changed(entityId, isEnabled)
    if isEnabled == true then
        if NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
            NetworkVscUtils.enableComponents(entityId)
        end
    end
end
