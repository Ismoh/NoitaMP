-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/item_spawnlists.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff00AC64, "load_background_panel_big" )
RegisterSpawnFunction( 0xff967878, "spawn_lasergun" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xffc88dab, "spawn_statues" )

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/enlightened_alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_returner.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_neutral.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_tele.xml", "data/entities/animals/wizard_dark.xml" },
		ngpluslevel = 1,
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_hearty.xml", "data/entities/animals/wizard_swapper.xml" },
		ngpluslevel = 1,
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/enlightened_alchemist.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shaman.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/failed_alchemist_b.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_neutral.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= { "data/entities/animals/wizard_twitchy.xml", "data/entities/animals/wizard_poly.xml" },
		ngpluslevel = 2,
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/hpcrystal.xml",
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
		max_count	= 2,    
		entity 	= "data/entities/props/physics_lantern.xml"
	},
}

g_props =
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
		prob   		= 0.8,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 5,
		entity 	= "data/entities/props/physics_bed.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_crate.xml"
	},
}

g_props2 =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 5,
		entity 	= "data/entities/props/banner.xml"
	},
}

g_bottle =
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

g_chest =
{
	total_prob = 0,
	{
		prob   		= 0.6,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/chest.xml"
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

g_statues =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_01.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_02.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_03.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_04.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_05.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_06.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_07.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_08.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_09.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_10.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_11.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/statues/statue_rock_12.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/statue_trap_right.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/statue_trap_left.xml"
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/container_01.png",
		visual_file		= "data/biome_impl/liquidcave/container_01_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "oil", "alcohol", "lava", "magic_liquid_teleportation", "magic_liquid_protection_all", "material_confusion", "liquid_fire" } }
	},
}

g_background_panel_big =
{
	total_prob = 0,
	{
		prob   			= 0.2,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_01.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_02.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_03.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_04.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_05.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_06.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_07.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/liquidcave/background_panel_big_material.png",
		visual_file		= "",
		background_file	= "data/biome_impl/liquidcave/background_panel_big_08.png",
		is_unique		= 0
	},
}

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
end

function spawn_lamp( x, y )
	spawn(g_lamp,x,y+4,0,0)
end
 
function spawn_props( x, y ) 
	spawn(g_props,x,y,0,0)
end
 
function spawn_props2( x, y ) 
	spawn(g_props2,x,y,0,0)
end

function spawn_bottle( x, y ) 
	spawn(g_bottle,x,y,0,0)
end

function spawn_chest(x, y)
	return
end

function spawn_shopkeeper(x, y)
end

function spawn_items( x, y ) end
function spawn_props3( x, y ) end
function spawn_blood( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_save( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_persistent_teleport( x, y ) end
function spawn_candles( x, y ) end
function init( x, y ) end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x-5, y-3 )
end

function load_background_panel_big( x, y )
	load_random_pixel_scene( g_background_panel_big, x, y )
end

function spawn_lasergun( x, y )
	EntityLoad( "data/entities/buildings/lasergun.xml", x + 5, y + 5 )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_statues(x, y)
	spawn(g_statues,x+5,y-10)
end

function spawn_potions(x, y)
	spawn_from_list( "potion_spawnlist_liquidcave", x, y )
end