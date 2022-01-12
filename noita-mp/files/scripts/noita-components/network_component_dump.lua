function init(entity_id)
    -- if _G.logger == nil then
    --     dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
    -- end
    --logger:debug("Entity %s called init()", entity_id)
    print("Entity " .. entity_id .. " called init()")
end

function collision_trigger(colliding_entity_id)
    local this_id = GetUpdatedEntityID()
    local test_field = ComponentGetValue2(colliding_entity_id, "test_field")
    print(("Entity %s test_field = %s"):format(this_id, test_field))
end
