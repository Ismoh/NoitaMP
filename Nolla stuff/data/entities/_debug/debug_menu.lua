dofile( "data/scripts/lib/coroutines.lua" )
dofile( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/perks/perk.lua" )
dofile( "data/scripts/streaming_integration/event_list.lua" )
dofile( "data/scripts/biome_modifiers.lua" )
dofile( "data/scripts/magic/fungal_shift.lua" )
dofile_once("data/scripts/streaming_integration/event_utilities.lua" )

local gui_frame_fn = nil
local gui = GuiCreate()
local main_menu_items = {}
local destroy = false
local menu_pos_x = 2
local menu_pos_y = 13


function reload_dofile( filename )
	__loaded[filename] = nil -- invalidate cache entry
	dofile( filename )
end

function gui_do_return_button()
	if GuiButton( gui, 0, 0, "Return", 9999999 ) then
		gui_frame_fn = gui_fn_main
	end
end

function gui_do_close_button()
	if GuiButton( gui, 0, 0, "Close", 99999991 ) then
		destroy = true
	end
end

function gui_do_button_list( actions, fn_get_name_from_action, fn_action_clicked )
	local num_actions = #actions
	local hax_btn_id = 123

	local gui_event_button = function( i )
		local name = GameTextGetTranslatedOrNot( fn_get_name_from_action(actions[i]) )
		name = name:sub(0,19)
		if GuiButton( gui, 0, 0, name, hax_btn_id+i ) then
			fn_action_clicked( actions[i] )
		end
	end

	-- column 1
	local items_per_column = 28

	GuiLayoutBeginVertical( gui, 22, 13 )
	local starti = 1
	local endi = items_per_column

	for i=starti,endi do
		if i > num_actions then 
			break 
		end

		gui_event_button( i )
	end
	GuiLayoutEnd( gui )

	-- column 2
	GuiLayoutBeginVertical( gui, 40, 13 )
	starti = endi+1
	endi = endi+items_per_column
	for i=starti,endi do
		if i > num_actions then 
			break 
		end

		gui_event_button( i )
	end
	GuiLayoutEnd( gui )

	-- column 3
	GuiLayoutBeginVertical( gui, 58, 13 )
	starti = endi+1
	endi = endi+items_per_column
	for i=starti,endi do
		if i > num_actions then 
			break 
		end

		gui_event_button( i )
	end
	GuiLayoutEnd( gui )

	-- column 4
	GuiLayoutBeginVertical( gui, 76, 13 )
	starti = endi+1
	endi = endi+items_per_column
	for i=starti,endi do
		if i > num_actions then 
			break 
		end

		gui_event_button( i )
	end
	GuiLayoutEnd( gui )
end

function gui_fn_main()
	local hax_btn_id = 123
	
	GuiLayoutBeginVertical( gui, menu_pos_x, menu_pos_y )
	GuiText( gui, 0, 0, "== DEBUG MENU ==" )
	GuiText( gui, 0, 0, "Current biome: " .. DebugBiomeMapGetFilename() )
	GuiText( gui, 0, 0, "---")
	for i,it in ipairs(main_menu_items) do
		if GuiButton( gui, 0, 0, it.ui_name, hax_btn_id ) then
			it.action()
		end
		hax_btn_id = hax_btn_id + 1
	end

	GuiLayoutEnd( gui )
end

function gui_fn_spawn_perk()
	GuiLayoutBeginVertical( gui, menu_pos_x, menu_pos_y )
	GuiText( gui, 0,0, "== Select a perk to spawn ==" )
	GuiText( gui, 0,0, tostring(#perk_list) .. " perks" )
	gui_do_return_button()
	GuiLayoutEnd( gui)

	gui_do_button_list( 
		perk_list, 
		function(item) return item.id end,
		function(item)
			GamePrint( "DEBUG - attempting to spawn " .. item.id .. " at player location" )
			local x, y = GameGetCameraPos()
			local player_entity = EntityGetClosestWithTag( x, y, "player_unit")
			if( player_entity ~= 0 ) then
				x, y = EntityGetTransform( player_entity )
			end
			perk_spawn( x, y - 8, item.id )
		end
	)

end
	
function gui_fn_spawn_streaming_event()
	local run_this_item = nil

	GuiLayoutBeginVertical( gui, menu_pos_x, menu_pos_y )
	GuiText( gui, 0,0, "== Select an event to run ==" )
	if GuiButton( gui, 0, 0, "Reload event_list.lua", 99999999 ) then
		reload_dofile( "data/scripts/streaming_integration/event_list.lua" )
	end

	if GuiButton( gui, 0, 0, "Run all events", 99999998 ) then
		async(function()
			for _,it in ipairs(streaming_events) do
				GamePrint("Running " .. it.ui_name)
				if ( it.action_delayed ~= nil ) then
					if it.delay_timer ~= nil then
						local p = get_players()
						
						if ( #p > 0 ) then
							for a,b in ipairs( p ) do
								add_timer_above_head( b, it.id, it.delay_timer )
							end
						end
					end
					
					wait(10)
				elseif ( it.action ~= nil ) then
					it.action(it)
					wait(10)
				end
			end
		end)
	end

	gui_do_return_button()
	GuiLayoutEnd( gui )

	gui_do_button_list( 
		streaming_events, 
		function(item) return item.ui_name end,
		function(item) run_this_item = item end
	)

	-- reload, run
	if run_this_item ~= nil then
		dofile( "data/scripts/streaming_integration/event_list.lua")
		
		if ( run_this_item.action_delayed ~= nil ) then
			if run_this_item.delay_timer ~= nil then
				local p = get_players()
				
				if ( #p > 0 ) then
					for a,b in ipairs( p ) do
						add_timer_above_head( b, run_this_item.id, run_this_item.delay_timer )
					end
				end
			end
		elseif ( run_this_item.action ~= nil ) then
			run_this_item.action(run_this_item)
		end
	end
end
	
function gui_fn_teleport_to_location()
	local locations = {
		{ui_name = "Starting area", 	x=227, y=-100, },
		{ui_name = "1st Holy Mountain", x=-380, y=1380, },
		{ui_name = "Pyramid", 			x=8900, y=-320, },
		{ui_name = "Frozen vault", 		x=-10000, y=360, },
		{ui_name = "Orb - lava lake", 	x=4354, y=763, },
		{ui_name = "Floating island", 	x=774, y=-1197, },
		{ui_name = "Lake", 				x=-14000, y=140, },
		{ui_name = "---" },
		{ui_name = "excavationsite", 	x=190, y=1500, },
		{ui_name = "snowcave", 			x=190, y=3000, },
		{ui_name = "snowcastle", 		x=190, y=5000, },
		{ui_name = "rainforest", 		x=190, y=6500, },
		{ui_name = "vault", 			x=190, y=8500, },
		{ui_name = "crypt", 			x=190, y=10700, },
		{ui_name = "boss", 				x=3500, y=13060, },
		{ui_name = "---" },
		{ui_name = "wandcave",	 		x=-2600, y=3730, },
		{ui_name = "lukki lair", 		x=-3665, y=7823, },
		{ui_name = "wizard den", 		x=9706, y=12603, },
		{ui_name = "overgrown cavern", 	x=13188, y=4286, },
		{ui_name = "power plant", 		x=12350, y=8170, },
		{ui_name = "---" },
		{ui_name = "ancient laboratory", x=-3150, y=860, },
		{ui_name = "dark altar", 		x=3840, y=15590, },
		{ui_name = "ending #1", 		x=6241, y=15130, },
		{ui_name = "---" },
		{ui_name ="orb 2", 				x=-10010, y=2827, },
		{ui_name ="orb 4", 				x=9955, y=2819, },
		{ui_name ="orb 5", 				x=-4375, y=3867, },
		{ui_name ="orb 6", 				x=-4859, y=8973, },
		{ui_name ="orb 7", 				x=4343, y=814, },
		{ui_name ="orb 8", 				x=-255, y=16147, },
		{ui_name ="orb 9", 				x=-8957, y=14609, },
		{ui_name ="orb 10", 			x=10476, y=16148, },

		-- #pyramid
		-- 1, floating island
		-- 3, Nuke 

	}

	GuiLayoutBeginVertical( gui, 2, 11 )
	GuiText( gui, 0,0, "== Select location ==" )
	gui_do_return_button()
	GuiLayoutEnd( gui )

	gui_do_button_list( 
		locations, 
		function(item) return item.ui_name end,
		function(item)
			local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")
			if player_entity ~= 0 and item.x ~= nil then
				EntitySetTransform( player_entity, item.x, item.y )
			else
				GameSetCameraPos( item.x, item.y )
				-- GamePrint("Can't teleport - player doesn't exist")
			end
		end
	)
end
	
function gui_fn_biome_modifiers()
	GuiLayoutBeginVertical( gui, 2, 11 )
	GuiText( gui, 0,0, "== Select modifier ==" )
	gui_do_return_button()
	GuiLayoutEnd( gui )

	if biome_modifiers == nil then
		return
	end
	gui_do_button_list( 
		biome_modifiers, 
		function(item) return item.ui_description end,
		function(item)
			apply_modifier_to_all_biomes( item.id )
		end
	)
end


main_menu_items = 
{
	{
		ui_name="Spawn perk",
		action = function() gui_frame_fn = gui_fn_spawn_perk end
	},
	{
		ui_name="Spawn streaming integration event",
		action = function() gui_frame_fn = gui_fn_spawn_streaming_event end,
	},
	{
		ui_name="Teleport player to location",
		action = function() gui_frame_fn = gui_fn_teleport_to_location end,
	},
	{
		ui_name="Apply biome modifier to all biomes",
		action = function() gui_frame_fn = gui_fn_biome_modifiers end,
	},
	{
		ui_name="Fade out music",
		action = function() GameTriggerMusicFadeOutAndDequeueAll(10) end,
	},
	{
		ui_name="Spawn sampo",
		action = function() 
			local x,y = DEBUG_GetMouseWorld()
			local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")
			if player_entity ~= 0 then
				x, y = EntityGetTransform( player_entity )
			end
			EntityLoad( "data/entities/animals/boss_centipede/sampo.xml", x, y ) 
		end,
	},
	{
		ui_name="Spawn all emerald tablets",
		action = function() 
			local spacing = 20
			local x,y = DEBUG_GetMouseWorld()
			EntityLoad( "data/entities/items/books/book_00.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_01.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_02.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_03.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_04.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_05.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_06.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_07.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_08.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_10.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_corpse.xml", x,y ) x=x+spacing
			EntityLoad( "data/entities/items/books/book_tree.xml", x,y ) x=x+spacing
		end,
	},
	--[[
	{
		-- this creates good chaos for testing things
		ui_name="Spawn all enemies and wands",
		action = function() 
			local spacing = 20
			local x,y = DEBUG_GetMouseWorld()
			local all_enemies = {"data/entities/animals/acidshooter.xml","data/entities/animals/acidshooter_weak.xml","data/entities/animals/alchemist.xml","data/entities/animals/ant.xml","data/entities/animals/assassin.xml","data/entities/animals/barfer.xml","data/entities/animals/bat.xml","data/entities/animals/bigbat.xml","data/entities/animals/bigfirebug.xml","data/entities/animals/bigzombie.xml","data/entities/animals/bigzombiehead.xml","data/entities/animals/bigzombietorso.xml","data/entities/animals/blob.xml","data/entities/animals/bloodcrystal_physics.xml","data/entities/animals/bloom.xml","data/entities/animals/boss_dragon.xml","data/entities/animals/chest_leggy.xml","data/entities/animals/chest_mimic.xml","data/entities/animals/coward.xml","data/entities/animals/crystal_physics.xml","data/entities/animals/darkghost.xml","data/entities/animals/deer.xml","data/entities/animals/drone.xml","data/entities/animals/drone_lasership.xml","data/entities/animals/drone_physics.xml","data/entities/animals/drone_shield.xml","data/entities/animals/duck.xml","data/entities/animals/eel.xml","data/entities/animals/elk.xml","data/entities/animals/enlightened_alchemist.xml","data/entities/animals/ethereal_being.xml","data/entities/animals/failed_alchemist.xml","data/entities/animals/failed_alchemist_b.xml","data/entities/animals/firebug.xml","data/entities/animals/firemage.xml","data/entities/animals/firemage_weak.xml","data/entities/animals/fireskull.xml","data/entities/animals/fireskull_weak.xml","data/entities/animals/fish.xml","data/entities/animals/fish_large.xml","data/entities/animals/flamer.xml","data/entities/animals/fly.xml","data/entities/animals/frog.xml","data/entities/animals/frog_big.xml","data/entities/animals/fungus.xml","data/entities/animals/fungus_big.xml","data/entities/animals/gazer.xml","data/entities/animals/ghost.xml","data/entities/animals/ghoul.xml","data/entities/animals/giant.xml","data/entities/animals/giantshooter.xml","data/entities/animals/giantshooter_weak.xml","data/entities/animals/goblin_bomb.xml","data/entities/animals/healerdrone_physics.xml","data/entities/animals/icer.xml","data/entities/animals/iceskull.xml","data/entities/animals/lasershooter.xml","data/entities/animals/longleg.xml","data/entities/animals/lurker.xml","data/entities/animals/maggot.xml","data/entities/animals/mimic_physics.xml","data/entities/animals/miner.xml","data/entities/animals/miner_fire.xml","data/entities/animals/miner_santa.xml","data/entities/animals/miner_weak.xml","data/entities/animals/miniblob.xml","data/entities/animals/missilecrab.xml","data/entities/animals/monk.xml","data/entities/animals/necromancer.xml","data/entities/animals/necromancer_shop.xml","data/entities/animals/necromancer_super.xml","data/entities/animals/pebble_physics.xml","data/entities/animals/phantom_a.xml","data/entities/animals/phantom_b.xml","data/entities/animals/playerghost.xml","data/entities/animals/playerghost_nodrop.xml","data/entities/animals/rat.xml","data/entities/animals/roboguard.xml","data/entities/animals/scavenger_clusterbomb.xml","data/entities/animals/scavenger_grenade.xml","data/entities/animals/scavenger_heal.xml","data/entities/animals/scavenger_invis.xml","data/entities/animals/scavenger_leader.xml","data/entities/animals/scavenger_mine.xml","data/entities/animals/scavenger_poison.xml","data/entities/animals/scavenger_shield.xml","data/entities/animals/scavenger_smg.xml","data/entities/animals/scorpion.xml","data/entities/animals/shaman.xml","data/entities/animals/sheep.xml","data/entities/animals/sheep_bat.xml","data/entities/animals/sheep_fly.xml","data/entities/animals/shooterflower.xml","data/entities/animals/shotgunner.xml","data/entities/animals/shotgunner_weak.xml","data/entities/animals/skullfly.xml","data/entities/animals/skullrat.xml","data/entities/animals/skycrystal_physics.xml","data/entities/animals/skygazer.xml","data/entities/animals/slimeshooter.xml","data/entities/animals/slimeshooter_nontoxic.xml","data/entities/animals/slimeshooter_weak.xml","data/entities/animals/sniper.xml","data/entities/animals/spearbot.xml","data/entities/animals/spitmonster.xml","data/entities/animals/statue.xml","data/entities/animals/statue_physics.xml","data/entities/animals/tank.xml","data/entities/animals/tank_rocket.xml","data/entities/animals/tank_super.xml","data/entities/animals/tentacler.xml","data/entities/animals/tentacler_small.xml","data/entities/animals/thundermage.xml","data/entities/animals/thundermage_big.xml","data/entities/animals/thunderskull.xml","data/entities/animals/turret_left.xml","data/entities/animals/turret_right.xml","data/entities/animals/ultimate_killer.xml","data/entities/animals/wand_ghost.xml","data/entities/animals/wand_ghost_charmed.xml","data/entities/animals/wizard_dark.xml","data/entities/animals/wizard_hearty.xml","data/entities/animals/wizard_neutral.xml","data/entities/animals/wizard_poly.xml","data/entities/animals/wizard_returner.xml","data/entities/animals/wizard_swapper.xml","data/entities/animals/wizard_tele.xml","data/entities/animals/wizard_twitchy.xml","data/entities/animals/wizard_weaken.xml","data/entities/animals/wizard_homing.xml","data/entities/animals/wolf.xml","data/entities/animals/worm.xml","data/entities/animals/worm_big.xml","data/entities/animals/worm_end.xml","data/entities/animals/worm_skull.xml","data/entities/animals/worm_tiny.xml","data/entities/animals/wraith.xml","data/entities/animals/wraith_glowing.xml","data/entities/animals/wraith_storm.xml","data/entities/animals/zombie.xml","data/entities/animals/zombie_weak.xml",}

			for i,animal in ipairs(all_enemies) do
				EntityLoad( animal, x, y )
				EntityLoad( "data/entities/items/wand_unshuffle_06.xml", x, y )
				x = x + spacing
			end			
		end,
	},
	]]--
	{
		-- this creates good chaos for testing things
		ui_name="Spawn all enemies that hold wands",
		action = function() 
			local spacing = 20
			local x,y = DEBUG_GetMouseWorld()
			local all_enemies = {"data/entities/animals/acidshooter.xml","data/entities/animals/acidshooter_weak.xml","data/entities/animals/alchemist.xml","data/entities/animals/ant.xml","data/entities/animals/assassin.xml","data/entities/animals/barfer.xml","data/entities/animals/bat.xml","data/entities/animals/bigbat.xml","data/entities/animals/bigfirebug.xml","data/entities/animals/bigzombie.xml","data/entities/animals/bigzombiehead.xml","data/entities/animals/bigzombietorso.xml","data/entities/animals/blob.xml","data/entities/animals/bloodcrystal_physics.xml","data/entities/animals/bloom.xml","data/entities/animals/boss_dragon.xml","data/entities/animals/chest_leggy.xml","data/entities/animals/chest_mimic.xml","data/entities/animals/coward.xml","data/entities/animals/crystal_physics.xml","data/entities/animals/darkghost.xml","data/entities/animals/deer.xml","data/entities/animals/drone.xml","data/entities/animals/drone_lasership.xml","data/entities/animals/drone_physics.xml","data/entities/animals/drone_shield.xml","data/entities/animals/duck.xml","data/entities/animals/eel.xml","data/entities/animals/elk.xml","data/entities/animals/enlightened_alchemist.xml","data/entities/animals/ethereal_being.xml","data/entities/animals/failed_alchemist.xml","data/entities/animals/failed_alchemist_b.xml","data/entities/animals/firebug.xml","data/entities/animals/firemage.xml","data/entities/animals/firemage_weak.xml","data/entities/animals/fireskull.xml","data/entities/animals/fireskull_weak.xml","data/entities/animals/fish.xml","data/entities/animals/fish_large.xml","data/entities/animals/flamer.xml","data/entities/animals/fly.xml","data/entities/animals/frog.xml","data/entities/animals/frog_big.xml","data/entities/animals/fungus.xml","data/entities/animals/fungus_big.xml","data/entities/animals/gazer.xml","data/entities/animals/ghost.xml","data/entities/animals/ghoul.xml","data/entities/animals/giant.xml","data/entities/animals/giantshooter.xml","data/entities/animals/giantshooter_weak.xml","data/entities/animals/goblin_bomb.xml","data/entities/animals/healerdrone_physics.xml","data/entities/animals/icer.xml","data/entities/animals/iceskull.xml","data/entities/animals/lasershooter.xml","data/entities/animals/longleg.xml","data/entities/animals/lurker.xml","data/entities/animals/maggot.xml","data/entities/animals/mimic_physics.xml","data/entities/animals/miner.xml","data/entities/animals/miner_fire.xml","data/entities/animals/miner_santa.xml","data/entities/animals/miner_weak.xml","data/entities/animals/miniblob.xml","data/entities/animals/missilecrab.xml","data/entities/animals/monk.xml","data/entities/animals/necromancer.xml","data/entities/animals/necromancer_shop.xml","data/entities/animals/necromancer_super.xml","data/entities/animals/pebble_physics.xml","data/entities/animals/phantom_a.xml","data/entities/animals/phantom_b.xml","data/entities/animals/playerghost.xml","data/entities/animals/playerghost_nodrop.xml","data/entities/animals/rat.xml","data/entities/animals/roboguard.xml","data/entities/animals/scavenger_clusterbomb.xml","data/entities/animals/scavenger_grenade.xml","data/entities/animals/scavenger_heal.xml","data/entities/animals/scavenger_invis.xml","data/entities/animals/scavenger_leader.xml","data/entities/animals/scavenger_mine.xml","data/entities/animals/scavenger_poison.xml","data/entities/animals/scavenger_shield.xml","data/entities/animals/scavenger_smg.xml","data/entities/animals/scorpion.xml","data/entities/animals/shaman.xml","data/entities/animals/sheep.xml","data/entities/animals/sheep_bat.xml","data/entities/animals/sheep_fly.xml","data/entities/animals/shooterflower.xml","data/entities/animals/shotgunner.xml","data/entities/animals/shotgunner_weak.xml","data/entities/animals/skullfly.xml","data/entities/animals/skullrat.xml","data/entities/animals/skycrystal_physics.xml","data/entities/animals/skygazer.xml","data/entities/animals/slimeshooter.xml","data/entities/animals/slimeshooter_nontoxic.xml","data/entities/animals/slimeshooter_weak.xml","data/entities/animals/sniper.xml","data/entities/animals/spearbot.xml","data/entities/animals/spitmonster.xml","data/entities/animals/statue.xml","data/entities/animals/statue_physics.xml","data/entities/animals/tank.xml","data/entities/animals/tank_rocket.xml","data/entities/animals/tank_super.xml","data/entities/animals/tentacler.xml","data/entities/animals/tentacler_small.xml","data/entities/animals/thundermage.xml","data/entities/animals/thundermage_big.xml","data/entities/animals/thunderskull.xml","data/entities/animals/turret_left.xml","data/entities/animals/turret_right.xml","data/entities/animals/ultimate_killer.xml","data/entities/animals/wand_ghost.xml","data/entities/animals/wand_ghost_charmed.xml","data/entities/animals/wizard_dark.xml","data/entities/animals/wizard_hearty.xml","data/entities/animals/wizard_neutral.xml","data/entities/animals/wizard_poly.xml","data/entities/animals/wizard_returner.xml","data/entities/animals/wizard_swapper.xml","data/entities/animals/wizard_tele.xml","data/entities/animals/wizard_twitchy.xml","data/entities/animals/wizard_weaken.xml","data/entities/animals/wizard_homing.xml","data/entities/animals/wolf.xml","data/entities/animals/worm.xml","data/entities/animals/worm_big.xml","data/entities/animals/worm_end.xml","data/entities/animals/worm_skull.xml","data/entities/animals/worm_tiny.xml","data/entities/animals/wraith.xml","data/entities/animals/wraith_glowing.xml","data/entities/animals/wraith_storm.xml","data/entities/animals/zombie.xml","data/entities/animals/zombie_weak.xml",}

			for i,animal in ipairs(all_enemies) do
				local animal_e = EntityLoad( animal, x, y )
				if( EntityGetFirstComponent( animal_e, "ItemPickUpperComponent" ) == nil ) then
					EntityKill( animal_e )
				else
					EntityLoad( "data/entities/items/wand_unshuffle_06.xml", x, y )
					x = x + spacing
				end
			end			
		end,
	},
	{
		ui_name="Fungal shift",
		action = function()
			local x, y = GameGetCameraPos()
			local player_entity = EntityGetClosestWithTag( x, y, "player_unit" )
			if( player_entity ~= 0 ) then
				x, y = EntityGetTransform( player_entity )
			end
			fungal_shift( player_entity, x, y, true )
		end,
	},
	--[[{
		ui_name="Fungal shift lava->water",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "lava" ), CellFactory_GetType( "water" ) )
		end
	},
	{
		ui_name="Fungal shift lava->radioactive_liquid",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "lava" ), CellFactory_GetType( "radioactive_liquid" ) )
		end
	},
	{
		ui_name="Fungal shift water->rock_static",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "rock_static" ) )
		end
	},
	{
		ui_name="Fungal shift radioactive_liquid->magic_liquid_protection_all",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "radioactive_liquid" ), CellFactory_GetType( "magic_liquid_protection_all" ) )
		end
	},
	{
		ui_name="Fungal shift acid->sima",
		action = function()
			print(to_string(CellFactory_GetType( "acid" )))
			ConvertMaterialEverywhere( CellFactory_GetType( "acid" ), CellFactory_GetType( "sima" ) )
		end
	},
	{
		ui_name="Fungal shift acid->blood",
		action = function()
			print(to_string(CellFactory_GetType( "acid" )))
			ConvertMaterialEverywhere( CellFactory_GetType( "acid" ), CellFactory_GetType( "blood" ) )
		end
	},
	{
		ui_name="Fungal shift water->blood",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "blood" ) )
		end
	},
	{
		ui_name="Fungal shift water->oil",
		action = function()
			ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "oil" ) )
		end
	},
	{
		ui_name="Fungal shift #1",
		action = function()
			local x, y = GameGetCameraPos()
			local player_entity = EntityGetClosestWithTag( x, y, "player_unit" )
			local mat = get_held_item_material( player_entity )
			ConvertMaterialEverywhere( mat, CellFactory_GetType( "blood" ) )
		end
	},
	{
		ui_name="Fungal shift #2",
		action = function()
			local x, y = GameGetCameraPos()
			local player_entity = EntityGetClosestWithTag( x, y, "player_unit" )
			local mat = get_held_item_material( player_entity )
			ConvertMaterialEverywhere( mat, CellFactory_GetType( "oil" ) )
		end
	},]]--
	{
		ui_name="ConvertMaterialOnAreaInstantly() - test near camera",
		action = function()
			local x,y = GameGetCameraPos()
			local dim = 128
			local from = CellFactory_GetType( "rock_static" )
			local to = CellFactory_GetType( "wood_prop" )
			ConvertMaterialOnAreaInstantly( x-dim, y-dim, dim*2, dim*2, from, to, true, true )
		end,
	},
	{
		ui_name="Test GameShootProjectile bug",
		action = function()
			local x,y = GameGetCameraPos()
			local e = EntityLoad( "data/entities/items/pickup/goldnugget_200.xml" )
			GameShootProjectile( 0, x, y, 0, 0, e, false )
		end
	},
	{
		ui_name="Test GameCreateBeamFromSky()",
		action = function()
			GameCreateBeamFromSky( 0, 10000, 40, 40 )
		end
	},
	{
		ui_name="Close",
		action = function() destroy = true end,
	},
}

gui_frame_fn = gui_fn_main


async_loop(function()
	if gui ~= nil then
		GuiStartFrame( gui )
	end

	if gui_frame_fn ~= nil then
		gui_frame_fn()
	end
	
	-----
	if destroy then
		GuiDestroy( gui )
		gui_frame_fn = nil
		gui = nil
		EntityKill( GetUpdatedEntityID() )
	end

	wait(0)
end)
