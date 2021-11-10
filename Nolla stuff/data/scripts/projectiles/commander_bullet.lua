dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 16, "projectile_player" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do
		if ( entity_id ~= projectile_id ) then
			EntityAddComponent( projectile_id, "HomingComponent", 
			{ 
				target_tag = "projectile_commander",
				homing_targeting_coeff = "200",
				homing_velocity_multiplier = "1.0",
			} )
			
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( velocitycomponents ~= nil ) then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
					
					local offset_x = Random( -150, 150 )
					local offset_y = Random( -150, 150 )

					vel_x = vel_x + offset_x
					vel_y = vel_y + offset_y

					ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
		end
	end
end