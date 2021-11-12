dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "necrobot_entity_file" )

if ( comp ~= nil ) then
	local file = ComponentGetValue2( comp, "value_string" )
	
	if ( file ~= nil ) and ( #file > 0 ) then
		local eid = EntityLoad( file, x, y )
		EntityLoad( "data/entities/particles/poof_green_sparse.xml", x, y )
		EntityAddComponent( eid, "VariableStorageComponent", 
		{ 
			_tags="no_gold_drop",
		} )
	end
end

EntityKill( entity_id )