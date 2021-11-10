dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local distance_full = 50

SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )
local direction_random = math.rad( Random( -30, 30 ) )

if ( #projectiles > 0 ) then
	local pickup_count = get_stored_perk_pickup_count( entity_id )

	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		local distance = get_distance( px, py, x, y )
		local direction = get_direction( px, py, x, y )

		if ( distance < distance_full ) then
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.01)
			local gravity_coeff = 96 * pickup_count
			if EntityHasTag(projectile_id, "resist_repulsion") then gravity_coeff = gravity_coeff * 0.25 end
			
			if ( velocitycomponents ~= nil ) then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
					
					local offset_x = math.cos( direction + direction_random ) * ( gravity_coeff * gravity_percent )
					local offset_y = 0 - math.sin( direction + direction_random ) * ( gravity_coeff * gravity_percent )

					vel_x = vel_x + offset_x
					vel_y = vel_y + offset_y

					ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
		end
	end
end