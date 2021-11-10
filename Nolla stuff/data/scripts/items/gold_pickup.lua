dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local money = 0
	local value = 10
	local hp_value = 0
	
	edit_component( entity_who_picked, "WalletComponent", function(comp,vars)
		money = ComponentGetValueInt( comp, "money")
	end)

	-- load the gold_value from VariableStorageComponent
	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )
	
	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "gold_value") then
				value = ComponentGetValueInt( comp_id, "value_int" )
			end
			if( var_name == "hp_value" ) then
				hp_value = ComponentGetValueFloat( comp_id, "value_float" )
			end
		end
	end

	-- Different FX based on value
	if value > 500 then
		shoot_projectile( entity_item, "data/entities/particles/gold_pickup_huge.xml", pos_x, pos_y, 0, 0 )
	elseif value > 40 then
		shoot_projectile( entity_item, "data/entities/particles/gold_pickup_large.xml", pos_x, pos_y, 0, 0 )
	else
		shoot_projectile( entity_item, "data/entities/particles/gold_pickup.xml", pos_x, pos_y, 0, 0 )
	end

	local extra_money_count = GameGetGameEffectCount( entity_who_picked, "EXTRA_MONEY" )
	if extra_money_count > 0 then
		for i=1,extra_money_count do
			value = value * 2
		end
	end

	money = money + value
	
	edit_component( entity_who_picked, "WalletComponent", function(comp,vars)
		vars.money = money
	end)

	if( hp_value > 0 ) then
		hp_value = hp_value * 0.5
		heal_entity( entity_who_picked, hp_value )
	end

	EntityKill( entity_item )
end