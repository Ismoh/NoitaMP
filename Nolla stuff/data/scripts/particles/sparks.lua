dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local how_many = Random(8,12)
local angle_inc = (( 2 * 3.14159 ) / how_many)
local theta = 0
local length = Random(350,550)

for i=1,how_many do
	local theta_rand = theta + Random(-10,10) * 0.1
	local vel_x = math.cos( theta_rand - 0.31415 ) * length
	local vel_y = math.sin( theta_rand - 0.31415 ) * length
	theta = theta + angle_inc

	shoot_projectile( entity_id, "data/entities/particles/particle_sparks.xml", pos_x, pos_y, vel_x, vel_y )
end
