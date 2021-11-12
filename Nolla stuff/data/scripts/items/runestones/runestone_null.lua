dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 192, "projectile" )
if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local px, py = EntityGetTransform( projectile_id )
		
		local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
		local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
		
		if ( projectilecomponents ~= nil ) then
			for j,comp_id in ipairs( projectilecomponents ) do
				ComponentSetValue( comp_id, "on_death_explode", "0" )
				ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
			end
		end
		
		EntityLoad( "data/entities/particles/runestone_null.xml", px, py )
		EntityKill( projectile_id )
	end
end