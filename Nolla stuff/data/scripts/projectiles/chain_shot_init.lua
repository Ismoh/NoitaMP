dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local iteration = 0

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "chain_shot" ) then
			iteration = ComponentGetValue2( v, "value_int" )
			break
		end
	end
end

if ( iteration == 0 ) then
	iteration = 1
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{ 
		name = "chain_shot",
		value_int = 1,
	} )	
end