dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 192, "projectile" )
if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local vel_x, vel_y = 0,0
		
		local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
		
		if ( velocitycomponents ~= nil ) then
			edit_component( projectile_id, "VelocityComponent", function(comp,vars)
				vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
				
				vel_x = vel_x * 0.25
				vel_y = vel_y * 0.25
				
				ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
			end)
		end
	end
end