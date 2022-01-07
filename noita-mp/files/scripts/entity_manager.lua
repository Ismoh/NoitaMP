local util = require("util")
local NetworkComponent = require("network_component_class")

local em = {
    cached_entity_ids = {}
}

--- Adds a network component to an entity, if it doesn't exist already.
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
            if table.contains(em.cached_entity_ids, entity_id) then
                -- if entity was already checked, skip it
                break
            end

            -- loop all components of the entity
            local component_ids = EntityGetAllComponents(entity_id)

            local is_velocity_component = false
            for index_component_id, component_id in ipairs(component_ids) do
                -- search for VelocityComponent
                local component_name = ComponentGetTypeName(component_id)
                if component_name == "VelocityComponent" then
                    is_velocity_component = true
                    break
                end

                if is_velocity_component and component_name == "VariableStorageComponent" then
                    is_velocity_component = false
                    -- check if the entity already has a VelocityComponent and a VariableStorageComponent
                    local variable_storage_component_name = ComponentGetValue2(component_id, "name") or nil
                    if variable_storage_component_name == "network_component_class" then
                        -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
                        break
                    else
                        -- if the VariableStorageComponent is not a 'network_component_class', then add one
                        local component_id =
                            EntityAddComponent2(
                            entity_id,
                            "VariableStorageComponent",
                            {
                                name = "network_component_class",
                                value_string = nil
                            }
                        )
                        logger:debug("VariableStorageComponent added with noita component_id = %s!", component_id)

                        local nc = NetworkComponent:new(nil, component_id, "TODO get client or server")
                        local nc_serialised = util.serialise(nc:toSerialisableTable())

                        ComponentSetValue2(component_id, "value_string", nc_serialised)
                        logger:debug("Added network component to the VariableStorageComponent as a serialised string.")

                        table.insert(em.cached_entity_ids, entity_id)
                    end
                end
            end
        end
    end

    -- Ignore already checked entities by removing it with a cached list
    entity_ids = table.removeByTable(entity_ids, em.cached_entity_ids)

    if #entity_ids > 0 then
        for index, entity_id in ipairs(entity_ids) do
            local added = false

            local component_ids = EntityGetAllComponents(entity_id)
            if #component_ids > 0 then
                for index, component_id in ipairs(component_ids) do
                    local component_name = ComponentGetTypeName(component_id)
                    if component_name == "VariableStorageComponent" then
                        -- local script_source_file = ComponentGetValue2(component_id, "script_source_file")
                        -- if
                        --     script_source_file ~= nil and
                        --         script_source_file == "noita-mp/files/scripts/components/network_component.lua"
                        --  then
                        added = true
                    -- end
                    end
                end
            end

            if added == false then
                logger:debug("Adding custom network component!")

                local component_id =
                    EntityAddComponent2(
                    entity_id,
                    "VariableStorageComponent",
                    {
                        name = "network_component_class",
                        value_string = nil
                    }
                )
                logger:debug("VariableStorageComponent added with noita component_id = %s!", component_id)

                local nc = NetworkComponent:new(nil, component_id, "TODO get client or server")
                local nc_serialised = util.serialise(nc:toSerialisableTable())

                ComponentSetValue2(component_id, "value_string", nc_serialised)
                logger:debug("Added network component to the VariableStorageComponent as a serialised string.")

                added = true
            end

            table.insert(em.cached_entity_ids, entity_id)

            logger:debug("Found entity '%s' by tag '%s'", entity_id, tag)
        end
    end
end

return em
