dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * 3.0
			ComponentSetValue2( comp, "damage", damage )
			
			local dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill", "fire" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * 3.0
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
			
			local etypes = { "explosion_radius", "ray_energy", "sparks_count_max", "camera_shake", "damage", "material_sparks_count_max", "physics_explosion_power.max", "stains_radius" }
			for a,b in ipairs(etypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "config_explosion", b ))
				v = v * 4.0
				ComponentObjectSetValue( comp, "config_explosion", b, tostring(v) )
			end
		end
	end
end