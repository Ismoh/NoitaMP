dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_item )

	EntityLoad("data/entities/particles/image_emitters/shop_effect.xml", x, y-8)
end
 