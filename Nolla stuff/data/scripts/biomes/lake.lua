-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xff667600, "spawn_teleport_back" )
RegisterSpawnFunction( 0xffb2a700, "spawn_bunker2" )
RegisterSpawnFunction( 0xffb27600, "spawn_bunker" )
RegisterSpawnFunction( 0xff390000, "spawn_alchemist" )
RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xFF5078C8, "spawn_rainbow_card")
RegisterSpawnFunction( 0xff235a15, "spawn_music_machine" )

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/zombie.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/miner.xml"
	},
	{
		prob   		= 0.025,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rat.xml"
	},
}


------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/grenadelauncher.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/machinegun.xml"
	},
	{
		prob   		= 0.001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/opgun.xml"
	},
	{
		prob   		= 0.0001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/lightninggun.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/rocketlauncher.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/shotgun.xml"
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

g_stash =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/items/pickup/heart.xml",
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

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_mining_lamp.xml"
	}
}
------------ MISC --------------------------------------

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	parallel_check( x, y )
end

function spawn_small_enemies(x, y)
	-- print("spawn_small_enemies")
	if( y < 0 ) then return 0 end
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	-- print("spawn_small_enemies")
	if( y < 0 ) then return 0 end
	-- spawn(g_big_enemies,x,y)
end

function spawn_items(x, y)
	return
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x-4,y,0,0)
end

function spawn_props(x, y)
	return
end

function spawn_potions( x, y ) end

function spawn_alchemist( x, y )
	--EntityLoad( "data/entities/animals/failed_alchemist.xml", x, y )
end

function spawn_bunker( x, y )
	EntityLoad( "data/entities/buildings/bunker.xml", x, y )
end

function spawn_bunker2( x, y )
	EntityLoad( "data/entities/buildings/bunker2.xml", x, y )
end

function spawn_teleport_back( x, y )
	EntityLoad( "data/entities/buildings/teleport_bunker_back.xml", x, y )
end

function spawn_rainbow_card( x, y )
	CreateItemActionEntity( "RAINBOW_TRAIL", x, y )
end

function spawn_music_machine( x, y )
	EntityLoad( "data/entities/props/music_machines/music_machine_02.xml", x, y )
end