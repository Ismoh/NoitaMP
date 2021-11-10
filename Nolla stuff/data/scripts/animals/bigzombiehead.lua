dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	EntityLoad( "data/entities/projectiles/explosion.xml", x, y )
end