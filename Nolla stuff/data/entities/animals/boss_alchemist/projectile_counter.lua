dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 48, "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		local vel_x, vel_y = 0,0
		local invalid = EntityHasTag( projectile_id, "boss_alchemist" )
		
		if ( invalid ~= true ) then
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local varstorcomponents = EntityGetComponent( projectile_id, "VariableStorageComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs(projectilecomponents) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			local projectile = "data/entities/projectiles/deck/rocket.xml"
			
			if ( varstorcomponents ~= nil ) then
				for j,comp_id in ipairs(varstorcomponents) do
					local name = ComponentGetValue2( comp_id, "name" )
					
					if ( name == "projectile_file" ) then
						projectile = ComponentGetValue2( comp_id, "value_string" )
						break
					end
				end
			end
			
			if ( velocitycomponents ~= nil ) then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
			
			edit_component( projectile_id, "ProjectileComponent", function(comp,vars)
				local dmg = ComponentGetValue2( comp, "damage" )
				dmg = dmg + 0.6
				ComponentSetValue2( comp, "damage", dmg )
				
				local edmg = ComponentObjectGetValue( comp, "config_explosion", "damage" )
				if ( edmg ~= nil ) then
					edmg = edmg * 2.0
					ComponentObjectSetValue( comp, "config_explosion", "damage", edmg )
				end
			end)
			
			if ( string.len(projectile) > 0 ) then
				local eid = shoot_projectile( entity_id, projectile, px, py, 0 - vel_x, 0 - vel_y )
				EntityAddTag( eid, "boss_alchemist" )
				EntityLoadToEntity("data/entities/animals/boss_alchemist/countered_projectile_effect.xml", eid)
			end
			EntityKill( projectile_id )
		end
	end
end