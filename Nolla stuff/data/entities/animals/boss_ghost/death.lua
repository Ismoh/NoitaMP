dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x, y )
	EntityLoad( "data/entities/items/pickup/sun/sunseed.xml",  x + 16, y )
	
	AddFlagPersistent( "miniboss_ghost" )
end