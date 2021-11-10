dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent", "teleport_closer" )

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		
		if ( n == "origin_x" ) then
			ComponentSetValue2( v, "value_float", pos_x )
		elseif ( n == "origin_y" ) then
			ComponentSetValue2( v, "value_float", pos_y )
		end
	end
end