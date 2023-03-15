dofile_once("mods/noita-mp/files/scripts/init/init_logger.lua")
EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")

function enabled_changed(entityId, isEnabled)
    if not EntityUtils.isEntityAlive(entityId) then return end
    if isEnabled == true then
        if NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
            NetworkVscUtils.enableComponents(entityId)
        end
    end
end
