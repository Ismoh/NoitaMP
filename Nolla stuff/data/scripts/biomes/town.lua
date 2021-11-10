-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffFF3CFF, "spawn_chair" )
RegisterSpawnFunction( 0xffFF1EFF, "spawn_table" )
RegisterSpawnFunction( 0xffFF1E80, "spawn_bottle" )
RegisterSpawnFunction( 0xff46B428, "spawn_shopkeeper" )

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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/zombie_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/slimeshooter_weak.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/longleg.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner_weak.xml"
	},
}

g_shopkeeper =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_civilian_shopkeeper.xml"
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

g_chair =
{
	total_prob = 0,
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_chair_1.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_chair_2.xml"
	},
}

g_table =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_table.xml"
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


function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_lamp( x, y )
	spawn(g_lamp,x+2,y,0,0)
end
 
function spawn_props( x, y ) 
	spawn(g_props,x,y,0,0)
end

 
function spawn_props2( x, y ) 
	spawn(g_props2,x,y,0,0)
end

function spawn_chair( x, y ) 
	spawn(g_chair,x,y,0,0)
end

function spawn_table( x, y ) 
	spawn(g_table,x,y,0,0)
end

function spawn_bottle( x, y ) 
	spawn(g_bottle,x,y,0,0)
end

function spawn_chest(x, y)
	return
end

function spawn_shopkeeper(x, y)
end

function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props3( x, y ) end
function spawn_blood( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_save( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_persistent_teleport( x, y ) end
function spawn_candles( x, y ) end
function init( x, y ) end