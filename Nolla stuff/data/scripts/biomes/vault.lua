-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 6
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/biome_modifiers.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xff692e94, "load_pixel_scene_wide" )
RegisterSpawnFunction( 0xff822e5b, "load_pixel_scene_tall" )

RegisterSpawnFunction( 0xff00AC64, "load_warning_strip" )
RegisterSpawnFunction( 0xff01a1fa, "spawn_turret" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff504B64, "spawn_machines" )
RegisterSpawnFunction( 0xffc999ff, "spawn_hanging_prop" )
RegisterSpawnFunction( 0xffBE8246, "spawn_pipes_hor" )
RegisterSpawnFunction( 0xffBE8264, "spawn_pipes_turn_right" )
RegisterSpawnFunction( 0xffBE8282, "spawn_pipes_turn_left" )
RegisterSpawnFunction( 0xffBE82A0, "spawn_pipes_ver" )
RegisterSpawnFunction( 0xffBE82BE, "spawn_pipes_cross" )
RegisterSpawnFunction( 0xff2E8246, "spawn_pipes_big_hor" )
RegisterSpawnFunction( 0xff2E8264, "spawn_pipes_big_turn_right" )
RegisterSpawnFunction( 0xff2E8282, "spawn_pipes_big_turn_left" )
RegisterSpawnFunction( 0xff2E82A0, "spawn_pipes_big_ver" )

RegisterSpawnFunction( 0xff5c73da, "spawn_stains" )
RegisterSpawnFunction( 0xff5c73db, "spawn_stains_ceiling" )
RegisterSpawnFunction( 0xffc78f20, "spawn_barricade" )

RegisterSpawnFunction( 0xff4a107d, "load_pillar" )
RegisterSpawnFunction( 0xff7b59ab, "load_pillar_base" )
RegisterSpawnFunction( 0xff40ffce, "load_catwalk" )
RegisterSpawnFunction( 0xffbf4c86, "spawn_apparatus" )
RegisterSpawnFunction( 0xffaa42ff, "spawn_electricity_trap" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )

RegisterSpawnFunction( 0xffacf14b, "spawn_laser_trap" )
RegisterSpawnFunction( 0xffa45aff, "spawn_lab_puzzle" )


------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/drone_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/lasershooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/vault/roboguard.xml",
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/assassin.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tentacler.xml"
	},
	{
		prob   		= 0.12,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/tentacler_small.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entities 	= 
			{
			"data/entities/animals/vault/tentacler_small.xml",
			"data/entities/animals/vault/tentacler.xml",
			},
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/acidshooter.xml"
	},
	{
		prob   		= 0.18,
		min_count	= 3,
		max_count	= 5,    
		entity 	= "data/entities/animals/vault/blob.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/bigzombie.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/scavenger_mine.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/vault/sniper.xml",
			"data/entities/animals/vault/flamer.xml",
		}
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/drone_lasership.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/monk.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/vault/thunderskull.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drone_shield.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_super.xml",
		ngpluslevel = 2,
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/sniper.xml",
			"data/entities/animals/vault/coward.xml",
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/vault/scavenger_glue.xml",
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/firemage.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/thundermage.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_invis.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_shield.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/roboguard.xml",
			"data/entities/animals/vault/healerdrone_physics.xml"
		},
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/wizard_dark.xml"
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
		entity 	= "data/entities/animals/wizard_twitchy.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/maggot.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			{
				min_count	= 1,
				max_count	= 3,    
				entity 	= "data/entities/animals/vault/scavenger_smg.xml"
			},
			{
				min_count	= 1,
				max_count	= 3,    
				entity 	= "data/entities/animals/vault/scavenger_grenade.xml"
			},
			{
				min_count	= 0,
				max_count	= 3,    
				entity 	= "data/entities/animals/vault/scavenger_glue.xml"
			},
			"data/entities/animals/vault/scavenger_leader.xml",
			"data/entities/animals/vault/scavenger_heal.xml",
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tank.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tank_rocket.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tank_super.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/missilecrab.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/spearbot.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/flamer.xml",
			"data/entities/animals/vault/icer.xml",
			"data/entities/animals/vault/healerdrone_physics.xml",
		}
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/roboguard.xml",
			"data/entities/animals/vault/healerdrone_physics.xml",
			"data/entities/animals/vault/coward.xml",
		},
	},
	{
		prob   		= 0.075,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot_super.xml",
		ngpluslevel = 2,
	},
}

g_lamp =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_tubelamp.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_water.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_water_heavy.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_oil.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_radioactive.xml"
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
		entity 	= "data/entities/items/wand_level_05.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_05_better.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_03.xml"
	},
	{
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_04.xml"
	},
}

--- barrels ---

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_pressure_tank.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_propane_tank.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -8,
		entity 	= "data/entities/props/physics_seamine.xml"
	},
}

g_hanging_props =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_container.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_tank_radioactive.xml"
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_tank_acid.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_seamine.xml"
	},
}


-- horizontal --

local lab_liquids = { ["fff0bbee"] =  { "radioactive_liquid", "radioactive_liquid", "acid", "acid", "acid", "alcohol" },
					  ["ffa4dbd5"] =  { "radioactive_liquid", "radioactive_liquid", "acid", "acid", "acid", "alcohol" }}
g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/lab.png",
		visual_file		= "data/biome_impl/vault/lab_visual.png",
		background_file	= "data/biome_impl/vault/lab_background.png",
		is_unique		= 0,
		color_material  = lab_liquids,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/lab2.png",
		visual_file		= "data/biome_impl/vault/lab2_visual.png",
		background_file	= "data/biome_impl/vault/lab2_background.png",
		is_unique		= 0,
		color_material  = lab_liquids,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/lab3.png",
		visual_file		= "data/biome_impl/vault/lab3_visual.png",
		background_file	= "data/biome_impl/vault/lab3_background.png",
		is_unique		= 0,
		color_material  = lab_liquids,

	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/vault/symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/vault/lab_puzzle.png",
		visual_file		= "data/biome_impl/vault/lab_puzzle_visual.png",
		background_file	= "data/biome_impl/vault/lab_puzzle_background.png",
		is_unique		= 0,
		background_z_index = 38,
	},
}

g_pixel_scene_wide =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/brain_room.png",
		visual_file		= "data/biome_impl/vault/brain_room_visual.png",
		background_file	= "data/biome_impl/vault/brain_room_background.png",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/shop.png",
		visual_file		= "data/biome_impl/vault/shop_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
}


-- vertical --
g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/acidtank.png",
		visual_file		= "data/biome_impl/vault/acidtank_visual.png",
		background_file	= "data/biome_impl/vault/acidtank_background.png",
		is_unique		= 0,
	},
}

g_pixel_scene_tall =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/electric_tunnel_room.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/electric_tunnel_room_background.png",
		is_unique		= 0,
	},
}

--------------------------------------------------------------

g_pipes_hor =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_hor_1.png",
		visual_file		= "data/biome_impl/vault/pipe_hor_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_hor_2.png",
		visual_file		= "data/biome_impl/vault/pipe_hor_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/vault/pipe_hor_3.png",
		visual_file		= "data/biome_impl/vault/pipe_hor_3_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_ver =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_ver_1.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_ver_2.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/vault/pipe_ver_3.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_3_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/vault/pipe_ver_4.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_4_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_turn_right =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_turn_right.png",
		visual_file		= "data/biome_impl/vault/pipe_turn_right_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_turn_left =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_turn_left.png",
		visual_file		= "data/biome_impl/vault/pipe_turn_left_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_cross =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_cross.png",
		visual_file		= "data/biome_impl/vault/pipe_cross_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}


g_pipes_big_hor =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_hor_1.png",
		visual_file		= "data/biome_impl/vault/pipe_big_hor_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_hor_2.png",
		visual_file		= "data/biome_impl/vault/pipe_big_hor_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_big_ver =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_ver_1.png",
		visual_file		= "data/biome_impl/vault/pipe_big_ver_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_ver_2.png",
		visual_file		= "data/biome_impl/vault/pipe_big_ver_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_big_turn_right =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_turn_right.png",
		visual_file		= "data/biome_impl/vault/pipe_big_turn_right_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_big_turn_left =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_big_turn_left.png",
		visual_file		= "data/biome_impl/vault/pipe_big_turn_left_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

--------------------------------------------------------------

g_stains =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/stain.png",
		visual_file		= "data/biome_impl/vault/stain_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/stain.png",
		visual_file		= "data/biome_impl/vault/stain_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/stain.png",
		visual_file		= "data/biome_impl/vault/stain_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_stains_ceiling =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/stain_ceiling.png",
		visual_file		= "data/biome_impl/vault/stain_ceiling_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/stain_ceiling.png",
		visual_file		= "data/biome_impl/vault/stain_ceiling_02_visual.png",
		background_file	= "",
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

g_turret =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/animals/vault/turret_right.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/animals/vault/turret_left.xml"
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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 2.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_hanging_wire.xml"
	},
}

g_machines =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_1.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_2.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_3.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_4.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_5.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_6.xml"
	},
	{
		prob   		= 1.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
}

g_apparatus =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_apparatus_01.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_apparatus_02.xml"
	},
}

g_barricade =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_box_harmless.xml"
	},
}

--------------------------------------------------------------


g_catwalks =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/vault/catwalk_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/catwalk_01_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/vault/catwalk_02.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/catwalk_02_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/vault/catwalk_02b.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/catwalk_02b_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/vault/catwalk_03.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/catwalk_03_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/vault/catwalk_04.png",
		visual_file		= "",
		background_file	= "data/biome_impl/vault/catwalk_04_background.png",
		is_unique		= 0
	},
}

g_pillars =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/vault/pillar_01_background.png",
		z_index			= 40,
	},
	{
		prob   			= 0.2,
		sprite_file 	= "data/biome_impl/vault/pillar_02_background.png",
		z_index			= 40,
	},
	{
		prob   			= 0.2,
		sprite_file 	= "data/biome_impl/vault/pillar_03_background.png",
		z_index			= 40,
	},
	{
		prob   			= 0.3,
		sprite_file 	= "data/biome_impl/vault/pillar_04_background.png",
		z_index			= 40,
	},
	{
		prob   			= 0.2,
		sprite_file 	= "data/biome_impl/vault/pillar_05_background.png",
		z_index			= 40,
	},
}

g_pillar_bases =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/vault/pillar_base_01_background.png",
		z_index			= 40,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/vault/pillar_base_02_background.png",
		z_index			= 40,
	},
}

function safe( x, y )
	local result = true
	
	if ( x >= 125 ) and ( x <= 249 ) and ( y >= 8694 ) and ( y <= 8860 ) then
		result = false
	end
	
	return result
end

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	if safe( x, y ) then
		spawn(g_small_enemies,x,y)
	end
	-- spawn_hp_mult(g_small_enemies,x,y,0,0,4,"vault")
end

function spawn_big_enemies(x, y)
	if safe( x, y ) then
		spawn(g_big_enemies,x,y)
	end
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,4,"vault")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r < 0.93) then
		LoadPixelScene( "data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x-5, y-10, "", true )
	end
end

function spawn_lamp(x, y)
	if safe( x, y ) then
		spawn(g_lamp,x,y,0,0)
	end
end

function spawn_props(x, y)
	if safe( x, y ) then
		spawn(g_props,x,y)
	end
end

function spawn_hanging_prop(x, y)
	if safe( x, y ) then
		spawn(g_hanging_props,x,y)
	end
end


function spawn_turret(x, y)
	if safe( x, y ) then
		spawn(g_turret,x,y,0,0)
	end
	-- spawn_hp_mult(g_turret,x,y,0,0,4,"vault")
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x, y )
end

function load_pixel_scene_wide( x,y )
	--print("loaded wide scene at " .. x .. ", " .. y)
	load_random_pixel_scene( g_pixel_scene_wide, x, y )
end

function load_pixel_scene_tall( x,y )
	--print("loaded tall scene at " .. x .. ", " .. y)
	load_random_pixel_scene( g_pixel_scene_tall, x, y )
end

function load_warning_strip( x, y )
	LoadBackgroundSprite("data/biome_impl/vault/warningstrip_background.png", x, y-4, 40)
end


function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_machines(x, y)
	spawn(g_machines,x+5,y+5,0,0)
end

function spawn_stains( x, y )
	load_random_pixel_scene( g_stains, x-10, y )
end

function spawn_apparatus(x, y)
	spawn(g_apparatus,x-4,y-5,0,0)
end

function spawn_stains_ceiling( x, y )
	load_random_pixel_scene( g_stains_ceiling, x-20, y-10 )
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar_vault.png", "data/biome_impl/potion_altar_vault_visual.png", x-3, y-10, "", true )
	end
end

function spawn_barricade(x, y)
	spawn(g_barricade,x,y,0,0)
end

function spawn_electricity_trap(x, y)
	EntityLoad("data/entities/props/physics_trap_electricity_enabled.xml", x, y)
end

function spawn_laser_trap(x, y)
	SetRandomSeed( x, y )
	
	LoadPixelScene( "data/biome_impl/vault/hole.png", "", x, y, "", true )
	
	if ( Random( 1, 3 ) == 2 ) then
		EntityLoad("data/entities/props/physics/trap_laser_toggling.xml", x + 5, y + 5)
	end
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, nil )
end

function spawn_lab_puzzle(x, y)
	SetRandomSeed(x, y)
	local type_a = random_from_array({
		"poly",
		"tele",
		"charm",
		"berserk",
	})
	local type_b = random_from_array({
		"protect",
		"worm",
		"invis",
		"speed",
	})
	EntityLoad("data/entities/buildings/vault_lab_puzzle_" .. type_a .. ".xml", x - 10, y)
	EntityLoad("data/entities/buildings/vault_lab_puzzle_" .. type_b .. ".xml", x + 11, y)
end


-----------------------------------------
-- PIPES
-----------------------------------------

function spawn_pipes_hor( x, y )
	load_random_pixel_scene( g_pipes_hor, x, y)
end

function spawn_pipes_ver( x, y )
	load_random_pixel_scene( g_pipes_ver, x, y)
end

function spawn_pipes_turn_right( x, y )
	load_random_pixel_scene( g_pipes_turn_right, x, y)
end

function spawn_pipes_turn_left( x, y )
	load_random_pixel_scene( g_pipes_turn_left, x, y)
end

function spawn_pipes_cross( x, y )
	load_random_pixel_scene( g_pipes_cross, x, y)
end

function spawn_pipes_big_hor( x, y )
	load_random_pixel_scene( g_pipes_big_hor, x, y)
end

function spawn_pipes_big_ver( x, y )
	load_random_pixel_scene( g_pipes_big_ver, x, y)
end

function spawn_pipes_big_turn_right( x, y )
	load_random_pixel_scene( g_pipes_big_turn_right, x, y)
end

function spawn_pipes_big_turn_left( x, y )
	load_random_pixel_scene( g_pipes_big_turn_left, x, y)
end

-----------------------------------------
-- STRUCTURES
-----------------------------------------

function load_catwalk( x, y )
	-- randomize height a bit
	SetRandomSeed(x, y)
	y = rand(y, y+1)
	load_random_pixel_scene( g_catwalks, x, y-20 )
end

function load_pillar( x, y )
	load_random_background_sprite( g_pillars, x, y+3 )
end

function load_pillar_base( x, y )
	load_random_background_sprite( g_pillar_bases, x, y+3)
end
