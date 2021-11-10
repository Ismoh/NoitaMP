dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- check that we're only shooting every 10 frames
if script_wait_frames( entity_id, 10 ) then  return  end

local how_many = 10
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = 0
local length = 100

for i=1,how_many do
	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc
	
	local px = pos_x + vel_x * 0.1
	local py = pos_y + vel_y * 0.1

	GameEntityPlaySound( entity_id, "duplicate" )
	shoot_projectile( entity_id, "data/entities/projectiles/orb_green_boss_dragon.xml", px, py, vel_x, vel_y )
end

GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/orb_dragon/create", pos_x, pos_y )