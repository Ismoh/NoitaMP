------------
-- CONFIG --
dofile_once("mods/noita-mp/files/scripts/util/string_extensions.lua")
-- CONFIG --
------------

local function getNuidByVsc(entity_id)
    local vsc = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
    for i = 1, #vsc do
        local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
        if variable_storage_component_name == "noita-mp.nc_nuid" then -- see NetworkComponent.storage_name_nuid
            return tonumber(ComponentGetValue2(vsc[i], "value_string"))
        end
    end
    return nil
end

local function getStoredNuidAndEntityId(entity_id)
    local stored_string = GlobalsGetValue(("nuid = %s"):format(entity_id))
    local values = nil
    local stored_nuid = nil
    local stored_entity_id = nil

    if stored_string ~= nil then
        values = string.split(stored_string, ",")
        stored_nuid = tonumber(values[1])
        stored_entity_id = tonumber(values[2])
    end

    return stored_nuid, stored_entity_id
end

function init(entity_id)
    ------------------------------------------
    -- Get nuid by VariableStorageComponent --
    local nuid_by_vsc = getNuidByVsc(entity_id)
    -- Get nuid by VariableStorageComponent --
    ------------------------------------------

    ------------------------------------------------------------------
    -- Get nuid by noitas global storage -> /saveXX/world_state.xml --
    --- Keep in mind that the entity_id will change when a savegame was loaded,
    --- that's why the stored nuid is not the correct one when loaded by noitas global storage
    local stored_nuid, stored_entity_id = getStoredNuidAndEntityId(entity_id)
    -- Get nuid by noitas global storage -> /saveXX/world_state.xml --
    ------------------------------------------------------------------

    if nuid_by_vsc ~= nil and stored_nuid ~= nil and nuid_by_vsc ~= stored_nuid then
        error(("Stored nuid in noitas global storage does not fit to the entity_id anymore! %s ~= %s"):format(nuid_by_vsc, stored_nuid), 2)
    end

    if stored_entity_id ~= nil and entity_id ~= stored_entity_id then
        error(("Stored entity_id in noitas global storage does not fit to the current entity_id anymore! %s ~= %s"):format(entity_id, stored_entity_id), 2)
    end

    -------------------------------------------------------------------------
    -- Update entity_id to the related nuid in the global storage of noita --
    -- if EntityGetIsAlive(entity_id) then -- seems to be entity is always alive
    GlobalsSetValue(("nuid = %s"):format(nuid_by_vsc), ("nuid = %s - entity_id = %s"):format(nuid_by_vsc, entity_id))
    print(("nuid_updater.lua | nuid in noitas global storage was set: nuid = %s - entity_id = %s"):format(nuid_by_vsc, entity_id))
    -- else
    --     GlobalsSetValue(("nuid = %s"):format(nuid_by_vsc), ("nuid = %s - entity_id = %s"):format(nuid_by_vsc, -99))
    -- end
    -- Update entity_id to the related nuid in the global storage of noita --
    -------------------------------------------------------------------------
end

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
    local entity_id = GetUpdatedEntityID()
    local nuid_by_vsc = getNuidByVsc(entity_id)

    GlobalsSetValue(("nuid = %s"):format(nuid_by_vsc), ("nuid = %s - entity_id = %s"):format(nuid_by_vsc, -99))
    print("nuid_updater.lua | Entity (" .. entity_id .. ") was killed and nuid (" .. nuid_by_vsc .. ") in noitas global storage was updated: old=" .. entity_id .. " and new=-99")
end
