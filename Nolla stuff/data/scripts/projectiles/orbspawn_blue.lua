dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local how_many = 8
local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = 0
local length = 150

for i=1,how_many do
	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc

	GameEntityPlaySound( entity_id, "duplicate" )
	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/orb_blue.xml", pos_x, pos_y, vel_x, vel_y )
end


