dofile_once("data/scripts/lib/utilities.lua")

function runestone_activate( entity_id, forcestatus )
	local status = forcestatus or 0
	
	local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( variablestorages ~= nil ) then
		for j,storage_id in ipairs(variablestorages) do
			local var_name = ComponentGetValue( storage_id, "name" )
			if ( var_name == "active" ) then
				if ( forcestatus == nil ) then
					status = ComponentGetValue2( storage_id, "value_int" )
					
					status = 1 - status
				end
				
				ComponentSetValue2( storage_id, "value_int", status )
				
				if ( status == 1 ) then
					EntitySetComponentsWithTagEnabled( entity_id, "activate", true )
				else
					EntitySetComponentsWithTagEnabled( entity_id, "activate", false )
				end
			end
		end
	end
end

function kick()
	local entity_id    = GetUpdatedEntityID()
	
	runestone_activate( entity_id )
end

function throw_item()
	local entity_id    = GetUpdatedEntityID()
	
	runestone_activate( entity_id, 1 )
end

function item_pickup( entity_id )
	runestone_activate( entity_id, 0 )
end