dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
local distance_full = 50
local ax = 0
local ay = 0

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

edit_component( player_id, "ControlsComponent", function(comp,vars)
	ax,ay = ComponentGetValue2( comp, "mAimingVector" )
end)

local a = 0 - math.atan2( ay, ax )

EntitySetTransform( entity_id, x, y, 0 - a )

if ( #projectiles > 0 ) then
	local pickup_count = get_stored_perk_pickup_count( entity_id )

	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		local distance = get_distance( px, py, x, y )
		local direction = get_direction( px, py, x, y )
		
		local dirdelta = get_direction_difference( direction, a )
		local dirdelta_deg = math.abs( math.deg( dirdelta ) )
		
		if ( distance < distance_full ) and ( dirdelta_deg < 15.0 ) then
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.01)
			local gravity_coeff = 240 * pickup_count
			if EntityHasTag(projectile_id, "resist_repulsion") then gravity_coeff = gravity_coeff * 0.25 end
			
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