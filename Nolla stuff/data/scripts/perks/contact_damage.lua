dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local root_id    = EntityGetRootEntity( entity_id )
local pos_x, pos_y = EntityGetTransform( entity_id )

if ( entity_id ~= root_id ) then
	local comp = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	local comp2 = EntityGetFirstComponent( entity_id, "AreaDamageComponent" )
	
	if ( comp ~= nil ) and ( comp2 ~= nil ) then
		local hp = ComponentGetValue2( comp, "hp" )
		local max_hp = ComponentGetValue2( comp, "max_hp" )
		
		local multiplier = 1 - ( hp / max_hp )
		local damage = 0.04 + 0.15 * multiplier
		
		ComponentSetValue2( comp2, "damage_per_frame", damage )
	end
end
