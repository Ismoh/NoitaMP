function init_potion( entity_id, potion_material )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed

	-- load the material from VariableStorageComponent
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "potion_material") then
				potion_material = ComponentGetValue( comp_id, "value_string" )
			end
		end
	end
	
	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
	if ( total_capacity > 1000 ) then
		local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
			
		if ( comp ~= nil ) then
			ComponentSetValue( comp, "barrel_size", total_capacity )
		end
		
		EntityAddTag( entity_id, "extra_potion_capacity" )
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
end
