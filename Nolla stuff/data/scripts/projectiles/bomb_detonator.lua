dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )
local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

-- print( tostring( comp2 ) )

if ( #projectiles > 0 ) and ( comp2 ~= nil ) then
	for i,projectile_id in ipairs(projectiles) do
		local comp = EntityGetFirstComponent( projectile_id, "ProjectileComponent" )
		
		if ( comp ~= nil ) and ( entity_id ~= projectile_id ) then
			local id1 = ComponentGetValue2( comp, "mWhoShot" )
			local id2 = ComponentGetValue2( comp2, "mWhoShot" )
			
			local test1 = ComponentGetValue2( comp, "on_death_explode" )
			local test2 = ComponentGetValue2( comp, "on_lifetime_out_explode" )
			local test3 = ComponentObjectGetValue2( comp, "config_explosion", "explosion_radius" )
			
			-- print( tostring(id1) .. " = " .. tostring(id2) .. ", " .. tostring(test1) .. ", " .. tostring(test2) .. ", " .. tostring(test3) )
			
			if ( id1 == id2 ) and ((test1 == true) or (test2 == true) (test3 > 2)) then
				ComponentSetValue2( comp, "on_death_explode", true )
				ComponentSetValue2( comp, "on_lifetime_out_explode", true )
			end
			
			EntityKill( projectile_id )
		end
	end
end