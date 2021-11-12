dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local orbcount = GameGetOrbCountThisRun() + 1
	local value = 8000 * orbcount

	-- looks for end_gold variables
	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )

	if( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "end_gold") then
				local extra_value = ComponentGetValueInt( comp_id, "value_int" )
				if( extra_value ~= nil ) then
					value = extra_value
				end
			end
		end
	end

	GamePrintImportant( "$log_golden_statue", GameTextGet( "$logdesc_golden_statue", tostring(value) ) )
	
	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local money = 0
	
	edit_component( entity_who_picked, "WalletComponent", function(comp,vars)
		money = ComponentGetValueInt( comp, "money")
	end)

	money = money + value
	
	edit_component( entity_who_picked, "WalletComponent", function(comp,vars)
		vars.money = money
	end)
	
	SetRandomSeed( pos_x, pos_y )

	for i=1,20 do
		local x = pos_x + Random(-8, 8)
		local y = pos_y + Random(-20, 2)
		shoot_projectile( entity_item, "data/entities/particles/gold_pickup.xml", x, y, 0, 0 )
	end
	
	EntityKill( entity_item )
end
