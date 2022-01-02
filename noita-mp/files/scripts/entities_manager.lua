local em = {
    cached_entity_ids = {}
}

function em.UpdateEntitiesWithTag(tag)
    local entity_ids = EntityGetWithTag(tag)

    -- Ignore already checked entities by removing it with a cached list
    entity_ids = table.removeByTable(entity_ids, em.cached_entity_ids)

    if #entity_ids > 0 then
        for index, entity_id in ipairs(entity_ids) do
            local added = false

            local component_ids = EntityGetAllComponents(entity_id)
            if #component_ids > 0 then
                for index, component_id in ipairs(component_ids) do
                    local component_name = ComponentGetTypeName(component_id)
                    if component_name == "LuaComponent" then
                        local script_source_file = ComponentGetValue2(component_id, "script_source_file")
                        if
                            script_source_file ~= nil and
                                script_source_file == "noita-mp/files/scripts/components/network_component.lua"
                         then
                            added = true
                        end
                    end
                end
            end

            if added == false then
                logger:debug("test 123. Adding component!")
                local component_id =
                    EntityAddComponent2(
                    entity_id,
                    "LuaComponent",
                    {
                        script_source_file = "mods/noita-mp/files/scripts/components/network_component.lua",
                        execute_on_added = true,
                        execute_every_n_frame = 1,
                        call_init_function = true,
                        vm_type = "SHARED_BY_MANY_COMPONENTS",
                        mPersistentValues = {["logger"] = _G.logger}
                    }
                )
                added = true
            end

            table.insert(em.cached_entity_ids, entity_id)

            logger:debug("Found entity '%s' by tag '%s'", entity_id, tag)
        end
    end
end

return em
