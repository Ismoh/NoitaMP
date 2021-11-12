dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	EntityLoad( "data/entities/projectiles/deck/black_hole_big.xml", pos_x, pos_y )
	
	EntityKill( entity_id )
end