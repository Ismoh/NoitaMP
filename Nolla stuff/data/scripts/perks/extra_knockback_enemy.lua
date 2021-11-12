dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local val = ComponentGetValue2( comp, "knockback_force" )
			val = (val + 0.5) * 2.0
			ComponentSetValue2( comp, "knockback_force", val )
			
			local dtypes = { "ragdoll_force_multiplier", "hit_particle_force_multiplier" }
			for a,b in ipairs(dtypes) do
				local v = ComponentGetValue2( comp, b )
				v = (v + 0.25) * 2.0
				ComponentSetValue2( comp, b, v )
			end
		end
	end
end