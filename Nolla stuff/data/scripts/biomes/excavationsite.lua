-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xff0000ff, "spawn_nest" )
RegisterSpawnFunction( 0xffFF50FF, "spawn_hanger" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xff00ac6e, "load_pixel_scene4_alt" )
RegisterSpawnFunction( 0xff0050FF, "spawn_wheel" )
RegisterSpawnFunction( 0xff0150FF, "spawn_wheel_small" )
RegisterSpawnFunction( 0xff0250FF, "spawn_wheel_tiny" )
RegisterSpawnFunction( 0xff2d2eac, "spawn_rock" )
RegisterSpawnFunction( 0xff0A50FF, "spawn_physicsstructure" )
RegisterSpawnFunction( 0xffc999ff, "spawn_hanging_prop" )
RegisterSpawnFunction( 0xff7868ff, "load_puzzleroom" )
RegisterSpawnFunction( 0xff70d79e, "load_gunpowderpool_01" )
RegisterSpawnFunction( 0xff70d79f, "load_gunpowderpool_02" )
RegisterSpawnFunction( 0xff70d7a0, "load_gunpowderpool_03" )
RegisterSpawnFunction( 0xff70d7a1, "load_gunpowderpool_04" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xffb09016, "spawn_meditation_cube" )
RegisterSpawnFunction( 0xff00855c, "spawn_receptacle" )

RegisterSpawnFunction( 0xffb1ff99, "spawn_tower_short" )
RegisterSpawnFunction( 0xff5c8550, "spawn_tower_tall" )
RegisterSpawnFunction( 0xff227fff, "spawn_beam_low" )
RegisterSpawnFunction( 0xff8228ff, "spawn_beam_low_flipped" )
RegisterSpawnFunction( 0xff0098ba, "spawn_beam_steep" )
RegisterSpawnFunction( 0xff7600a9, "spawn_beam_steep_flipped" )

------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.55,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/firebug.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 4,    
		entity 	= "data/entities/animals/rat.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/slimeshooter.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 5,    
		entity 	= "data/entities/animals/bat.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/bigfirebug.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,  
		entity 	= "data/entities/animals/goblin_bomb.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_hearty.xml",
		ngpluslevel = 2,
	},
	-- Demo case for Arvi
	--[[
	{
		prob 		= 10,
		min_count	= 1,
		max_count 	= 1,
		entities = {
			{
				min_count	= 1,
				max_count 	= 5,
				entity = "data/entities/animals/shotgunner.xml",
			},
			{
				min_count = 10,
				max_count= 12,
				entity = "data/entities/animals/roboguard.xml",
			},
			"data/entities/items/chest_stash.xml",
		}
	},
	]]--
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.98,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/miner.xml",
			"data/entities/animals/shotgunner.xml",
		}
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/miner_fire.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/slimeshooter.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/fireskull.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/bigbat.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_mine.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_santa.xml",
		spawn_check = function() 
			local year, month, day = GameGetDateAndTimeLocal()
			
			if ( month == 12 ) and ( day >= 24 ) and ( day <= 26 ) then
				return true
			else
				return false 
			end
		end
	},
	{
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 4,    
		entity 	= "data/entities/animals/firebug.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/bigfirebug.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_super.xml",
		ngpluslevel = 1,
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
		entity 	= "data/entities/props/physics/lantern_small.xml"
	},
}

---------- UNIQUE ENCOUNTERS ---------------

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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/slimeshooter.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/acidshooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/giantshooter.xml"
	},
}

g_unique_enemy2 =
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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/miner_santa.xml",
		spawn_check = function() 
			local year, month, day = GameGetDateAndTimeLocal()
			
			if ( month == 12 ) and ( day >= 24 ) and ( day <= 26 ) then
				return true
			else
				return false 
			end
		end

	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner.xml"
	},
}

g_unique_enemy3 =
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
		entity 	= "data/entities/animals/firemage.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage.xml"
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
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_01.xml"
	},
	{
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_02.xml"
	},
	{
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_02_better.xml"
	},
}

--- barrels ---

g_props =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -3,
		entity 	= "data/entities/props/physics/minecart.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -5,    
		entity 	= "data/entities/props/physics_cart.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -8,    
		entity 	= "data/entities/props/physics_seamine.xml"
	},
}

g_props2 =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -3,
		entity 	= "data/entities/props/physics/minecart.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_brewing_stand.xml"
	},
}

g_props3 =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_green.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_red.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_blue.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_yellow.xml"
	},
}

--- pixelscenes ---

g_cranes =
{
	total_prob = 0,
	{
		prob   		= 2.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_wheel_stand_01.xml",
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_wheel_stand_02.xml",
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_wheel_stand_03.xml",
	},
}

g_mechanism_background =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/mechanism_background.png",
		z_index			= 50,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/mechanism_background2.png",
		z_index			= 50,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/mechanism_background3.png",
		z_index			= 50,
	},
}

g_pixel_scene_04 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_1.png",
		visual_file		= "data/biome_impl/excavationsite/machine_1_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_1_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_2.png",
		visual_file		= "data/biome_impl/excavationsite/machine_2_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_2_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_3b.png",
		visual_file		= "data/biome_impl/excavationsite/machine_3b_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_3b_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_4.png",
		visual_file		= "data/biome_impl/excavationsite/machine_4_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_4_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_5.png",
		visual_file		= "data/biome_impl/excavationsite/machine_5_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_5_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_6.png",
		visual_file		= "data/biome_impl/excavationsite/machine_6_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/excavationsite/machine_7.png",
		visual_file		= "data/biome_impl/excavationsite/machine_5_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_5_background.png",
		is_unique		= 0
	},
	{
		prob   			= 3,
		material_file 	= "data/biome_impl/excavationsite/shop.png",
		visual_file		= "data/biome_impl/excavationsite/shop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/excavationsite/oiltank_1.png",
		visual_file		= "data/biome_impl/excavationsite/oiltank_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/excavationsite/lake.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_pixel_scene_04_alt =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_1_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_1_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_1_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_2_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_2_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_2_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_3b_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_3b_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_3b_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_4_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_4_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_4_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_5_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_5_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_5_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/excavationsite/machine_6_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_6_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/excavationsite/machine_7_alt.png",
		visual_file		= "data/biome_impl/excavationsite/machine_5_visual.png",
		background_file	= "data/biome_impl/excavationsite/machine_5_background.png",
		is_unique		= 0
	},
	{
		prob   			= 3,
		material_file 	= "data/biome_impl/excavationsite/shop_alt.png",
		visual_file		= "data/biome_impl/excavationsite/shop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.7,
		material_file 	= "data/biome_impl/excavationsite/receptacle_steam.png",
		visual_file		= "",
		background_file	= "data/biome_impl/excavationsite/receptacle_steam_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/excavationsite/lake_alt.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_puzzleroom =
{
	total_prob = 0,
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/puzzleroom_01.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/puzzleroom_02.png",
		visual_file		= "data/biome_impl/excavationsite/puzzleroom_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/puzzleroom_03.png",
		visual_file		= "data/biome_impl/excavationsite/puzzleroom_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_gunpowderpool_01 =
{
	total_prob = 0,
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/gunpowderpool_01.png",
		visual_file		= "data/biome_impl/excavationsite/gunpowderpool_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_gunpowderpool_02 =
{
	total_prob = 0,
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/gunpowderpool_02.png",
		visual_file		= "data/biome_impl/excavationsite/gunpowderpool_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_gunpowderpool_03 =
{
	total_prob = 0,
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/gunpowderpool_03.png",
		visual_file		= "data/biome_impl/excavationsite/gunpowderpool_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_gunpowderpool_04 =
{
	total_prob = 0,
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/excavationsite/gunpowderpool_04.png",
		visual_file		= "data/biome_impl/excavationsite/gunpowderpool_04_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_nest =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/firebugnest.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
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
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

g_hanger =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_bucket.xml"
	},
}

g_physicsstructure =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/excavationsite_machine_3b.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/excavationsite_machine_3c.xml"
	},
}

g_rock =
{
	total_prob = 0,
	{
		prob   		= 1.2,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_stone_01.xml",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_stone_02.xml",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_stone_03.xml",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_stone_04.xml",
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
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_container.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_tank_radioactive.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/suspended_seamine.xml"
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

-- backgrounds
g_tower_mids =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_mid_1.png",
		z_index			= 40,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_mid_2.png",
		z_index			= 40,
	},
	{
		prob   			= 0.5,
		sprite_file 	= "data/biome_impl/excavationsite/tower_mid_3.png",
		z_index			= 40,
	},
	{
		prob   			= 0.5,
		sprite_file 	= "data/biome_impl/excavationsite/tower_mid_4.png",
		z_index			= 40,
	},
}
g_tower_tops =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_top_1.png",
		z_index			= 20,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_top_2.png",
		z_index			= 20,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_top_3.png",
		z_index			= 20,
	},
	{
		prob   			= 2.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_top_4.png",
		z_index			= 20,
	},
	{
		prob   			= 1.0,
		sprite_file 	= "data/biome_impl/excavationsite/tower_top_5.png",
		z_index			= 20,
	},
}


-- this is a special function tweaked for spawning things in coal mines
function spawn_items( pos_x, pos_y )
	local r = ProceduralRandom( pos_x, pos_y )
	-- 20% is air, nothing happens
	-- is this needed anymore?
	-- if( r < 0.47 ) then return end
	r = ProceduralRandom( pos_x-11.431, pos_y+10.5257 )

	if( r < 0.725 ) then
	else
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10, pos_y-17, "", true )
		return
	end
end

-- actual functions that get called from the wang generator


function spawn_small_enemies(x, y)
	local r = ProceduralRandom( x, y )
	local spawn_percent = BiomeMapGetVerticalPositionInsideBiome( x, y )
	spawn_percent = ( 2.5 * spawn_percent ) + 0.35
	if( r > spawn_percent ) then return end

	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	local r = ProceduralRandom( x, y )
	local spawn_percent = BiomeMapGetVerticalPositionInsideBiome( x, y )
	spawn_percent = ( 2.1 * spawn_percent )
	if( r > spawn_percent ) then return end

	spawn(g_big_enemies,x,y)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+2,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x,y-3,0,0)
end

function spawn_props2(x, y)
	spawn(g_props2,x,y-3,0,0)
end

function spawn_props3(x, y)
	spawn(g_props3,x,y,0,0)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_unique_enemy2(x, y)
	spawn(g_unique_enemy2,x,y)
end

function spawn_unique_enemy3(x, y)
	spawn(g_unique_enemy3,x,y)
end

function load_pixel_scene( x, y )
	--spawn(g_cranes,x+35,y+35,0,0)
end

function load_pixel_scene2( x, y )
	load_random_background_sprite( g_mechanism_background, x, y )
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x, y )
end

function load_pixel_scene4_alt( x, y )
	load_random_pixel_scene( g_pixel_scene_04_alt, x, y )
end

function load_puzzleroom( x, y )
	load_random_pixel_scene( g_puzzleroom, x, y )
end

function load_gunpowderpool_01( x, y )
	load_random_pixel_scene( g_gunpowderpool_01, x, y )
end

function load_gunpowderpool_02( x, y )
	load_random_pixel_scene( g_gunpowderpool_02, x, y )
end

function load_gunpowderpool_03( x, y )
	load_random_pixel_scene( g_gunpowderpool_03, x-3, y+3 )
end

function load_gunpowderpool_04( x, y )
	load_random_pixel_scene( g_gunpowderpool_04, x, y )
end

function spawn_physicsstructure(x, y)
	spawn(g_physicsstructure,x-5,y-5,0,0)
end

function spawn_wheel(x, y)
	EntityLoad( "data/entities/props/physics_wheel.xml", x, y )
end

function spawn_wheel_small(x, y)
	EntityLoad( "data/entities/props/physics_wheel_small.xml", x, y )
end

function spawn_wheel_tiny(x, y)
	EntityLoad( "data/entities/props/physics_wheel_tiny.xml", x, y )
end

function spawn_hanger(x, y)
	spawn(g_hanger,x,y,0,0)
end

function spawn_rock(x, y)
	spawn(g_rock,x,y)
end

function spawn_hanging_prop(x, y)
	spawn(g_hanging_props,x,y)
end

function spawn_nest(x, y)
	spawn(g_nest,x+4,y+8,0,0)
end

function spawn_ladder(x, y)
	--spawn(g_ladder,x,y-80,0,0)
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 2 )
end

function spawn_meditation_cube( x, y )
	SetRandomSeed( x, y )
	local rnd = Random( 1, 100 )
	if( rnd > 96 and not ModIsEnabled("nightmare") ) then
		LoadPixelScene( "data/biome_impl/excavationsite/meditation_cube.png", "data/biome_impl/excavationsite/meditation_cube_visual.png", x-20, y-29, "", true )
		EntityLoad( "data/entities/buildings/teleport_meditation_cube.xml", x, y-70 )
	end
end

function spawn_receptacle( x, y )
	EntityLoad( "data/entities/buildings/receptacle_steam.xml", x, y )
end

-- Background sprites
function spawn_tower_short(x,y)
	generate_tower(x,y,ProceduralRandomi(x-4,y+3,0,2))
end

function spawn_tower_tall(x,y)
	generate_tower(x,y,ProceduralRandomi(x+7,y-1,2,3))
end

function generate_tower( x, y, height )
	if ProceduralRandom(x,y) > 0.5 then
		return
	end

	y = y + 15

	-- bottom
	LoadBackgroundSprite("data/biome_impl/excavationsite/tower_bottom_1.png", x, y, 40, true )
	y = y - 60
	
	-- middle parts
	for i=1, height do
		if y > 1600 then -- build up when not near the top of the biome
			load_random_background_sprite( g_tower_mids, x, y )
			y = y - 60
		end
	end

	-- top
	x = x - 50
	load_random_background_sprite( g_tower_tops, x, y )
end

function spawn_beam_low(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_low.png", x-60, y-35, 60, true )
end

function spawn_beam_low_flipped(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_low_flipped.png", x-60, y-35, 60, true)
end

function spawn_beam_steep(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_steep.png", x-35, y-60, 60, true)
end

function spawn_beam_steep_flipped(x,y)
	LoadBackgroundSprite("data/biome_impl/excavationsite/beam_steep_flipped.png", x-35, y-60, 60, true)
end
