dofile_once("data/scripts/lib/utilities.lua")

function throw_item( from_x, from_y, to_x, to_y )
	local entity_id = GetUpdatedEntityID()

	EntitySetComponentsWithTagEnabled(entity_id, "enabled_on_throw", true)

	-- store throw time for safe_haven_spawn.lua
	local storage_comp = get_variable_storage_component(entity_id, "throw_time")
	ComponentSetValue2(storage_comp, "value_int", GameGetFrameNum())

	-- store health from player
	local hp = 4.0
	local player = EntityGetClosestWithTag( from_x, from_y, "player_unit" )
	if player ~= nil then
		component_read( EntityGetFirstComponent(player, "DamageModelComponent"), { max_hp = 4.0 }, function(comp)
			hp = comp.max_hp
		end)
	end
	storage_comp = get_variable_storage_component(entity_id, "player_hp")
	ComponentSetValue2(storage_comp, "value_float", hp)
end

