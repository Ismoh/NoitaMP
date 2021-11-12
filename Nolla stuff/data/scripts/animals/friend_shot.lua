dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_entity_id )
	local tcount = tonumber( GlobalsGetValue( "ULTIMATE_KILLER_KILLS", "0" ) )
	
	if ( tcount > 0 ) then
		local c = EntityGetFirstComponent( projectile_entity_id, "ProjectileComponent" )
		if ( c ~= nil ) then
			local d = ComponentGetValue2( c, "damage" )
			local ed = ComponentObjectGetValue2( c, "config_explosion", "damage" )
			local er = ComponentObjectGetValue2( c, "config_explosion", "explosion_radius" )
			
			d = d + tcount * 0.25
			ed = ed + tcount * 0.5
			er = er + tcount * 2
			
			ComponentSetValue2( c, "damage", d )
			ComponentObjectSetValue2( c, "config_explosion", "damage", ed )
			ComponentObjectSetValue2( c, "config_explosion", "explosion_radius", er )
		end
	end
end