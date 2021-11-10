dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local area = 70
local enemies = EntityGetInRadiusWithTag( pos_x, pos_y, area, "homing_target" )
 
SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

-- print( Random(0-area, area) )
-- print( Random(0-area, area) )
pos_x = pos_x + Random(0-area, area)
pos_y = pos_y + Random(0-area, area)

if ( #enemies > 0 ) and ( Random( 1, 5 ) == 2 ) then
	local rnd = Random( 1, #enemies )
	local enemy_id = enemies[rnd]
	
	local ex, ey = EntityGetTransform( enemy_id )
	
	pos_x = ex
	pos_y = ey
end

local projectile = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/purple_explosion.xml", pos_x, pos_y, 0, 0 )