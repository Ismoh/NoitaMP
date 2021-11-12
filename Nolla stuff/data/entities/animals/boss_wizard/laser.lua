dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y,r = EntityGetTransform( entity_id )

local test = EntityGetWithTag( "boss_wizard_laser" )

if ( #test < 6 ) then
	for i=1,3 do
		local arc = (math.pi * 2 / 3) * (i-1) + r
		local vel_x = math.cos( arc ) * 100
		local vel_y = 0 - math.sin( arc ) * 100
		
		local eid = shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_wizard/laser.xml", x, y, vel_x, vel_y )
		
		if ( #test > 3 ) then
			EntitySetComponentsWithTagEnabled( eid, "LuaComponent", "boss_wizard_laser_multiply", false )
		end
	end
end