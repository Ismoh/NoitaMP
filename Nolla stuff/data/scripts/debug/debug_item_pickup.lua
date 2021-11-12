dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	print( "ITEM PICKUP" ) 
	
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

	if( damagemodels ~= nil ) then
		for i,v in ipairs(damagemodels) do
			max_hp = tonumber( ComponentGetValue( v, "max_hp" ) )
			max_hp = max_hp + 1
			-- if( hp > max_hp ) then hp = max_hp end
			ComponentSetValue( v, "max_hp", max_hp)
		end
	end
	-- hp, max_hp
	-- remove the item from the game
	EntityKill( entity_item )
end
