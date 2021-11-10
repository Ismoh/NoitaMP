dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if ( tags == nil ) or ( string.find( tags, "rocket" ) == nil ) then
			local px, py = EntityGetTransform( projectile_id )
			local vel_x, vel_y = 0,0
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs( projectilecomponents ) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			if ( velocitycomponents ~= nil ) then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
			
			SetRandomSeed( px, py - 53 )
			local opts = { "rocket", "rocket_tier_2", "rocket_tier_3" }
			local rnd = Random( 1, #opts )
			local opt = opts[rnd]
			
			shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/" .. opt .. ".xml", px, py, vel_x, vel_y )
			EntityKill( projectile_id )
		end
	end
end