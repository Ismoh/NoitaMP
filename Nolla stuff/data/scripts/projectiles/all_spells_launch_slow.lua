dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local players = EntityGetWithTag( "player_unit" )

for i,v in ipairs( players ) do
	SetRandomSeed( pos_x, pos_y )
	pos_x, pos_y = EntityGetTransform( v )
	
	local offx = ( ( Random( 0, 1 ) * 2 ) - 1 ) * 48
	local offy = ( ( Random( 0, 1 ) * 2 ) - 1 ) * 48
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/all_spells_loader.xml", pos_x + offx, pos_y + offy, 0, 0 )
	GamePrintImportant( "$log_all_spells", "$logdesc_all_spells" )
end
