local util = require("util")
local NetworkComponent = require("network_component_class")

local em = {
    cached_entity_ids = {}
}

--- Checks for entities in a specific range/radius to the player_units.
--- If there are entities in this radius, a NetworkComponent will be added as a VariableStorageComponent.
--- If entities does not have VelocityComponents, those will be ignored.
--- Every checked entity will be put into a cache list, to stop iterating over the same entities again and again.
function em.AddNetworkComponent()
    -- local entity_ids = EntityGetWithTag("root") or {}
    local entity_ids = {}

    local player_unit_ids = EntityGetWithTag("player_unit")
    for index_player_unit_id, player_unit_id in ipairs(player_unit_ids) do
        -- get all player units
        local x, y, rot, scale_x, scale_y = EntityGetTransform(player_unit_id)

        -- find all entities in a specific radius based on the player units position
        local temp_entity_ids = EntityGetInRadius(x, y, 1000)

        for index_entity_id, entity_id in ipairs(temp_entity_ids) do
            -- if table.contains(em.cached_entity_ids, entity_id) then
            --     -- if entity was already checked, skip it
            --     break
            -- end

            if not table.contains(em.cached_entity_ids, entity_id) then -- if entity was already checked, skip it
                -- loop all components of the entity
                local component_ids = EntityGetAllComponents(entity_id)

                local has_velocity_component = false
                for index_component_id, component_id in ipairs(component_ids) do
                    -- search for VelocityComponent
                    local component_name = ComponentGetTypeName(component_id)
                    if component_name == "VelocityComponent" then
                        has_velocity_component = true
                        local variable_storage_component_ids =
                            EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

                        -- if variable_storage_component_ids == nil or variable_storage_component_ids == {} then
                        --     em.AddNetworkComponentToEntity(entity_id)
                        -- end

                        local has_network_component = false
                        for index_variable_storage_component_id, variable_storage_component_id in ipairs(
                            variable_storage_component_ids
                        ) do
                            -- check if the entity already has a VariableStorageComponent
                            local variable_storage_component_name =
                                ComponentGetValue2(variable_storage_component_id, "name") or nil
                            if variable_storage_component_name == "network_component_class" then
                                -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
                                has_network_component = true
                            end
                        end

                        if has_network_component == false then
                            -- if the VariableStorageComponent is not a 'network_component_class', then add one
                            em.AddNetworkComponentToEntity(entity_id)
                        end
                    end
                end

                if has_velocity_component == false then
                    -- if the entity does not have a VelocityComponent, skip it always
                    -- logger:debug("Entity %s does not have a VelocityComponent. Ignore it.", entity_id)
                    table.insertIfNotExist(em.cached_entity_ids, entity_id)
                end
            end
        end
    end
end

--- Adds a NetworkComponent to an entity, if it doesn't exist already.
--- @param entity_id number The entity id where to add the NetworkComponent.
--- @param guid string guid to know the owner (optional)
--- @return number component_id Returns the component_id. The already existed one or the newly created id.
function em.AddNetworkComponentToEntity(entity_id, guid)
    local variable_storage_component_ids =
        EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

    -- check if the entity already has a NetworkComponent. If so skip this function by returning the component_id
    for index, variable_storage_component_id in ipairs(variable_storage_component_ids) do
        local variable_storage_component_name = ComponentGetValue2(variable_storage_component_id, "name") or nil
        if variable_storage_component_name == "network_component_class" then
            -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
            table.insertIfNotExist(em.cached_entity_ids, entity_id)
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
    local nc = NetworkComponent:new(nil, component_id, owner)
    local nc_serialised = util.serialise(nc:toSerialisableTable())

    ComponentSetValue2(component_id, "value_string", nc_serialised)
    logger:debug(
        "Added network component to the VariableStorageComponent as a serialised string: component_id = %s to entity_id = %s!",
        component_id,
        entity_id
    )

    table.insertIfNotExist(em.cached_entity_ids, entity_id)
    return component_id
end

function em.SpawnEntity(owner, filename, x, y)
    local entity_id = EntityLoad(filename, x, y)
    em.AddNetworkComponentToEntity(entity_id)
    return entity_id
end

return em
