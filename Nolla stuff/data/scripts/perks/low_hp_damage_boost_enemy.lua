dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local shooter_id = 0
	local hp,max_hp = 0,0
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		shooter_id = ComponentGetValue2( comp, "mWhoShot" )
	end)
	
	if ( shooter_id ~= nil ) and ( shooter_id ~= NULL_ENTITY ) then
		edit_component( shooter_id, "DamageModelComponent", function(comp,vars)
			hp = ComponentGetValue2( comp, "hp" )
			max_hp = ComponentGetValue2( comp, "max_hp" )
		end)
		
		if ( hp ~= nil ) and ( max_hp ~= nil ) and ( hp > 0 ) and ( max_hp > 0 ) then
			local hpercent = hp / max_hp
			
			if ( hpercent <= 0.2 ) then
				local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	
				if( comps ~= nil ) then
					for i,comp in ipairs(comps) do
						local damage = ComponentGetValue2( comp, "damage" )
						damage = damage * 2.0
						ComponentSetValue2( comp, "damage", damage )
						
						local dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill", "fire" }
						for a,b in ipairs(dtypes) do
							local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
							v = v * 2.0
							ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
						end
						
						local etypes = { "explosion_radius", "ray_energy", "damage" }
						for a,b in ipairs(etypes) do
							local v = tonumber(ComponentObjectGetValue( comp, "config_explosion", b ))
							v = v * 2.0
							ComponentObjectSetValue( comp, "config_explosion", b, tostring(v) )
						end
					end
				end
			end
		end
	end
end