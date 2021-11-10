dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local how_many = 4
local angle_inc = math.pi * 0.5
local theta = 0
local length = 200
local length_base = 300

GamePlaySound( "data/audio/Desktop/explosion.bank", "explosions/magic_rocket_big", pos_x, pos_y )

for i=1,how_many do
	for j=1,4 do
		local vel_x = math.cos( theta ) * (length * j + length_base)
		local vel_y = math.sin( theta ) * (length * j + length_base)

		shoot_projectile( entity_id, "data/entities/projectiles/deck/death_cross_big_laser.xml", pos_x, pos_y, vel_x, vel_y )
	end
	
	theta = theta + angle_inc
end
