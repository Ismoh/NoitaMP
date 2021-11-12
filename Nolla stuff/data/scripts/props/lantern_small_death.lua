dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- print_error("message death")
	local entity_id		= GetUpdatedEntityID()
	local pos_x, pos_y	= EntityGetTransform( entity_id )

	EntityLoad( "data/entities/particles/lantern_small_death.xml", pos_x, pos_y )
end