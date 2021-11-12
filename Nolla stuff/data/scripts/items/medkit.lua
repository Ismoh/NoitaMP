dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )

	if( damagemodels ~= nil ) then
		for i,v in ipairs(damagemodels) do
			hp = tonumber( ComponentGetValue( v, "hp" ) )
			max_hp = tonumber( ComponentGetValue( v, "max_hp") )
			hp = hp + 0.25 * 0.6666 * 2
			if( hp > max_hp ) then hp = max_hp end
			ComponentSetValue( v, "hp", hp)
		end
	end
	-- hp, max_hp
	-- remove the item from the game
	EntityKill( entity_item )
end
