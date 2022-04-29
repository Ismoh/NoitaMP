print("nuid_updater.lua started..")
------------
-- CONFIG --
dofile_once("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
GlobalsUtils = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")

local executeOnAdded = GetValueBool("executeOnAdded", true)

if not logger then -- logger is usually initialised by unsafe API, which isnt available in Noita Components.
    print("logger isn't available in GlobalsUtils, looks like a Noita Component is using GlobalsUtils.")
    logger = {}
    function logger:debug(text, ...)
        local log = "00:00:00 [debug] nuid_updater.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end

    function logger:warn(text, ...)
        local log = "00:00:00 [warn] nuid_updater.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end

    function logger:error(text, ...)
        local log = "00:00:00 [error] nuid_updater.lua | " .. text
        if ... then
            log = log:format(...)
        end
        print(log)
    end
end
-- CONFIG --
------------

--#region local functions

--#endregion

--#region executeOnAdded = added() and executeOnRemove = remove()

local function added()
    logger:debug("nuid_updater.lua added..")
    local currentEntityId = GetUpdatedEntityID()
    local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(currentEntityId)
    local globalsNuid, globalsEntityId = GlobalsUtils.getNuidEntityPair(nuid)

    -- if nuid_by_vsc ~= nil and stored_nuid ~= nil and nuid_by_vsc ~= stored_nuid then
    --     error(("Stored nuid in noitas global storage does not fit to the entity_id anymore! %s ~= %s"):format(nuid_by_vsc, stored_nuid), 2)
    -- end

    -- if stored_entity_id ~= nil and currentEntityId ~= stored_entity_id then
    --     error(("Stored entity_id in noitas global storage does not fit to the current entity_id anymore! %s ~= %s"):format(currentEntityId, stored_entity_id), 2)
    -- end

    GlobalsUtils.setNuid(nuid, currentEntityId)
    logger:debug("nuid_updater.lua | nuid in noitas global storage was set: nuid = %s and entity_id = %s", nuid, currentEntityId)
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
    print("executed on added")
    added()
    SetValueBool("executeOnAdded", false)
end

if not executeOnAdded then -- this was executed on remove
    print("executed on remove")
    remove()
end

--#endregion
