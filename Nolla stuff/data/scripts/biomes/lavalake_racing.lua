-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffff6630, "spawn_checkpoint_1" )
RegisterSpawnFunction( 0xff52f100, "spawn_checkpoint_2" )
RegisterSpawnFunction( 0xff9e33ff, "spawn_finish_line" )
RegisterSpawnFunction( 0xff679c00, "spawn_racing_cart" )
RegisterSpawnFunction( 0xffcaca00, "spawn_stopwatches" )
RegisterSpawnFunction( 0xffb8ffe1, "spawn_skulls" )


g_skulls =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_01.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_02.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_03.xml"
	},
}

function spawn_small_enemies( x, y ) end
function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props( x, y ) end
function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function spawn_lamp( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_candles( x, y ) end
function spawn_potions( x, y ) end
function spawn_wands(x, y) end

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/lavalake_racing.png", "", x, y, "data/biome_impl/lavalake_racing_background.png", true )
end

function spawn_racing_cart( x, y )
	EntityLoad( "data/entities/buildings/racing_cart.xml", x, y )
end

function spawn_checkpoint_1( x, y )
	local eid = EntityLoad( "data/entities/buildings/racing_checkpoint.xml", x, y )
	EntityAddTag(eid, "checkpoint_1" )
end

function spawn_checkpoint_2( x, y )
	local eid = EntityLoad( "data/entities/buildings/racing_checkpoint.xml", x, y )
	EntityAddTag(eid, "checkpoint_2" )
end

function spawn_finish_line( x, y )
	local eid = EntityLoad( "data/entities/buildings/racing_checkpoint.xml", x, y )
	EntityAddTag(eid, "finish_line" )
end

function spawn_stopwatches( x, y )
	local offset = 26
	y = y + 0.5
	local eid = EntityLoad( "data/entities/buildings/racing_stopwatch.xml", x, y )
	EntityAddTag(eid, "stopwatch_lap" )
	eid = EntityLoad( "data/entities/buildings/racing_stopwatch.xml", x + offset, y )
	EntityAddTag(eid, "stopwatch_prev_lap" )
	eid = EntityLoad( "data/entities/buildings/racing_stopwatch.xml", x + offset * 2, y )
	EntityAddTag(eid, "stopwatch_best_lap" )
end

function spawn_skulls(x, y)
	spawn(g_skulls,x,y-5)
end
