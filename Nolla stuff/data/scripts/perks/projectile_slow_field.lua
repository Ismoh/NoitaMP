dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local distance_full = 66

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
		
		if ( velocitycomponents ~= nil ) then
			edit_component( projectile_id, "VelocityComponent", function(comp,vars)
				local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
				
				vel_x = vel_x * 0.9
				vel_y = vel_y * 0.9

				ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
			end)
		end
	end
end