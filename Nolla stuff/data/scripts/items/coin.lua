dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	print( "COIN" ) 
	
	local wallet = EntityGetComponent( entity_who_picked, "WalletComponent" )

	if( wallet ~= nil ) then
		for i,v in ipairs(wallet) do
			money = tonumber( ComponentGetValue( v, "money" ) )
			money = money + 1
			GamePrint( money )
			ComponentSetValue( v, "money", money)
		end
	end

	-- remove the item from the game
	EntityKill( entity_item )
end
