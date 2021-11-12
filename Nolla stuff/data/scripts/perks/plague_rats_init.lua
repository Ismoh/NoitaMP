dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local flag_name = "RAT_PERK_TOTAL_COUNT"
local pickup_count = tonumber( GlobalsGetValue( flag_name, "0" ) )
	
local extra_hp = math.max( 0, pos_y * 0.0002 ) + ( pickup_count - 1 ) * 4
local extra_damage = math.max( 0, pos_y * 0.0001 ) + ( pickup_count - 1 ) * 0.4
	
EntityRemoveTag( entity_id, "homing_target" )
EntityRemoveTag( entity_id, "enemy" )

edit_component( entity_id, "DamageModelComponent", function(comp,vars)
	local hp = tonumber(ComponentGetValue( comp, "hp"))
	vars.max_hp = hp + extra_hp
	vars.hp = hp + extra_hp
end)

edit_component( entity_id, "AnimalAIComponent", function(comp,vars)
	local damage_min = tonumber(ComponentGetValue( comp, "attack_melee_damage_min"))
	local damage_max = tonumber(ComponentGetValue( comp, "attack_melee_damage_max"))
	local damage_dash = tonumber(ComponentGetValue( comp, "attack_dash_damage"))
	
	vars.attack_melee_damage_min = damage_min + extra_damage
	vars.attack_melee_damage_max = damage_max + extra_damage
	vars.attack_dash_damage = damage_dash + extra_damage
end)