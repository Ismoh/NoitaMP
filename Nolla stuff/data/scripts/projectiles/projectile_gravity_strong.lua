dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		local distance = math.abs( x - px ) + math.abs( y - py )
		local distance_full = 96
		
		if ( distance < distance_full * 1.25 ) and ( entity_id ~= projectile_id ) then
			distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 )
			direction = 0 - math.atan2( ( y - py ), ( x - px ) )
	
			if ( distance < distance_full ) then
				local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
				
				local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.2)
				local gravity_coeff = 192
				
				if ( velocitycomponents ~= nil ) then
					edit_component( projectile_id, "VelocityComponent", function(comp,vars)
						local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
						
						local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent )
						local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent )

						vel_x = vel_x + offset_x
						vel_y = vel_y + offset_y

						ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
					end)
				end
			end
		end
	end
end