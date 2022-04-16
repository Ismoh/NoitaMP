local util = require("util")

-- Meta class
NetworkComponent = {
    owner = {}, -- this is { username = string|nil, guid = string|nil } for each specific client/server
    nuid = nil, -- network unique identifier to find an entity by nuid
}

----------- Constants
NetworkComponent.field_name = "value_string"
NetworkComponent.storage_name_owner_username = "noita-mp.nc_owner.username"
NetworkComponent.storage_name_owner_guid = "noita-mp.nc_owner.guid"
NetworkComponent.storage_name_nuid = "noita-mp.nc_nuid"


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

    if type(nuid) ~= "number" then
        error("nuid is not type of number. Unable to store network components values.", 2)
    end

    if util.IsEmpty(nuid) then
        error("nuid is nil or empty. Unable to store network components values.", 2)
    end


    local component_id_username =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.storage_name_owner_username,
            value_string = owner.username
        }
    )
    local log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.storage_name_owner_username,
        owner.username,
        component_id_username,
        entity_id
    )

    local component_id_guid =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.storage_name_owner_guid,
            value_string = owner.guid
        }
    )
    log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.storage_name_owner_guid,
        owner.guid,
        component_id_guid,
        entity_id
    )

    local component_id_nuid =
    EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.storage_name_nuid,
            value_string = nuid
        }
    )
    log_result = logger:debug(
        "VariableStorageComponent (%s = %s) added with noita component_id = %s to entity_id = %s!",
        NetworkComponent.storage_name_nuid,
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

    _G.cache.nuids[nuid] = { entity_id, component_id_username, component_id_guid, component_id_nuid }
    EntitySetName(entity_id, tostring(nuid)) -- This might be a way to get a relation between an entity and the nuid

    GlobalsSetValue(("nuid = %s"):format(nuid), ("nuid = %s - entity_id = %s"):format(nuid, entity_id)) -- stored in /saveXX/world_state.xml

    return component_id_nuid
end

function NetworkComponent.getNetworkComponentValues(nuid, expected_entity_id)

    local stored_ids = _G.cache.nuids[nuid]
    local stored_entity_id = tonumber(stored_ids[1])
    local component_id_username = tonumber(stored_ids[2])
    local component_id_guid = tonumber(stored_ids[3])
    local component_id_nuid = tonumber(stored_ids[4])

    local owner = {}
    owner.username = ComponentGetValue2(component_id_username, NetworkComponent.storage_name_owner_username)
    owner.guid = ComponentGetValue2(component_id_guid, NetworkComponent.storage_name_owner_guid)
    local actual_nuid = ComponentGetValue2(component_id_nuid, NetworkComponent.storage_name_owner_nuid)

    if actual_nuid ~= nuid then
        local entity_id = EntityGetWithName(tostring(nuid))
        local component_ids = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
        for i = 1, #component_ids do
            --ComponentGetName
        end
    end

    return NetworkComponent:new(owner, nuid)
end

-----------

return NetworkComponent
