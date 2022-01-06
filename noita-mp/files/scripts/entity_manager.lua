local util = require("util")
local NetworkComponent = require("network_component_class")

local em = {
    cached_entity_ids = {}
}

--- Adds a network component to an entity, if it doesn't exist already.
--- @param tag string Have a look on Noita API regarding available tags.
function em.AddNetworkComponent(tag)
    local entity_ids = EntityGetWithTag("") or {}
    -- local entity_ids = {}

    -- local player_units = EntityGetWithTag("player_unit")
    -- for index_player_units, player_unit_id in ipairs(player_units) do
    --     local temp_entity_ids = EntityGetInRadius(player_unit.pos_x, player_unit.pos_y, 100)
    --     for index, entity_id in ipairs(temp_entity_ids) do
    --         table.insert(entity_ids, entity_id)
    --     end
    -- end

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
