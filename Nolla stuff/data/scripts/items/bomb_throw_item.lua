dofile( "data/scripts/lib/utilities.lua")

function throw_item( from_x, from_y, to_x, to_y )
	local entity_id = GetUpdatedEntityID()

	EntitySetComponentsWithTagEnabled( entity_id, "timer", true )

	edit_component( entity_id, "ItemComponent", function( comp, vars )
		EntityRemoveComponent( entity_id, comp)
	end)
end



