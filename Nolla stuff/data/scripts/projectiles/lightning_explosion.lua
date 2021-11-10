dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local how_many = 4
local angle_inc = ( 2 * 3.14159 ) / how_many + math.rad(ProceduralRandomf( pos_x, pos_y, 30) - ProceduralRandomf( pos_x + 2.5532, pos_y + 59.8, 30))
local theta = 0
local length = 5000

for i=1,how_many do
	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc
	
	shoot_projectile( entity_id, "data/entities/projectiles/deck/lightning.xml", pos_x, pos_y, vel_x, vel_y )
end
