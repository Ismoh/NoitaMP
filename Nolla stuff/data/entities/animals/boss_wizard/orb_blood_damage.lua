dofile_once("data/scripts/lib/utilities.lua")

function damage_received( dmg, msg, source )
	local entity_id = GetUpdatedEntityID()
	local root_id = EntityGetRootEntity( entity_id )
	local x,y = EntityGetTransform( root_id )
	
	if ( source ~= nil ) and ( source ~= NULL_ENTITY ) and ( source ~= entity_id ) and ( source ~= root_id ) then
		local hm = EntityGetTransform( source )
		
		if ( hm ~= nil ) then
			EntityInflictDamage( source, dmg, "DAMAGE_CURSE", "$damage_orb_blood", "DISINTEGRATED", 0, 0, entity_id )
		end
	else
		--[[
		local pls = EntityGetInRadiusWithTag( x, y, 160, "player_unit" )
		if ( #pls > 0 ) then
			local pl = pls[1]
			
			EntityInflictDamage( pl, dmg, "DAMAGE_CURSE", "$damage_orb_blood", "DISINTEGRATED", 0, 0, entity_id )
		end
		]]--
	end
	
	local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if ( comp ~= nil ) then
		local max_hp = ComponentGetValue2( comp, "max_hp" )
		ComponentSetValue2( comp, "hp", max_hp )
	end
end