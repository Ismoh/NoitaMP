-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff548f77, "spawn_teleport" )
RegisterSpawnFunction( 0xff709615, "spawn_chest" )


------------ ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/vault/roboguard.xml",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/assassin.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/monk.xml"
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/spearbot.xml"
	},
}


------------ ITEMS ------------------------------------------------------------

g_lamp =
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
		prob   		= 0.8,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/lantern_small.xml"
	},
}

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

function init(x, y, w, h)
	LoadPixelScene( "data/biome_impl/robot_egg.png", "data/biome_impl/robot_egg_visual.png", x, y, "data/biome_impl/robot_egg_background.png", true )
end

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies,x,y)
end

function spawn_items(x, y)
	spawn(g_items,x,y)
end

function spawn_unique_enemy(x, y) end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+6,0,0)
end

function spawn_props(x, y) end

function spawn_potions( x, y ) end

function spawn_teleport(x, y)
	EntityLoad("data/entities/buildings/teleport_robot_egg_return.xml", x, y)
end

function spawn_chest(x, y)
	EntityLoad("data/entities/buildings/chest_steel.xml", x, y)
end
