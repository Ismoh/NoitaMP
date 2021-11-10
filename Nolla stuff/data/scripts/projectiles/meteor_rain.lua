dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), pos_x + pos_y + entity_id )

local count = Random(1,3)

for i=1,count do
	local angle = math.pi * ( Random( 1, 200 ) * 0.01 )
	local x = pos_x + math.cos( angle ) * 300
	local y = pos_y - math.sin( angle ) * 300
	local vx = math.cos( angle + math.pi ) * 900
	local vy = 0 - math.sin( angle + math.pi ) * 900
	
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/meteor_rain_meteor.xml", x, y, vx, vy )
end

GameScreenshake( 15 )
