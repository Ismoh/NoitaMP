dofile_once( "data/scripts/lib/utilities.lua" )

function damage_received( damage, message, entity_thats_responsible )
	local entity_id = GetUpdatedEntityID()
	local c = EntityGetAllChildren( entity_id )

	if ( c ~= nil ) then
		for i,v in ipairs( c ) do
			if EntityHasTag( v, "boss_ghost_lasers" ) then
				local comp = EntityGetFirstComponent( v, "VariableStorageComponent", "laser_status" )
				
				local status = ComponentGetValue2( comp, "value_float" )
				status = status + 1.0
				ComponentSetValue2( comp, "value_float", status )
			end
		end
	end
end