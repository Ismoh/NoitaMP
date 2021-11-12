---  This is more of a gameplay related function... but ... 
function trigger_trap( trap_id, trap_x, trap_y )
	print( "trap triggered")
	local components = EntityGetComponent( trap_id, "VariableStorageComponent" )

	for key,comp_id in pairs(components) do 
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