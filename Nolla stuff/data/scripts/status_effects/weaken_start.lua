dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )
local x, y = EntityGetTransform( entity_id )

if ( player_id ~= NULL_ENTITY ) and ( entity_id ~= player_id ) then
	local c = EntityGetAllChildren( player_id )
	
	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "effect_protection" ) then
				EntitySetComponentsWithTagEnabled( v, "effect_protection", false )
			end
		end
	end
end