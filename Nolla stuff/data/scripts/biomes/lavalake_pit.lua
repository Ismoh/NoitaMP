-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffbf262b, "spawn_metportal" )

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
		entity 	= "data/entities/items/wand_level_03.xml"
	},
}

function spawn_stash(x,y)
	-- 20% air
	if( ProceduralRandom(x,y) < 0.17 ) then
		return
	end
	entity_load_stash(x,y)
end

function spawn_wands(x, y)
	spawn(g_items,x,y,0,0)
end

function init( x, y, w, h )
	if y > 2000 and y < 2400 then
		LoadPixelScene( "data/biome_impl/lavalake_pit_cracked.png", "", x, y, "", true )
	else
		LoadPixelScene( "data/biome_impl/lavalake_pit.png", "", x, y, "", true )
	end
end

function spawn_metportal( x, y )
	EntityLoad( "data/entities/buildings/teleport_lavalake.xml", x, y )
end