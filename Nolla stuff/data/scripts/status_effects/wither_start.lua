dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )
local x, y = EntityGetTransform( entity_id )

if ( player_id ~= NULL_ENTITY ) and ( entity_id ~= player_id ) then
	local comp = EntityGetFirstComponent( player_id, "DamageModelComponent" )
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	
	local resists = { "drill", "electricity", "explosion", "fire", "ice", "melee", "projectile", "radioactive", "slice" }
	local result = ""
	
	if ( comp ~= nil ) and ( comps ~= nil ) then
		for a,b in ipairs( resists ) do
			local r = tostring(ComponentObjectGetValue( comp, "damage_multipliers", b ))
			
			result = result .. r
			
			if ( a < #resists ) then
				result = result .. " "
			end
			
			ComponentObjectSetValue( comp, "damage_multipliers", b, "1.2" )
		end
	
		if ( #result > 0 ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				
				if ( n == "wither_data" ) then
					ComponentSetValue2( v, "value_string", result )
					break
				end
			end
		end
	end
	
	local c = EntityGetAllChildren( player_id )
	
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "effect_resistance" ) then
				EntitySetComponentsWithTagEnabled( v, "effect_resistance", false )
			end
		end
	end
end