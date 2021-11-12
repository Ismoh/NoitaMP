dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

component_readwrite(get_variable_storage_component(entity_id, "meditation_count"), { value_int = 0}, function(comp)
	local player = EntityGetInRadiusWithTag( pos_x, pos_y+40, 25, "player_unit" )[1]
	if player ~= nil then
		-- player is near, proceed with countdown...
		comp.value_int = comp.value_int + 1
		if comp.value_int >= 18 then
			-- enable teleporter & fx, disable script
			EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_meditation", true )
			EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_meditation_early", false )
			EntitySetComponentIsEnabled( entity_id, GetUpdatedComponentID(), false)
		elseif comp.value_int >= 6 then
			-- teaser fx
			EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_meditation_early", true )
		end
	else
		-- reset
		EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_meditation_early", false )
		comp.value_int = 0
	end
end)

