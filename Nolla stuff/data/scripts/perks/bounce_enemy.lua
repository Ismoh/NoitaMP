dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			ComponentSetValue2( comp, "bounce_always", true )
			ComponentSetValue2( comp, "bounce_at_any_angle", true )
			ComponentSetValue2( comp, "bounce_energy", 0.9 )
			
			local v = ComponentGetValue2( comp, "bounces_left" )
			v = v + 10
			ComponentSetValue2( comp, "bounces_left", v )
			
			v = ComponentGetValue2( comp, "lifetime" )
			if ( v > 0 ) then
				v = v + 60
				ComponentSetValue2( comp, "lifetime", v )
			end
		end
	end
end