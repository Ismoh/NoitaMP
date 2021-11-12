dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, item_name )
	-- fetch perk info ---------------------------------------------------

	local pos_x, pos_y = EntityGetTransform( entity_item )
		
	local cid = EntityLoad( "data/entities/misc/greed_curse/greed.xml", pos_x, pos_y )
	EntityAddComponent( cid, "UIIconComponent", 
	{ 
		name = "$log_curse",
		description = "$itemdesc_essence_greed",
		icon_sprite_file = "data/ui_gfx/status_indicators/greed_curse.png"
	})
	EntityAddChild( entity_who_picked, cid )
	
	--EntityLoad( "data/entities/misc/greed_curse/greed_ghost_portal.xml", pos_x, pos_y - 64 )
	EntityLoad( "data/entities/buildings/teleport_start.xml", pos_x, pos_y - 66 )
	--EntityLoad( "data/entities/misc/greed_curse/greed_crystal.xml", pos_x - 48, pos_y - 24 )
	
	GameAddFlagRun( "greed_curse" )
	AddFlagPersistent( "greed_curse_picked" )

	-- cosmetic fx -------------------------------------------------------

	EntityLoad( "data/entities/particles/image_emitters/perk_effect.xml", pos_x, pos_y )
	GamePrintImportant( "$log_curse", "$logdesc_greed_curse" )
	
	EntityKill( entity_item )
end