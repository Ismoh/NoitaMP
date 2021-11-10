-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff808000, "spawn_statues" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )
RegisterSpawnFunction( 0xff400080, "spawn_large_enemies" )
RegisterSpawnFunction( 0xffC8001A, "spawn_ghost_crystal" )
RegisterSpawnFunction( 0xff82FF5A, "spawn_crawlers" )
RegisterSpawnFunction( 0xff647D7D, "spawn_pressureplates" )
RegisterSpawnFunction( 0xff649B7D, "spawn_doors" )
RegisterSpawnFunction( 0xffA07864, "spawn_scavengers" )
RegisterSpawnFunction( 0xff00AC33, "load_pixel_scene3" )
RegisterSpawnFunction( 0xffFFCD2A, "spawn_scorpions" )

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/pyramid/hallway.png", "data/biome_impl/pyramid/hallway_visual.png", x, y, "", true )
	-- Fill in the background
	LoadBackgroundSprite("data/weather_gfx/background_pyramid.png", x, y)
	LoadBackgroundSprite("data/weather_gfx/background_pyramid.png", x, y + 256)
end

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 2.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/skullrat.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/skullfly.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/acidshooter.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scorpion.xml"
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 2.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/acidshooter.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/phantom_a.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/skullfly.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/skullrat.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/phantom_b.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scorpion.xml"
	},
}

g_statues =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statue.xml"
	},
}

g_scorpions =
{
	total_prob = 0,
	{
		prob   		= 0.2,
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
		entity 	= "data/entities/props/physics_torch_stand_blue.xml"
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
		entity 	= "data/entities/props/physics/chain_torch_blue.xml"
	},
}

g_save =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.8,
		min_count	= 1,
		max_count	= 1, 
		offset_y	= -4,
		entity 	= "data/entities/buildings/save_point.xml"
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

g_ghost_crystal =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.9,
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
}

g_scavengers =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.9,
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
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
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
	return
end

function spawn_statues(x, y)
	spawn(g_statues,x-4,y)
end

function spawn_chest(x, y)
	return
end

function spawn_save(x, y) end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x+6, y-4)
end

function load_pixel_scene4( x, y )
	load_random_pixel_scene( g_pixel_scene_04, x-5, y-4 )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+4,y,0,0)
end

function spawn_lamp2(x, y)
	--spawn(g_lamp2,x-1,y+18,0,0)
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
end

function spawn_ghost_crystal(x, y)
	spawn(g_ghost_crystal,x-1,y,0,0)
end

function spawn_crawlers(x, y) end

function spawn_pressureplates(x, y)
	spawn(g_pressureplates,x,y,0,0)
end

function spawn_doors(x, y)
	spawn(g_doors,x,y,0,0)
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene3( x, y )
	load_random_pixel_scene( g_pixel_scene_03, x, y )
end

function spawn_scavengers(x, y)
	spawn(g_scavengers,x,y,0,0)
end

function spawn_scorpions(x, y)
	spawn(g_scorpions,x,y)
end