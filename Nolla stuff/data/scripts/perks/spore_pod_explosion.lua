dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
SetRandomSeed( x * entity_id, y + GameGetFrameNum() )

for i=1,20 do
	local vel_x = Random( -100, 100 )
	local vel_y = Random( -100, 100 )
	shoot_projectile_from_projectile( entity_id, "data/entities/misc/perks/spore_pod_spike.xml", x, y, vel_x, vel_y )
end