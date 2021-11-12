-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xff805000, "spawn_cloud_trap" )
RegisterSpawnFunction( 0xff397780, "load_floor_rubble" )
RegisterSpawnFunction( 0xff00ffa0, "load_floor_rubble_l" )
RegisterSpawnFunction( 0xff1ca7ff, "load_floor_rubble_r" )


------------ small enemies -------------------------------

g_small_enemies =
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
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/wand_ghost.xml"
	},
}

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
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/statue_physics.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/phantom_a.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/phantom_b.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necromancer.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_returner.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,
		entity 	= "data/entities/animals/wizard_neutral.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,
		entity 	= "data/entities/animals/wizard_hearty.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/enlightened_alchemist.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist.xml"
	},
}

g_lamp =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
	},
}

g_ghostlamp =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
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

g_props =
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
	{
		prob   		= 5.4,
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
}

g_cloud_trap =
{
	total_prob = 0,
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/cloud_trap.xml"
	},
}

g_floor_rubble =
{
	total_prob = 0,
	{
		prob   			= 15.0,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_03.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_l_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_l_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_l_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_l_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_r_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_r_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.05,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_r_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_r_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_floor_rubble_l =
{
	total_prob = 0,
	{
		prob   			= 2.0,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_l_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_l_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_l_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_l_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_03.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_floor_rubble_r =
{
	total_prob = 0,
	{
		prob   			= 2.0,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_r_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_r_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_r_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_r_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
		{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_small_03.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_small_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_01.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/wandcave/floor_rubble_dynamic_02.png",
		visual_file		= "data/biome_impl/wandcave/floor_rubble_dynamic_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

-- this is a special function tweaked for spawning things in coal mines
function spawn_items( pos_x, pos_y )
	local r = ProceduralRandom( pos_x, pos_y )
	-- 20% is air, nothing happens
	if( r < 0.47 ) then return end
	r = ProceduralRandom( pos_x-11.431, pos_y+10.5257 )
	
	if( r < 0.725 ) then
	else
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10, pos_y-17, "", true )
		return
	end
end

-- actual functions that get called from the wang generator


function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x,y-3,0,0)
end

function spawn_cloud_trap(x, y)
	spawn(g_cloud_trap,x-5,y-10)
end

function load_floor_rubble( x, y )
	load_random_pixel_scene( g_floor_rubble, x-10, y-15 )
end

function load_floor_rubble_l( x, y )
	load_random_pixel_scene( g_floor_rubble_l, x-10, y-15 )
end

function load_floor_rubble_r( x, y )
	load_random_pixel_scene( g_floor_rubble_r, x-18, y-17 )
end

function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_candles( x, y ) end
function spawn_potions( x, y ) end
function spawn_wands( x, y ) end