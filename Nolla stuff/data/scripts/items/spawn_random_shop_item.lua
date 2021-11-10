-- dofile_once("data/scripts/lib/utilities.lua")
-- dofile( "data/scripts/gun/gun_actions.lua" )
dofile_once( "data/scripts/items/generate_shop_item.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
SetRandomSeed( x, y )

if( Random( 1, 100 ) <= 90 ) then
	generate_shop_item( x, y, false )
	--EntityLoad( "data/entities/items/shop_card_creator.xml", x, y )
else
	if( Random( 1, 100 ) <= 25 ) then -- used to be 50
		---
		--[[if( Random( 1, 100 ) <= 50 ) then		
			EntityLoad( "data/entities/items/shop_potion.xml", x, y )
		else
			EntityLoad( "data/entities/items/shop_cape.xml", x, y )
		end]]--
		EntityLoad( "data/entities/items/shop_potion.xml", x, y )

	else
		---
		EntityLoad( "data/entities/items/shop_wand_level_01.xml", x, y )
	end
end