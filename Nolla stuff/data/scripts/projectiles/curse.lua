dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local who_shot = entity_id

if ( EntityHasTag( entity_id, "curse_NOT" ) == false ) then
	local damage = 0.08

	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,comp in ipairs( comps ) do
			local name = ComponentGetValue2( comp, "name" )
			
			if ( name == "effect_curse_damage" ) then
				damage = ComponentGetValue2( comp, "value_float" )
			elseif ( name == "projectile_who_shot" ) then
				who_shot = ComponentGetValue2( comp, "value_int" )
			end
		end
	end

	EntityInflictDamage( root_id, damage, "DAMAGE_CURSE", "$damage_hitfx_curse", "DISINTEGRATED", 0, 0, who_shot )
end