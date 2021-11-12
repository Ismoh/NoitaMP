dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( pos_x * pos_y, entity_id )

local how_many = 16
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = 0

for i=1,how_many do
	local length = Random( 50, 250 )
	
	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc

	shoot_projectile( entity_id, "data/entities/projectiles/pollen.xml", pos_x + vel_x * 0.05, pos_y + vel_x * 0.05, vel_x, vel_y )
end

EntityLoad( "data/entities/particles/poof_white.xml", pos_x, pos_y )
EntityKill( entity_id )