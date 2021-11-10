dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y,r = EntityGetTransform( entity_id )

local opts = { "orb_dark", "orb_poly", "orb_tele" }

for i=1,2 do
	SetRandomSeed( x * GameGetFrameNum(), y + i )
	
	local arc = Random( 0, 100 ) * 0.01 * math.pi * 2
	local vel_x = math.cos( arc ) * 250
	local vel_y = 0 - math.sin( arc ) * 250
	
	local rnd = Random( 1, #opts )
	
	local eid = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/" .. opts[rnd] .. ".xml", x, y, vel_x, vel_y )
end