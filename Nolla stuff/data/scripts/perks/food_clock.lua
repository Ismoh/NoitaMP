dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comp = EntityGetFirstComponent( entity_id, "IngestionComponent" )

if ( comp ~= nil ) then
	local damage_starts_at_satiation_percent = 0.25
	local damage_warning_starts_at_satiation_percent = 0.27

	local count = ComponentGetValue2( comp, "ingestion_size" )
	local count_max = ComponentGetValue2( comp, "ingestion_capacity" )

	if (count < count_max * damage_warning_starts_at_satiation_percent) then
		ComponentSetValue2( comp, "m_damage_effect_lifetime", 2 ) -- flash the satiation status icon
	end

	if (count < count_max * damage_starts_at_satiation_percent) then
		local damage = 0.0
		component_read( EntityGetFirstComponent( entity_id, "DamageModelComponent" ), { max_hp = 1, hp = 0.04 }, function(damagemodel)
			damage = damagemodel.max_hp / 140
			
			if ( damagemodel.hp > damage ) then
				EntityInflictDamage( entity_id, damage, "DAMAGE_CURSE", "$damage_hunger", "NONE", 0, 0, entity_id )
			end
		end)
	end

end