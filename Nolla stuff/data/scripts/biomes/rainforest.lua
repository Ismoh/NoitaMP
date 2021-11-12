-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 4
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")
dofile_once("data/scripts/biomes/summon_portal_util.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff400000, "spawn_scavengers" )
RegisterSpawnFunction( 0xff400080, "spawn_large_enemies" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff943030, "spawn_dragonspot" )
RegisterSpawnFunction( 0xff4c63e0, "spawn_root_grower" )
RegisterSpawnFunction( 0xff806326, "spawn_tree" )

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 2,
		max_count	= 4,    
		entity 	= "data/entities/animals/rainforest/fly.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki_longleg.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/rainforest/shooterflower.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/scavenger_poison.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/scavenger_clusterbomb.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/bloom.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/shaman.xml"
	},
	{
		prob   		= 0.06,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/wizard_twitchy.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= 
		{
			"data/entities/animals/rainforest/scavenger_smg.xml",
			"data/entities/animals/rainforest/scavenger_grenade.xml",
			"data/entities/animals/rainforest/coward.xml",
		},
	},
}


------------ BIG ENEMIES ------------------------------------------------------

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.6,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/rainforest/fungus.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki_longleg.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/bloom.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/scavenger_mine.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= 
		{
			"data/entities/animals/rainforest/scavenger_poison.xml",
			"data/entities/animals/rainforest/scavenger_clusterbomb.xml",
		},
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= 
		{
			"data/entities/animals/rainforest/scavenger_poison.xml",
			"data/entities/animals/rainforest/scavenger_clusterbomb.xml",
			"data/entities/animals/rainforest/scavenger_heal.xml",
		},
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/shooterflower.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/spearbot.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_hearty.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,
		ngpluslevel	= 1,
		entities 	= 
		{
			"data/entities/animals/rainforest/scavenger_poison.xml",
			"data/entities/animals/rainforest/scavenger_clusterbomb.xml",
			"data/entities/animals/rainforest/scavenger_leader.xml",
			"data/entities/animals/rainforest/coward.xml",
		},
	},
}

g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/physics_cocoon.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/shooterflower.xml"
	},
}

g_unique_enemy2 =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/lukki_eggs.xml"
	},
}

------------ ITEMS ------------------------------------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_04.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_05.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_02.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_03.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_04_better.xml"
	},
}

------------ MISC --------------------------------------

g_nest =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/flynest.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/spidernest.xml"
	},
}

------------------- Other animals --------------------------

g_large_enemies =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/shooterflower.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/rainforest/fungus.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/rainforest/bloom.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki_longleg.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lukki/lukki.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			{
				min_count	= 1,
				max_count	= 2,
				entity = "data/entities/animals/rainforest/scavenger_clusterbomb.xml",
			},
			{
				min_count	= 1,
				max_count	= 2,
				entity = "data/entities/animals/rainforest/scavenger_poison.xml",
			},
			"data/entities/animals/rainforest/scavenger_leader.xml",
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
}

g_scavengers =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entities 	=  
		{
			"data/entities/animals/rainforest/scavenger_smg.xml",
			"data/entities/animals/rainforest/scavenger_grenade.xml"
		}
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/flamer.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/sniper.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/scavenger_leader.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rainforest/scavenger_mine.xml"
	},
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,  
		offset_y 	= -2,
		entity 	= "data/entities/props/physics_seamine.xml"
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_torch_stand.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/projectiles/mine.xml"
	},
}

g_lamp2 =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_tubelamp.xml"
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/pit01.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/pit02.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/pit03.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/rainforest/oiltank_01.png",
		visual_file		= "data/biome_impl/rainforest/oiltank_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/hut01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/hut01_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/hut02.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/rainforest/base.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/hut03.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/rainforest/symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_04 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife2_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife3_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife4_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife5_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife6_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife7_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife8_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife9_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife10_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife11_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/rainforest/plantlife.png",
		visual_file		= "",
		background_file	= "data/biome_impl/rainforest/plantlife12_background.png",
		is_unique		= 0
	},
}

g_ghostlamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		offset_y	= 10,
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

g_candles =
{
	total_prob = 0,
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_1.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_2.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_3.xml"
	},
}

g_vines =
{
	total_prob = 0,
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_long.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
	},
	{
		prob   		= 3.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/root/hanging_root_random.xml"
	},
}

g_trees =
{
	total_prob = 0,
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_x	= -10,
		offset_y	= -113,
		entity 	= "data/entities/props/rainforest_tree_01.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -4,
		offset_y	= -30,
		]]--
		entity 	= "data/entities/props/rainforest_tree_02.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -7,
		offset_y	= -32,
		]]--
		entity 	= "data/entities/props/rainforest_tree_03.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -31,
		offset_y	= -93,
		]]--
		entity 	= "data/entities/props/rainforest_tree_04.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -24,
		offset_y	= -84,
		]]--
		entity 	= "data/entities/props/rainforest_tree_05.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -3,
		offset_y	= -84,
		]]--
		entity 	= "data/entities/props/rainforest_tree_06.xml"
	},
}

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	local function is_inside_tile(pos_x, pos_y)
		return pos_x >= x and pos_x <= x+w 
		and pos_y >= y and pos_y <= y+h
	end
	-- portal summoning position & hint statues related to it
	-- NOTE: make sure the coordinates match with summon_portal_util.lua
	local biome_x_min = -2450
	local biome_x_max = 1900
	local biome_y_min = 6700
	local biome_y_max = 8000
	local rim = 200 -- hint statues spawn on rim, portal target inside rim

	local portal_x, portal_y = get_portal_position()

	-- portal target
	if is_inside_tile(portal_x, portal_y) then
		-- spawn
		--print("spawned portal target at " .. portal_x .. ", " .. portal_y)
		EntityLoad( "data/entities/misc/summon_portal_target.xml", portal_x, portal_y )
		-- add some empty for the return teleporter target
		LoadPixelScene( "data/biome_impl/hole.png", "", portal_x-22, portal_y-22, "", true )
	end

	local function spawn_statue(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y)
		-- if floating, set statue against ground
		-- NOTE: not 100& bug proof since this may slip into an area that isn't loaded yet
		local _,x1,y1 = RaytracePlatforms(spawn_x, spawn_y, spawn_x + ray_dir_x * 100, spawn_y + ray_dir_y * 100)

		-- offset a bit deeper in ground
		x1 = x1 + ray_dir_x * 20
		y1 = y1 + ray_dir_y * 12

		-- spawn
		LoadPixelScene( "data/biome_impl/rainforest/rainforest_statue_0"..statue_num..".png", "data/biome_impl/rainforest/rainforest_statue_0"..statue_num.."_visual.png", x1, y1, "", true )
		--print("spawned statue "..statue_num.." at " .. x1 .. ", " .. y1)
	end
	
	-- spawn hint statues on rim. 1 on each side of biome, pointing with staff to portal spawn position
	-- statue 1, left
	local pos_x = ProceduralRandomi(87,-254,biome_x_min,biome_x_min + rim)
	local pos_y = portal_y - 38 -- offset to match staff position in pixel scene
	if is_inside_tile(pos_x, pos_y) then spawn_statue(1, pos_x, pos_y, -1, 0) end
	-- statue 1, right
	pos_x = ProceduralRandomi(8,-5,biome_x_max - rim,biome_x_max)
	if is_inside_tile(pos_x, pos_y) then spawn_statue(1, pos_x, pos_y, 1, 0) end
	
	-- statue 2, top
	pos_x = portal_x - 13
	pos_y = ProceduralRandomi(1999,7,biome_y_min,biome_y_min + rim)
	if is_inside_tile(pos_x, pos_y) then spawn_statue(2, pos_x, pos_y, 0, 1) end
	-- statue 2, bottom
	pos_y = ProceduralRandomi(-415,40,biome_y_max - rim,biome_y_max)
	if is_inside_tile(pos_x, pos_y) then spawn_statue(2, pos_x, pos_y, 0, 1) end
end

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
	-- spawn_hp_mult(g_small_enemies,x,y,0,0,2,"rainforest")
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,2,"rainforest")
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y+12)
	-- spawn_hp_mult(g_unique_enemy,x,y,0,0,2,"rainforest")
end

function spawn_unique_enemy2(x, y)
	spawn(g_unique_enemy2,x,y)
	-- spawn_hp_mult(g_unique_enemy,x,y,0,0,2,"rainforest")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.27) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-10, y-17, "", true )
	end
end

function spawn_nest(x, y)
	spawn(g_nest,x,y)
end

function spawn_props(x, y)
	spawn(g_props,x,y)
end

function spawn_scavengers(x, y)
	spawn(g_scavengers,x,y)
	-- spawn_hp_mult(g_scavengers,x,y,0,0,2,"rainforest")
end

function spawn_large_enemies(x, y)
	spawn(g_large_enemies,x,y)

	-- spawn_hp_mult(g_large_enemies,x,y,0,0,2,"rainforest")
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y-10)
end

function spawn_lamp2(x, y)
	spawn(g_lamp2,x-8,y-4,0,0)
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x, y )
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x, y )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
	-- chance for an extra spawn for denser vineage
	if ProceduralRandomf(x, y) < 0.5 then
		spawn(g_vines,x,y+5)
	end
end

function spawn_dragonspot(x, y)
	EntityLoad( "data/entities/buildings/dragonspot.xml", x, y )
end

function spawn_tree(x, y)
	spawn(g_trees,x+5,y+5)
end

function spawn_root_grower(x, y)
	if ProceduralRandom(x, y) < 0.5 then return end
	EntityLoad( "data/entities/props/root_grower.xml", x+5, y+5 )
end
