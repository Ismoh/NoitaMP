dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

for i=1,2 do
	SetRandomSeed( x * GameGetFrameNum(), y + i )
	
	local arc = Random( 0, 100 ) * 0.01 * math.pi * 2
	local vel_x = math.cos( arc ) * 150
	local vel_y = 0 - math.sin( arc ) * 150
	
	local eid = shoot_projectile( entity_id, "data/entities/animals/boss_wizard/bloodtentacle.xml", x, y - 32, vel_x, vel_y )
end