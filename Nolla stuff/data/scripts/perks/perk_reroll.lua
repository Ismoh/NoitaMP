dofile_once( "data/scripts/perks/perk.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item )
	perk_reroll_perks( entity_item )
	-- spawn a new one
	EntityKill( entity_item )
	EntityLoad( "data/entities/particles/perk_reroll.xml", pos_x, pos_y )
	EntityLoad( "data/entities/items/pickup/perk_reroll.xml", pos_x, pos_y )
end
