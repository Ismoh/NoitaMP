dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun.lua")
local speed = 4000

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

-- velocity
local vel_x,vel_y = GameGetVelocityCompVelocity(entity_id)
vel_x, vel_y = vec_normalize(vel_x, vel_y)
if vel_x == nil then return end
vel_x = vel_x * speed
vel_y = vel_y * speed

local count = 3

SetRandomSeed( pos_x * vel_x, pos_y * vel_y )

for i=1,count do
	local px = pos_x + vel_x * 0.01
	local py = pos_y + vel_y * 0.01
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/enlightened_laser_elecbeam.xml", px + Random( -8, 8 ), py + Random( -8, 8 ), vel_x, vel_y )
end

-- sound is played here instead of the projectiles to avoid duplicates
--GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser/create", pos_x, pos_y )

