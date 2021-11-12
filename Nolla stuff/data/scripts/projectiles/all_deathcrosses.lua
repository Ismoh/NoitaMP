dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if ( tags == nil ) or ( string.find( tags, "death_cross" ) == nil ) then
			local px, py = EntityGetTransform( projectile_id )
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs( projectilecomponents ) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			SetRandomSeed( px, py - 543 )
			local opts = { "death_cross", "death_cross_big" }
			local rnd = Random( 1, #opts )
			local opt = opts[rnd]
			
			shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/" .. opt .. ".xml", px, py, 0, 0 )
			EntityKill( projectile_id )
		end
	end
end