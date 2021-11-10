dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = Random(1,3)

for i=1,count do
	shoot_projectile( entity_id, "data/entities/projectiles/meteor_green.xml", pos_x + Random( -360, 360 ), pos_y - 300, Random( -200, 200 ), Random( 700, 1500 ) )
end

GameScreenshake( 15 )
