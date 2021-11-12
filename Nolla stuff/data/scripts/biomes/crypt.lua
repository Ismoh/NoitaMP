-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff808000, "spawn_statues" )
RegisterSpawnFunction( 0xff00AC33, "load_pixel_scene3" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xff97ab00, "load_pixel_scene5" )
RegisterSpawnFunction( 0xffc9d959, "load_pixel_scene5b" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )
RegisterSpawnFunction( 0xff400080, "spawn_large_enemies" )
RegisterSpawnFunction( 0xffC8001A, "spawn_ghost_crystal" )
RegisterSpawnFunction( 0xff82FF5A, "spawn_crawlers" )
RegisterSpawnFunction( 0xff647D7D, "spawn_pressureplates" )
RegisterSpawnFunction( 0xff649B7D, "spawn_doors" )
RegisterSpawnFunction( 0xffA07864, "spawn_scavengers" )
RegisterSpawnFunction( 0xffFFCD2A, "spawn_scorpions" ) 
RegisterSpawnFunction( 0xff2D1E5A, "spawn_bones" )
RegisterSpawnFunction( 0xff782060, "load_beam" )
RegisterSpawnFunction( 0xff783060, "load_background_scene" )
RegisterSpawnFunction( 0xff378ec4, "load_small_background_scene" )
RegisterSpawnFunction( 0xff786460, "load_cavein" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff535988, "spawn_statue_back" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )

------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/phantom_a.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 3,
		max_count	= 4,    
		entity 	= "data/entities/animals/crypt/skullrat.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/phantom_b.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/skullfly.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/crypt/tentacler.xml"
	},
	{
		prob   		= 0.15,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/crypt/tentacler_small.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= 
			{
			"data/entities/animals/crypt/tentacler_small.xml",
			"data/entities/animals/crypt/tentacler.xml",
			},
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/necromancer.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/acidshooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/crystal_physics.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/maggot.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/failed_alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_homing.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_weaken.xml",
		ngpluslevel = 1,
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/thundermage.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/worm.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/acidshooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/phantom_a.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/worm_skull.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/skullfly.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/crypt/skullrat.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/phantom_b.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
		"data/entities/animals/crypt/phantom_b.xml",
		"data/entities/animals/crypt/phantom_a.xml",
		},
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/crystal_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/crypt/wizard_tele.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/wizard_dark.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/wizard_poly.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/wizard_returner.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/wizard_neutral.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_hearty.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_swapper.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/barfer.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/crypt/enlightened_alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist_b.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necromancer_shop.xml",
		ngpluslevel = 2,
	},
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/ghoul.xml",
		ngpluslevel = 1,
	},
}

------------ items -------------------------------

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
		entity 	= "data/entities/items/wand_level_06.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_06_better.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_05.xml"
	},
	{
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_06.xml"
	},
}

g_statues =
{
	total_prob = 0,
	{
		prob   		= 3.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/sarcophagus.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/sarcophagus_evil.xml"
	},
}

g_statue_back =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statue_back.xml"
	},
}

g_scorpions =
{
	total_prob = 0,
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
		-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scorpion.xml"
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/crypt/stairs_right.png",
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
		material_file 	= "data/biome_impl/crypt/stairs_left.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_05 =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/room_liquid_funnel.png",
		visual_file		= "data/biome_impl/crypt/room_liquid_funnel_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/room_gate_drop.png",
		visual_file		= "data/biome_impl/crypt/room_gate_drop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/shop.png",
		visual_file		= "data/biome_impl/crypt/shop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_05b =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/room_liquid_funnel_b.png",
		visual_file		= "data/biome_impl/crypt/room_liquid_funnel_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/room_gate_drop_b.png",
		visual_file		= "data/biome_impl/crypt/room_gate_drop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/shop_b.png",
		visual_file		= "data/biome_impl/crypt/shop_visual.png",
		background_file	= "",
		is_unique		= 0
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
		entity 	= "data/entities/props/physics_skull_01.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_02.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_03.xml"
	},
}

g_lamp2 =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch.xml"
	},
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_red.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_pink.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_green.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/physics_vase.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,		
		entity 	= "data/entities/props/physics_vase_longleg.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,		
		entity 	= "data/entities/animals/mimic_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_01.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_02.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_03.xml"
	},
}

g_unique_enemy =
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
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/arrowtrap_right.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/firetrap_right.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/thundertrap_right.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/spittrap_right.xml"
	},
}

g_large_enemies =
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
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/arrowtrap_left.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/firetrap_left.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/thundertrap_left.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/spittrap_left.xml"
	},
}

g_ghost_crystal =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entities = {
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/ghost.xml",
			},
			"data/entities/buildings/ghost_crystal.xml",
		}
	},
}

g_pressureplates =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/pressure_plate.xml"
	},
}

g_doors =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_templedoor.xml"
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

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cathedral.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/mining.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/polymorphroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_03 =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/lavaroom.png",
		visual_file		= "data/biome_impl/crypt/lavaroom_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/pit.png",
		visual_file		= "data/biome_impl/crypt/pit_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/water_lava.png",
		visual_file		= "data/biome_impl/crypt/water_lava_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_beam =
{
	total_prob = 0,
	{
		prob   			= 5.0,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_01.png",
		visual_file		= "data/biome_impl/crypt/beam_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_02.png",
		visual_file		= "data/biome_impl/crypt/beam_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_03.png",
		visual_file		= "data/biome_impl/crypt/beam_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_04.png",
		visual_file		= "data/biome_impl/crypt/beam_04_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_05.png",
		visual_file		= "data/biome_impl/crypt/beam_05_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_06.png",
		visual_file		= "data/biome_impl/crypt/beam_06_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_07.png",
		visual_file		= "data/biome_impl/crypt/beam_07_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/beam_08.png",
		visual_file		= "data/biome_impl/crypt/beam_08_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_caveins =
{
	total_prob = 0,
	{
		prob   			= 5.0,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cavein_01.png",
		visual_file		= "data/biome_impl/crypt/cavein_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cavein_02.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cavein_03.png",
		visual_file		= "data/biome_impl/crypt/cavein_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cavein_04.png",
		visual_file		= "data/biome_impl/crypt/cavein_04_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_background_scenes =
{
	total_prob = 0,
	{
		prob   			= 3.0,
		sprite_file		= "",
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/pillars_01_background.png"
	},		
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/pillars_02_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/pillars_03_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/alcove_01_background.png"
	},
	{
		prob   			= 2.0,
		sprite_file		= "data/biome_impl/crypt/alcove_02_background.png"
	},
	{
		prob   			= 2.0,
		sprite_file		= "data/biome_impl/crypt/alcove_03_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/alcove_04_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/alcove_05_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/alcove_06_background.png"
	},
}

g_small_background_scenes =
{
	total_prob = 0,
	{
		prob   			= 4.0,
		visual_file		= ""
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/slab_01_background.png"
	},
	{
		prob   			= 0.5,
		sprite_file		= "data/biome_impl/crypt/slab_02_background.png"
	},
	{
		prob   			= 0.5,
		sprite_file		= "data/biome_impl/crypt/slab_03_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/slab_04_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/slab_05_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/slab_06_background.png"
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/crypt/slab_07_background.png"
	},
}

g_scavengers =
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
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 3,    
		entities 	= {
			"data/entities/animals/scavenger_smg.xml",
			"data/entities/animals/scavenger_grenade.xml",
			}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_leader.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_clusterbomb.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_poison.xml"
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
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
	},
}

g_bones =
{
	total_prob = 0,
	{
		prob   		= 2.4,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_01.xml",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_02.xml",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_03.xml",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_04.xml",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_05.xml",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_bone_06.xml",
	},
}

g_vines =
{
	total_prob = 0,
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
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
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
}

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
	-- spawn_hp_mult(g_small_enemies,x,y,0,0,8,"crypt")
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,8,"crypt")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.38) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-10, y-17, "", true )
	end
end

function spawn_statues(x, y)
	spawn(g_statues,x-4,y)
end

function spawn_statue_back(x, y)
	spawn(g_statue_back,x+5,y)
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x+6, y )
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x-5, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+4,y-8,0,0)
end

function spawn_lamp2(x, y)
	spawn(g_lamp2,x-1,y,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x-4,y-4,0,0)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x-1,y,0,0)
end

function spawn_large_enemies(x, y)
	spawn(g_large_enemies,x-1,y,0,0)
	-- spawn_hp_mult(g_large_enemies,x,y,0,0,8,"crypt")
end

function spawn_ghost_crystal(x, y)
	spawn(g_ghost_crystal,x-1,y,0,0)
end

function spawn_crawlers(x, y) end

function spawn_pressureplates(x, y)
	spawn(g_pressureplates,x,y,0,0)
end

function spawn_doors(x, y)
	-- Doors not functional, look at PhysicsAddJoint() and 'uid' in PhysicsBodyComponent
	
	--[[
	spawn(g_doors,x,y,0,0)
	]]--
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene3( x, y )
	load_random_pixel_scene( g_pixel_scene_03, x, y )
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x, y )
end

function load_pixel_scene5( x, y )
	load_random_pixel_scene( g_pixel_scene_05, x, y )
end

function load_pixel_scene5b( x, y )
	load_random_pixel_scene( g_pixel_scene_05b, x, y )
end

function spawn_scavengers(x, y)
	spawn(g_scavengers,x,y,0,0)
	-- spawn_hp_mult(g_scavengers,x,y,0,0,8,"crypt")
end

function spawn_scorpions(x, y)
	spawn(g_scorpions,x,y)
end

function spawn_bones(x, y)
	spawn(g_bones,x,y-12)
end

function load_beam( x, y )
	load_random_pixel_scene( g_beam, x, y-65 )
end

function load_cavein( x, y )
	load_random_pixel_scene( g_caveins, x-60, y-10 )
end

function load_background_scene( x, y )
	load_random_background_sprite( g_background_scenes, x+5, y )
end

function load_small_background_scene( x, y )
	load_random_background_sprite( g_small_background_scenes, x, y )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, nil )
	--print("shop item spawned at " .. x .. ", " .. y)
end

function init( x, y ) end