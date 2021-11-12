dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
local distance_full = 24
local ax = 0
local ay = 0

local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

edit_component( player_id, "ControlsComponent", function(comp,vars)
	ax,ay = ComponentGetValue2( comp, "mAimingVector" )
end)

local a = math.pi - math.atan2( ay, ax )

EntitySetTransform( entity_id, x, y, 0 - a )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		local distance = get_distance( px, py, x, y )
		local direction = get_direction( px, py, x, y )
		
		local dirdelta = get_direction_difference( direction, a )
		local dirdelta_deg = math.abs( math.deg( dirdelta ) )
		
		if ( distance < distance_full ) and ( dirdelta_deg < 24.0 ) then
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
				
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs(projectilecomponents) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			EntityKill( projectile_id )
		end
	end
end