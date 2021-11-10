dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal, proj_id )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local projs = EntityGetInRadiusWithTag( x, y, 36, "projectile" )
	
	for i,projectile_id in ipairs( projs ) do
		if ( projectile_id ~= entity_who_caused ) and ( projectile_id ~= proj_id ) then
			local px,py = EntityGetTransform( projectile_id )
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs(projectilecomponents) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			EntityLoad("data/entities/particles/neutralized_tiny.xml", px, py)
			EntityKill( projectile_id )
		end
	end
	
	local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	local comp2 = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "boss_wizard_mode" )
	if ( comp ~= nil ) and ( comp2 ~= nil ) then
		local hp = ComponentGetValue2( comp, "hp" )
		local max_hp = ComponentGetValue2( comp, "max_hp" )
		local mode = ComponentGetValue2( comp2, "value_int" )
		
		if ( hp / max_hp < 0.5 ) and ( mode == 0 ) then
			mode = 1
			EntitySetComponentsWithTagEnabled( entity_id, "helmet", false )
			EntitySetComponentsWithTagEnabled( entity_id, "head", true )
			EntityLoad( "data/entities/particles/blood_explosion.xml", x, y - 40 )
		elseif ( hp / max_hp < 0.2 ) and ( mode == 1 ) then
			mode = 2
			EntitySetComponentsWithTagEnabled( entity_id, "hand", false )
			EntitySetComponentsWithTagEnabled( entity_id, "head", false )
			EntitySetComponentsWithTagEnabled( entity_id, "end", true )
			EntityLoad( "data/entities/particles/blood_explosion.xml", x, y - 20 )
			
			local hcomp = EntityGetFirstComponent( entity_id, "HotspotComponent" )
			if ( hcomp ~= nil ) then
				ComponentSetValue2( hcomp, "sprite_hotspot_name", "shoot_pos" )
			end
		end
		
		ComponentSetValue2( comp2, "value_int", mode )
	end
end