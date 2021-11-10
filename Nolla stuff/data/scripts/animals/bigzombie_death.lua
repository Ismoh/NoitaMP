dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	EntityLoad( "data/entities/animals/bigzombietorso.xml", x, y )	
	EntityLoad( "data/entities/animals/bigzombiehead.xml",  x, y )
end