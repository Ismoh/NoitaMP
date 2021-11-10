-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
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
		entity 	= "data/entities/animals/gazer.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/bloodcrystal_physics.xml"
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
		entity 	= "data/entities/items/wand_level_04.xml"
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "",
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
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/buildings/spike.xml"
	},
}

g_unique_enemy =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/arrowtrap_right.xml"
	},
}

g_large_enemies =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/arrowtrap_left.xml"
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


-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.38) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-10, y-17, "", true )
	end
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x+6, y-4)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+4,y,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x+5,y+5)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x-1,y,0,0)
end

function spawn_large_enemies(x, y)
	spawn(g_large_enemies,x-1,y,0,0)
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/magic_gate.png", "", x, y, "", true )
end

function spawn_apparition(x, y) end

function spawn_candles(x, y) end

function spawn_ghostlamp(x, y) end

function spawn_potions( x, y ) end