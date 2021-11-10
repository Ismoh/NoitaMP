dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_item )
	EntityLoad("data/entities/particles/image_emitters/spell_refresh_effect.xml", x, y-12)
	GamePrintImportant( "$itemtitle_spell_refresh", "$itemdesc_spell_refresh" )
	
	GameRegenItemActionsInPlayer( entity_who_picked )

	-- remove the item from the game
	EntityKill( entity_item )
end
