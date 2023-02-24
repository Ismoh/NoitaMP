dofile_once("mods/noita-mp/files/scripts/init/init_logger.lua")
dofile_once("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
EntityUtils          = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
NetworkVscUtils      = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
GlobalsUtils         = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")
local executeOnAdded = GetValueBool("executeOnAdded", 1)

if executeOnAdded then
    Logger.debug(Logger.channels.nuid, "nuid_updater.lua added..")
    local currentEntityId = GetUpdatedEntityID()
    if not EntityUtils.isEntityAlive(currentEntityId) then return end
    local ownerName, ownerGuid, nuid   = NetworkVscUtils.getAllVscValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = GlobalsUtils.getNuidEntityPair(nuid)
    if currentEntityId ~= globalsEntityId then
        GlobalsUtils.setNuid(nuid, currentEntityId)
        Logger.debug(Logger.channels.nuid, ("nuid in noitas global storage was set: nuid = %s and entity_id = %s")
        :format(nuid, currentEntityId))
    end
    SetValueBool("executeOnAdded", 0)
end

if not executeOnAdded then
    Logger.debug(Logger.channels.nuid, "nuid_updater.lua remove..")
    local currentEntityId              = GetUpdatedEntityID()
    local ownerName, ownerGuid, nuid   = NetworkVscUtils.getAllVscValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = GlobalsUtils.getNuidEntityPair(nuid)

    if not globalsEntityId then
        globalsEntityId = currentEntityId
    end

    GlobalsUtils.setNuid(nuid, tonumber(currentEntityId * -1))
    GlobalsUtils.setDeadNuid(nuid)
    Logger.debug(Logger.channels.nuid,
    ("Entity (%s) was killed and nuid (%s) in noitas global storage was updated: old=%s and new=-%s")
    :format(currentEntityId, nuid, globalsEntityId, tonumber(globalsEntityId * -1)))
end
