local util = require("util")
--local EntityUtils = require("EntityUtils")

-- Meta class
NetworkComponent = {
    owner = {}, -- this is { username = string|nil, guid = string|nil } for each specific client/server
    nuid = nil, -- network unique identifier to find an entity by nuid
}

----------- Constants
NetworkComponent.field_name = "value_string"
NetworkComponent.component_name_owner_username = "noita-mp.nc_owner.username"
NetworkComponent.component_name_owner_guid = "noita-mp.nc_owner.guid"
NetworkComponent.component_name_nuid = "noita-mp.nc_nuid"


----------- Constructor

--- Creates a new table of NetworkComponent
--- @param owner table { username, guid } GUID of server OR client, to be able to check, if this entity needs to be 'destroyed' or respawned.
--- @param nuid number NUID to find entity by network component id
--- @return table NetworkComponent Returns a new 'instance' of NetworkComponent. It's only a table :)
function NetworkComponent:new(owner, nuid)
    local network_component = {}
    setmetatable(network_component, self)
    self.__index = self
    self.owner = { username = owner.username, guid = owner.guid }
    self.nuid = nuid
    return network_component
end

----------- functions

--- Provides a serialisable table by its own fields
---@param nc table deserialised network component - without any functions
---@return table t Returns itself as a data table, without any functions, to be able to be de-/serialised.
function NetworkComponent.toSerialisableTable(nc)
    local t = {
        owner = {
            username = nc.owner.username or "nil",
            guid = nc.owner.guid or "nil"
        },
        nuid = nc.nuid or "nil",
        local_entity_id = nc.local_entity_id or "nil",
        component_id = nc.component_id or "nil"
    }
    return t
end

--- Adds for each network component value one VariableStorageComponent.
---@param entity_id number Entity id to add the VSComponents - cannot be nil
---@param owner table Owner table: { username = string, guid = string } - cannot be nil
---@param nuid number NetworkUniqueIdentifier - cannot be nil
function NetworkComponent.addNetworkComponentValues(entity_id, owner, nuid)
    if not EntityUtils.isEntityAlive(entity_id) then
        return
    end

    if type(entity_id) ~= "number" then
        error("entity_id is not type of number. Unable to store network components values.", 2)
    end

    if util.IsEmpty(entity_id) then
        error("entity_id is nil or empty. Unable to store network components values.", 2)
    end

    if type(owner) ~= "table" then
        error("owner is not type of table. Unable to store network components values.", 2)
    end

    if util.IsEmpty(owner) then
        error("owner is nil or empty. Unable to store network components values.", 2)
    end

    if util.IsEmpty(owner.username) then
        error("owner.username is nil or empty. Unable to store network components values.", 2)
    end

    if util.IsEmpty(owner.guid) then
        error("owner.guid is nil or empty. Unable to store network components values.", 2)
    end

    if _G.Server:amIServer() then -- Clients can spawn entities with NUID = nil, think of projectiles. The NUID will be updated, when server sent the client the NUID
        if type(nuid) ~= "number" then
            error("nuid is not type of number. Unable to store network components values.", 2)
        end

        if util.IsEmpty(nuid) then
            error("nuid is nil or empty. Unable to store network components values.", 2)
        end
    end


    local component_id_username =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.component_name_owner_username,
            value_string = owner.username
        }
    )
    local log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.component_name_owner_username,
        owner.username,
        component_id_username,
        entity_id
    )

    local component_id_guid =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.component_name_owner_guid,
            value_string = owner.guid
        }
    )
    log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.component_name_owner_guid,
        owner.guid,
        component_id_guid,
        entity_id
    )

    local component_id_nuid =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.component_name_nuid,
            value_string = nuid
        }
    )
    log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.component_name_nuid,
        nuid,
        component_id_nuid,
        entity_id
    )

    EntityAddComponent2(
        entity_id,
        "LuaComponent",
        {
            script_source_file = "mods/noita-mp/files/scripts/noita-components/nuid_updater.lua",
            script_death = "mods/noita-mp/files/scripts/noita-components/nuid_updater.lua",
            execute_on_added = false,
            call_init_function = true,
            execute_on_removed = true,
            execute_every_n_frame = -1, -- = -1 -> execute only on add/remove/event
        }
    )

    EntityAddComponent2(
        entity_id,
        "LuaComponent",
        {
            script_source_file = "mods/noita-mp/files/scripts/noita-components/nuid_debug.lua",
            execute_every_n_frame = 1,
        }
    )

    if _G.Client:amIClient() then
        _G.cache.entity_ids_without_nuids[entity_id] = {
            entity_id = entity_id,
            component_id_username = component_id_username,
            component_id_guid = component_id_guid,
            component_id_nuid = component_id_nuid
        }

        _G.Client:sendNeedNuid(util.getLocalPlayerInfo(), entity_id)
    end

    if nuid ~= nil then -- NUID can be nil, when the client creates entities, like projectiles
        _G.cache.nuids[nuid] = {
            entity_id = entity_id,
            component_id_username = component_id_username,
            component_id_guid = component_id_guid,
            component_id_nuid = component_id_nuid
        }
        EntitySetName(entity_id, ("nuid = %s"):format(nuid)) -- This might be a way to get a relation between an entity and the nuid

        GlobalsSetValue(("nuid = %s"):format(nuid), ("nuid = %s - entity_id = %s"):format(nuid, entity_id)) -- stored in /saveXX/world_state.xml
    end

    return component_id_nuid
end

function NetworkComponent.getNetworkComponentValues(nuid, expected_entity_id)
    local entity_id = nil
    local owner = {}

    local stored_ids = _G.cache.nuids[nuid]
    if stored_ids ~= nil then
        entity_id = tonumber(stored_ids.entity_id)
        local component_id_username = tonumber(stored_ids.component_id_username)
        local component_id_guid = tonumber(stored_ids.component_id_guid)
        local component_id_nuid = tonumber(stored_ids.component_id_nuid)

        owner.username = ComponentGetValue2(component_id_username, NetworkComponent.component_name_owner_username)
        owner.guid = ComponentGetValue2(component_id_guid, NetworkComponent.component_name_owner_guid)
        local actual_nuid = ComponentGetValue2(component_id_nuid, NetworkComponent.storage_name_owner_nuid)
    end

    if actual_nuid ~= nuid then
        entity_id = EntityGetWithName(tostring(nuid)) -- returns 0 if nothing found
        if entity_id == 0 then
            entity_id = nil
        end
        local vsc = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}
        for i = 1, #vsc do
            local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
            if variable_storage_component_name == "noita-mp.nc_nuid" then -- see NetworkComponent.component_name_nuid
                local vsc_nuid = ComponentGetValue2(vsc[i], "value_string")
                if vsc_nuid ~= nil or vsc_nuid ~= "" then
                    vsc_nuid = tonumber(vsc_nuid)

                    if nuid ~= vsc_nuid then
                        logger:warn("vsc_nuid=%s does not fit to nuid=%s! This might happen when a new entity has to be spawned", vsc_nuid, nuid)
                        entity_id = nil
                    end
                end
            end
        end
    end

    if entity_id ~= nil then
        if not EntityUtils.isEntityAlive(entity_id) then
            return
        end
        return NetworkComponent:new(owner, nuid)
    end

    return nil
end

function NetworkComponent.updateNuid(entity_id, nuid)
    if not EntityUtils.isEntityAlive(entity_id) then
        return
    end
    local cached_ids = _G.cache.entity_ids_without_nuids[entity_id]
    if cached_ids == nil then
        _G.logger:debug("Unable to find entity_id (%s) in cache without nuids. Going to search in nuids cache with nuid (%s)..", entity_id, nuid)
        cached_ids = _G.cache.nuids[nuid]
        if cached_ids == nil then
            logger:error("Unable to update entity_id (%s) with nuid (%s), because entity with id (%s) does not exist in cache.", entity_id, nuid, entity_id)
            return
        end
    end

    local cached_entity_id = tonumber(cached_ids.entity_id)
    local cached_component_id_username = tonumber(cached_ids.component_id_username)
    local cached_component_id_guid = tonumber(cached_ids.component_id_guid)
    local cached_component_id_nuid = tonumber(cached_ids.component_id_nuid)

    if entity_id ~= cached_entity_id then
        error(("Cached entity_id (%s) does not fit to requested entity_id (%s), when updating nuid (%s)."):format(cached_entity_id, entity_id, nuid), 2)
    end

    -- Set the value in VariableStorageComponent
    ComponentSetValue2(cached_component_id_nuid, NetworkComponent.field_name, nuid)

    -- Update or set the cache for nuids
    _G.cache.nuids[nuid] = {
        entity_id = entity_id,
        component_id_username = cached_component_id_username,
        component_id_guid = cached_component_id_guid,
        component_id_nuid = cached_component_id_nuid
    }

    -- get rid off the cache entry where no nuid is available
    _G.cache.entity_ids_without_nuids[entity_id] = nil
end

-----------

return NetworkComponent
