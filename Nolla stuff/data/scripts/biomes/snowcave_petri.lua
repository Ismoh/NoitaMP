-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 2
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xff00AC33, "load_pixel_scene3" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xff55AF4B, "load_altar" )
RegisterSpawnFunction( 0xff23B9C3, "spawn_altar_torch" ) 
RegisterSpawnFunction( 0xff55AF8C, "spawn_skulls" ) 
RegisterSpawnFunction( 0xffF516E3, "spawn_scavenger_party" )
RegisterSpawnFunction( 0xffFFC84E, "spawn_acid" )
RegisterSpawnFunction( 0xff7285c4, "load_acidtank_right" )
RegisterSpawnFunction( 0xff9472c4, "load_acidtank_left" )
RegisterSpawnFunction( 0xff9E8AC2, "load_suspension_bridge" )
------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/shotgunner.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/slimeshooter.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 4,    
		entity 	= "data/entities/animals/rat.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/iceskull.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/scavenger_grenade.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/scavenger_smg.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
		"data/entities/animals/scavenger_smg.xml",
		"data/entities/animals/scavenger_grenade.xml"
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/sniper.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
}


------------ BIG ENEMIES ------------------------------------------------------

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.3,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.15,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/worm.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/worm_tiny.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/iceskull.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/giant.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			{
				min_count	= 1,
				max_count 	= 1,
				entity = "data/entities/animals/sniper.xml",
			},
			{
				min_count	= 0,
				max_count 	= 2,
				entity = "data/entities/animals/shotgunner.xml",
			},
		}
	},
	{
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/scavenger_grenade.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/scavenger_smg.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			{
				min_count	= 1,
				max_count 	= 4,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 4,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			"data/entities/animals/scavenger_leader.xml",
		}
	},
}


---------- UNIQUE ENCOUNTERS ---------------

g_scavenger_party =
{
	total_prob = 0,
	-- 
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			{
				min_count	= 1,
				max_count 	= 4,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 4,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			"data/entities/animals/scavenger_leader.xml",
		}
	},
}


g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_tele.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_dark.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necromancer.xml"
	},
}

g_unique_enemy2 =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/scavenger_grenade.xml"
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/scavenger_smg.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/sniper.xml"
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
		entity 	= "data/entities/items/wand_level_02.xml"
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/verticalobservatory.png",
		visual_file		= "data/biome_impl/snowcave/verticalobservatory_visual.png",
		background_file	= "data/biome_impl/snowcave/verticalobservatory_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/verticalobservatory2.png",
		visual_file		= "data/biome_impl/snowcave/verticalobservatory2_visual.png",
		background_file	= "data/biome_impl/snowcave/verticalobservatory2_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/icebridge2.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/pipe.png",
		visual_file		= "data/biome_impl/snowcave/pipe_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/icepillar.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcave/crater.png",
		visual_file		= "data/biome_impl/snowcave/crater_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/horizontalobservatory.png",
		visual_file		= "data/biome_impl/snowcave/horizontalobservatory_visual.png",
		background_file	= "data/biome_impl/snowcave/horizontalobservatory_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/horizontalobservatory2.png",
		visual_file		= "data/biome_impl/snowcave/horizontalobservatory2_visual.png",
		background_file	= "data/biome_impl/snowcave/horizontalobservatory2_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/snowcave/horizontalobservatory3.png",
		visual_file		= "data/biome_impl/snowcave/horizontalobservatory3_visual.png",
		background_file	= "data/biome_impl/snowcave/horizontalobservatory3_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcave/icebridge.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcave/snowcastle.png",
		visual_file		= "data/biome_impl/snowcave/snowcastle_visual.png",
		background_file	= "data/biome_impl/snowcave/snowcastle_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0,
		material_file 	= "data/biome_impl/snowcave/symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_03 =
{
	total_prob = 0,
	{
		prob   			= 0.7,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/tinyobservatory.png",
		visual_file		= "data/biome_impl/snowcave/tinyobservatory_visual.png",
		background_file	= "data/biome_impl/snowcave/tinyobservatory_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/tinyobservatory2.png",
		visual_file		= "data/biome_impl/snowcave/tinyobservatory2_visual.png",
		background_file	= "data/biome_impl/snowcave/tinyobservatory2_background.png",
		is_unique		= 0
	},
}

g_acidtank_right =
{
	total_prob = 0,
	{
		prob   			= 1.7,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.2,
		material_file 	= "data/biome_impl/acidtank_2.png",
		visual_file		= "data/biome_impl/acidtank_2_visual.png",
		background_file	= "data/biome_impl/acidtank_2_background.png",
		is_unique		= 0
	},
}

g_acidtank_left =
{
	total_prob = 0,
	{
		prob   			= 1.7,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.2,
		material_file 	= "data/biome_impl/acidtank.png",
		visual_file		= "data/biome_impl/acidtank_visual.png",
		background_file	= "data/biome_impl/acidtank_background.png",
		is_unique		= 0
	},
}

g_pixel_scene_04 =
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
		material_file 	= "data/biome_impl/snowcave/icicles.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/icicles2.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/icicles3.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcave/icicles4.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_lantern_small.xml"
	},
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.15,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_propane_tank.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
}

g_skulls =
{
	total_prob = 0,
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_skull_01.xml"
	},
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_skull_02.xml"
	},
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_skull_03.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_01.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_02.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_03.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_04.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_05.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_bone_06.xml"
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

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_unique_enemy2(x, y)
	spawn(g_unique_enemy2,x,y)
end

function spawn_scavenger_party(x,y)
	spawn(g_scavenger_party, x, y)
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r < 0.45) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-15, y-17, "", true )
	end
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+5,y+10,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x,y-3,0,0)
end

function spawn_skulls(x, y)
	spawn(g_skulls,x,y,0,0)
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x, y )
end

function load_pixel_scene3( x, y )
	load_random_pixel_scene( g_pixel_scene_03, x, y )
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x, y )
end

function spawn_altar_torch(x, y)
	EntityLoad( "data/entities/props/altar_torch.xml", x-7, y-36 )
end

function spawn_acid(x, y)
	EntityLoad( "data/entities/props/dripping_acid_gas.xml", x, y )
end

function load_altar( x, y )
	LoadPixelScene( "data/biome_impl/altar.png", "data/biome_impl/altar_visual.png", x-92, y-96, "", true )
	EntityLoad( "data/entities/buildings/altar.xml", x, y-32 )
end

function load_acidtank_right( x, y )
	load_random_pixel_scene( g_acidtank_right, x-12, y-12 )
end

function load_acidtank_left( x, y )
	load_random_pixel_scene( g_acidtank_left, x-252, y-12 )
end

function load_suspension_bridge( x, y )
	EntityLoad( "data/entities/props/physics_spawners/physics_suspension_bridge_spawner.xml", x, y )
end