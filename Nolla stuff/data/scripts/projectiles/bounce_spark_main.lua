dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( pos_x + entity_id, pos_y + GameGetFrameNum() )

local angle = math.pi * 2 * ProceduralRandom( pos_x - 253, pos_y + GameGetFrameNum() )
local speed = Random( 200, 300 )

local vel_x = math.cos( 0 - angle ) * speed
local vel_y = 0 - math.sin( 0 - angle ) * speed

shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/bounce_spark_friendly_fire.xml", pos_x, pos_y, vel_x, vel_y, false )

local extra = math.max( 0, Random( -2, 1 ) )

if ( extra > 0 ) then
	for i=1,extra do
		angle = math.pi * 2 * ProceduralRandom( pos_x + 346, pos_y + GameGetFrameNum() )
		speed = Random( 200, 300 )
		
		vel_x = math.cos( 0 - angle ) * speed
		vel_y = 0 - math.sin( 0 - angle ) * speed
		
		shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/bounce_spark_friendly_fire_silent.xml", pos_x, pos_y, vel_x, vel_y, false )
	end
end

EntityKill( entity_id )