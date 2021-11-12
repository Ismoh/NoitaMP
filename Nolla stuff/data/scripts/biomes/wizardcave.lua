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
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/firemage.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/thundermage.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/icemage.xml"
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
		entity 	= "data/entities/animals/wizard_poly.xml"
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
		entity 	= "data/entities/animals/wizard_swapper.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_neutral.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/wizard_returner.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_hearty.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_twitchy.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_weaken.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_homing.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/barfer.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist.xml"
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
		prob   		= 0.2,
		min_count	= 2,
		max_count	= 3,    
		entity 	= "data/entities/animals/thundermage.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_tele.xml", "data/entities/animals/wizard_dark.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_dark.xml", "data/entities/animals/wizard_poly.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_poly.xml", "data/entities/animals/wizard_swapper.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_swapper.xml", "data/entities/animals/wizard_hearty.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_hearty.xml", "data/entities/animals/wizard_twitchy.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_twitchy.xml", "data/entities/animals/wizard_neutral.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_neutral.xml", "data/entities/animals/wizard_returner.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_returner.xml", "data/entities/animals/wizard_weaken.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_weaken.xml", "data/entities/animals/wizard_homing.xml" },
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_homing.xml", "data/entities/animals/wizard_tele.xml" },
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_tele.xml", "data/entities/animals/wizard_dark.xml", "data/entities/animals/wizard_poly.xml", "data/entities/animals/wizard_swapper.xml", "data/entities/animals/wizard_neutral.xml", "data/entities/animals/wizard_twitchy.xml", "data/entities/animals/wizard_returner.xml", "data/entities/animals/wizard_hearty.xml", "data/entities/animals/wizard_weaken.xml", "data/entities/animals/wizard_homing.xml" },
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

g_background_scenes =
{
	total_prob = 0,
	{
		prob   			= 4.0,
		sprite_file		= "",
	},
	{
		prob   			= 1.0,
		sprite_file		= "data/biome_impl/wizardcave/drape_1.png"
	},		
	{
		prob   			= 0.66,
		sprite_file		= "data/biome_impl/wizardcave/drape_2.png"
	},
	{
		prob   			= 0.33,
		sprite_file		= "data/biome_impl/wizardcave/drape_3.png"
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
end

function spawn_statue_back(x, y)
end

function load_pixel_scene2( x, y )
end

function load_pixel_scene4( x, y )
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
end

function load_pixel_scene3( x, y )
end

function load_pixel_scene4( x, y )
end

function load_pixel_scene5( x, y )
end

function load_pixel_scene5b( x, y )
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
end

function load_cavein( x, y )
end

function load_background_scene( x, y )
	--load_random_background_sprite( g_background_scenes, x+5, y )
end

function load_small_background_scene( x, y )
	load_random_background_sprite( g_background_scenes, x, y )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, nil )
	--print("shop item spawned at " .. x .. ", " .. y)
end

function init( x, y ) end