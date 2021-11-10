---  This is more of a gameplay related function... but ... 

function electricity_receiver_switched( on )
	-- print("electricity_receiver_switched")

	if( on ) then
		local entity_id = GetUpdatedEntityID()
		local x, y = EntityGetTransform( entity_id )
		local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
		
		-- NOTE: currently supports only spawning a single entity from entity_file.
		-- Move EntityLoad() inside loop if multiple are needed
		local target_entity = ""
		local offset_x = 0
		local offset_y = 0

		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "entity_file") then
				target_entity = ComponentGetValue( comp_id, "value_string" )
			end
			
			if( var_name == "offset_x") then
				offset_x = tonumber(ComponentGetValueInt( comp_id, "value_int" ))
			end
			
			if( var_name == "offset_y") then
				offset_y = tonumber(ComponentGetValueInt( comp_id, "value_int" ))
			end
			
			if( var_name == "enable_component") then
				local target_component = ComponentGetValue( comp_id, "value_string" )
				EntitySetComponentsWithTagEnabled( entity_id, target_component, true )
			end
		end
		
		if (string.len(target_entity) > 0) then
			EntityLoad( target_entity, x + offset_x, y + offset_y )
		end
	end

end

function trigger_trap( trap_id, trap_x, trap_y )
	--print( "trap triggered")
	local components = EntityGetComponent( trap_id, "VariableStorageComponent" )


	for key,comp_id in pairs(components) do 
		--print("VariableStorageComponent")
		local var_name = ComponentGetValue( comp_id, "name" )
		if( var_name == "entity_file") then
			local load_me = ComponentGetValue( comp_id, "value_string" )
			EntityLoad( load_me, trap_x, trap_y )
		end
		
	end

	EntityLoad( "data/entities/misc/music_energy_100_10s.xml", trap_x, trap_y )

	EntityKill( trap_id )
end

function trigger_wand_pickup_trap( x, y )
	-- print( x )
	-- print( y )
	--print("pickup triggered")
	local entities = EntityGetWithTag( "wand_trap" )
	if( #entities == 0 ) then
		return
	end

	for key,entity_id in pairs(entities) do
		local trap_x, trap_y = EntityGetTransform( entity_id )
		if( ( ( y - trap_y ) < 128 ) and math.abs( x - trap_x ) < 180 ) then
			trigger_trap( entity_id, trap_x, trap_y )
		end
	end

end