dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")

logger:setFile("lua_component_enabler")

function enabled_changed(entityId, isEnabled)
    if isEnabled == true then
        if NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
            NetworkVscUtils.enableComponents(entityId)
        end
    end
end
