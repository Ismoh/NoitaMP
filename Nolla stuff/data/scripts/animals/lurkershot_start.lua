dofile_once("data/scripts/lib/utilities.lua")

function shot( proj_id )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	EntitySetComponentsWithTagEnabled( entity_id, "lurker_data", false )
	
	local comp = EntityGetFirstComponent( proj_id, "VariableStorageComponent", "lurkershot_id" )
	if ( comp ~= nil ) then
		ComponentSetValue2( comp, "value_int", entity_id )
	end
end