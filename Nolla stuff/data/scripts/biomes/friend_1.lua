CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff31d0b0, "spawn_fruit" )
RegisterSpawnFunction( 0xff9dd0b0, "spawn_killer" )
RegisterSpawnFunction( 0xff9dd0c0, "spawn_friend" )
RegisterSpawnFunction( 0xff9dd0d0, "spawn_tree" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )

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
function spawn_wands( x, y ) end

function init( x, y, w, h )
	SetRandomSeed( 24, 32 )
	
	if ( Random( 1, 6 ) == 1 ) then
		LoadPixelScene( "data/biome_impl/cavern.png", "", x, y, "data/biome_impl/cavern_background.png", true )
	else
		LoadPixelScene( "data/biome_impl/friendroom.png", "", x, y, "", true )
	end
end

function spawn_orb(x, y)
end

function spawn_fruit( x, y )
	EntityLoad( "data/entities/items/pickup/gourd.xml", x, y )
end

function spawn_killer( x, y )
	EntityLoad( "data/entities/animals/ultimate_killer.xml", x, y )
end

function spawn_friend( x, y )
	EntityLoad( "data/entities/animals/friend.xml", x, y )
end

g_trees =
{
	total_prob = 0,
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_x	= -10,
		offset_y	= -113,
		entity 	= "data/entities/props/rainforest_tree_01.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -4,
		offset_y	= -30,
		]]--
		entity 	= "data/entities/props/rainforest_tree_02.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -7,
		offset_y	= -32,
		]]--
		entity 	= "data/entities/props/rainforest_tree_03.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -31,
		offset_y	= -93,
		]]--
		entity 	= "data/entities/props/rainforest_tree_04.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -24,
		offset_y	= -84,
		]]--
		entity 	= "data/entities/props/rainforest_tree_05.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		--[[
		offset_x	= -3,
		offset_y	= -84,
		]]--
		entity 	= "data/entities/props/rainforest_tree_06.xml"
	},
}

g_vines =
{
	total_prob = 0,
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
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
	{
		prob   		= 3.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/root/hanging_root_random.xml"
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/lantern_small.xml"
	},
}

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,0)
end

function spawn_tree(x, y)
	spawn(g_trees,x,y,0,0)
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
	-- chance for an extra spawn for denser vineage
	if ProceduralRandomf(x, y) < 0.5 then
		spawn(g_vines,x,y+5)
	end
end