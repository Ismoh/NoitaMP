local util = require("util")
local NetworkComponent = require("network_component_class")

local em = {
    nuid_counter = 0,
    cache = {
        all_entity_ids = {},
        nc_entity_ids = {}
    }
}

--- Simply generates a new NUID by increasing by 1
--- @return integer nuid
function em.GetNextNuid()
    em.nuid_counter = em.nuid_counter + 1
    return em.nuid_counter
end

--- Checks for entities (only for his own - locally) in a specific range/radius to the player_units.
--- If there are entities in this radius, a NetworkComponent will be added as a VariableStorageComponent.
--- If entities does not have VelocityComponents, those will be ignored.
--- Every checked entity will be put into a cache list, to stop iterating over the same entities again and again.
function em.AddNetworkComponent()
    local player_unit_ids = EntityGetWithTag("player_unit")
    for i_p = 1, #player_unit_ids do
        -- get all player units
        local x, y, rot, scale_x, scale_y = EntityGetTransform(player_unit_ids[i_p])

        -- find all entities in a specific radius based on the player units position
        local entity_ids = EntityGetInRadius(x, y, 1000)

        for i_e = 1, #entity_ids do
            local entity_id = entity_ids[i_e]

            if not em.cache.all_entity_ids[entity_id] then -- if entity was already checked, skip it
                -- loop all components of the entity
                local component_ids = EntityGetAllComponents(entity_id)

                local has_velocity_component = false
                for i_c = 1, #component_ids do
                    local component_id = component_ids[i_c]

                    -- search for VelocityComponent
                    local component_name = ComponentGetTypeName(component_id)
                    if component_name == "VelocityComponent" then
                        has_velocity_component = true
                        local variable_storage_component_ids =
                            EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

                        local has_network_component = false
                        for i_v = 1, #variable_storage_component_ids do
                            local variable_storage_component_id = variable_storage_component_ids[i_v]
                            -- check if the entity already has a VariableStorageComponent
                            local variable_storage_component_name =
                                ComponentGetValue2(variable_storage_component_id, "name") or nil
                            if variable_storage_component_name == "network_component_class" then
                                -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
                                has_network_component = true
                            end
                        end

                        if has_network_component == false then
                            local nuid = nil
                            if _G.Server:amIServer() then
                                nuid = em.GetNextNuid()
                                _G.Server:sendNewNuid(
                                    ModSettingGet("noita-mp.guid"),
                                    entity_id,
                                    nuid,
                                    EntityGetFilename(entity_id)
                                )
                            else
                                _G.Client:sendNeedNuid(entity_id)
                            end
                            -- if the VariableStorageComponent is not a 'network_component_class', then add one
                            em.AddNetworkComponentToEntity(entity_id, ModSettingGet("noita-mp.guid"), nuid)
                        end
                    end
                end

                if has_velocity_component == false then
                    -- if the entity does not have a VelocityComponent, skip it always
                    -- logger:debug("Entity %s does not have a VelocityComponent. Ignore it.", entity_id)
                    em.cache.all_entity_ids[entity_id] = true
                end
            end
        end
    end
end

--- Adds a NetworkComponent to an entity, if it doesn't exist already.
--- @param entity_id number The entity id where to add the NetworkComponent.
--- @param guid string guid to know the owner (optional)
--- @param nuid number nuid to know the entity wiht network component
--- @return number component_id Returns the component_id. The already existed one or the newly created id.
function em.AddNetworkComponentToEntity(entity_id, guid, nuid)
    local variable_storage_component_ids =
        EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

    -- check if the entity already has a NetworkComponent. If so skip this function by returning the component_id
    for i_v = 1, #variable_storage_component_ids do
        local variable_storage_component_id = variable_storage_component_ids[i_v]
        local variable_storage_component_name = ComponentGetValue2(variable_storage_component_id, "name") or nil
        local nc_serialised = ComponentGetValue2(variable_storage_component_id, "value_string") or nil
        local nc = nil

        if nc_serialised then
            nc = util.deserialise(nc_serialised)
        end

        if variable_storage_component_name == "network_component_class" and nc:getNuid() == nuid then
            -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
            em.cache.all_entity_ids[entity_id] = true
            return variable_storage_component_id
        end
    end

    local component_id =
        EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = "network_component_class",
            value_string = nil -- will be set after creation, because NetworkComponent has to be serialised
        }
    )
    logger:debug(
        "VariableStorageComponent added with noita component_id = %s to entity_id = %s!",
        component_id,
        entity_id
    )

    local owner = guid or ModSettingGet("noita-mp.guid")
    local nc = NetworkComponent:new(nil, component_id, owner, nuid)
    local nc_serialised = util.serialise(nc:toSerialisableTable())

    ComponentSetValue2(component_id, "value_string", nc_serialised)
    logger:debug(
        "Added network component to the VariableStorageComponent as a serialised string: component_id = %s to entity_id = %s!",
        component_id,
        entity_id
    )

    em.cache.nc_entity_ids[entity_id] = component_id
    em.cache.all_entity_ids[entity_id] = true

    return component_id
end

function em.SpawnEntity(owner, nuid, x, y, rot, filename)
    local entity_id = EntityLoad(filename, x, y)
    em.AddNetworkComponentToEntity(entity_id, owner, nuid)
    EntityApplyTransform(entity_id, x, y, rot)
    return entity_id
end

function em.UpdateEntities()
end

--- Get a network component by its entity id
--- @param entity_id number Id of the entity.
--- @return table nc Returns the network component.
function em.GetNetworkComponent(entity_id)
    if em.cache.nc_entity_ids[entity_id] then
        local nc_id = em.cache.nc_entity_ids[entity_id]
        local nc_serialised = ComponentGetValue(nc_id, "value_string")
        local nc = util.deserialise(nc_serialised)
        return nc
    end
end

return em
