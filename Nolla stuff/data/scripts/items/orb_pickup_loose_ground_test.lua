dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item )

	shoot_projectile( entity_item, "data/entities/particles/image_emitters/orb_effect.xml", pos_x, pos_y, 0, 0 )
	EntityLoad( "data/entities/misc/loose_chunks_lavalake.xml", pos_x - 120, pos_y + 40 )
	EntityLoad( "data/entities/misc/loose_chunks_lavalake.xml", pos_x - 80, pos_y + 40 )
	EntityLoad( "data/entities/misc/loose_chunks_lavalake.xml", pos_x, pos_y + 40 )
	EntityLoad( "data/entities/misc/loose_chunks_lavalake.xml", pos_x + 120, pos_y + 40 )
	EntityLoad( "data/entities/misc/loose_chunks_lavalake.xml", pos_x + 80, pos_y + 40 )
	EntityKill( entity_item )
end