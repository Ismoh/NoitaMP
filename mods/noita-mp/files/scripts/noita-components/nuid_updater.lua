dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
logger:setFile("nuid_updater")
dofile_once("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
GlobalsUtils = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")


local executeOnAdded = GetValueBool("executeOnAdded", true)

--#region local functions

--#endregion

--#region executeOnAdded = added() and executeOnRemove = remove()

local function added()
    logger:debug("nuid_updater.lua added..")
    local currentEntityId = GetUpdatedEntityID()
    if not EntityUtils.isEntityAlive(currentEntityId) then
        return
    end
    local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = GlobalsUtils.getNuidEntityPair(nuid)

    if currentEntityId ~= globalsEntityId then
        GlobalsUtils.setNuid(nuid, currentEntityId)
        logger:debug("nuid in noitas global storage was set: nuid = %s and entity_id = %s", nuid, currentEntityId)
    end
end

local function remove()
    logger:debug("nuid_updater.lua remove..")
    local currentEntityId = GetUpdatedEntityID()
    local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = GlobalsUtils.getNuidEntityPair(nuid)

    GlobalsUtils.setNuid(nuid, -99)
    logger:debug(("Entity (%s) was killed and nuid (%s) in noitas global storage was updated: old=%s and new=-99"):format(currentEntityId, nuid, globalsEntityId))
end

--#endregion


--#region Decision maker if executed on added or remove

if executeOnAdded then -- this was executed on added
    added()
    SetValueBool("executeOnAdded", false)
end

if not executeOnAdded then -- this was executed on remove
    remove()
end

--#endregion
