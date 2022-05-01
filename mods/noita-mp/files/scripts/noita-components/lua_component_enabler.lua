dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")


logger:setFile("lua_component_enabler")

function enabled_changed(entityId, isEnabled)
    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    if isEnabled == true then

        if NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
            NetworkVscUtils.enableComponents(entityId)
        end
    end
end
