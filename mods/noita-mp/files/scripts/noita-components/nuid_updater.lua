print("nuid_updater.lua started..")
------------
-- CONFIG --
dofile_once("mods/noita-mp/files/scripts/util/string_extensions.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtil.lua")
GlobalsUtils = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")

local executeOnAdded = GetValueBool("executeOnAdded", true)

if not logger then
    print("logger isn't available in GlobalsUtils, looks like a Noita Component is using GlobalsUtils.")
    logger = {}
    function logger:debug(var)
        print(("[debug] nuid_updater.lua | %s"):format(var))
    end

    function logger:error(var)
        print(("[warn] nuid_updater.lua | %s"):format(var))
    end

    function logger:error(var)
        print(("[error] nuid_updater.lua | %s"):format(var))
    end
end
-- CONFIG --
------------

--#region local functions

-- local function getNuidByVsc(entityId)
--     print("nuid_updater.lua getNuidByVsc..")
--     local vsc = EntityGetComponentIncludingDisabled(entityId, "VariableStorageComponent") or {}
--     for i = 1, #vsc do
--         local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
--         if variable_storage_component_name == NetworkVscUtils.componentNameOfNuid then -- "noita-mp.nc_nuid" then -- see NetworkComponent.component_name_nuid
--             local nuid = ComponentGetValue2(vsc[i], "value_string")
--             if nuid ~= nil or nuid ~= "" then
--                 return tonumber(nuid)
--             end
--         end
--     end
--     return nil
-- end

-- local function getStoredNuidAndEntityId(currentEntityId)
--     print("nuid_updater.lua getStoredNuidAndEntityId..")
--     local nuidByVsc = getNuidByVsc(currentEntityId)
--     local globalsKey = GlobalsUtils.nuidKeyFormat:format(nuidByVsc)
--     local globalsValue = GlobalsUtils.getNuid(globalsKey)
--     local values = nil
--     local stored_nuid = nil
--     local stored_entity_id = nil

--     if globalsValue ~= nil then
--         local entityId = nil
--         local foundEntityId = string.find(globalsValue, GlobalsUtils.nuidValueSubstring, 1, true)
--         if foundEntityId ~= nil then
--             entityId = tonumber(string.sub(globalsValue, GlobalsUtils.nuidValueSubstring:len()))
--         else
--             print(("Error in nuid_updater.lua | Unable to get entityId number of value string (%s)."):format(globalsValue))
--         end

--         if currentEntityId ~= entityId then
--             print(("Warning in nuid_updater.lua | Entity id changed: previous = %s, current = %s."):format(entityId, currentEntityId))
--         end
--     end
--     print(("stored_nuid %s, stored_entity_id %s"):format(stored_nuid, stored_entity_id))
--     return stored_nuid, stored_entity_id
-- end

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
    print(("nuid_updater.lua | nuid in noitas global storage was set: nuid = %s and entity_id = %s"):format(nuid, currentEntityId))
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
