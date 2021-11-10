dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local distance_full = 96
local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

if ( projectiles ~= nil ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		print("In Radius!!")
		
		distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 )
		direction = math.pi - math.atan2( ( y - py ), ( x - px ) )
		local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
		
		local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.01)
		local gravity_coeff = 109
		
		if ( velocitycomponents ~= nil ) then
			edit_component( projectile_id, "VelocityComponent", function(comp,vars)
				local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )
				
				local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent )
				local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent )

				vel_x = vel_x + offset_x
				vel_y = vel_y + offset_y

				ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
			end)
		end
	end
end