-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

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
	SetRandomSeed( x, y )
	local randomtop = Random(1, 50)
	
	if (randomtop == 5) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", "", x, y-40, "", true )
	elseif (randomtop == 8) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", "", x, y-40, "", true )
	elseif (randomtop == 11) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", "", x, y-40, "", true )
	elseif (randomtop == 13) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", "", x, y-40, "", true )
	elseif (randomtop == 15) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", "", x, y-40, "", true )
	else
		LoadPixelScene( "data/biome_impl/temple/altar_top.png", "", x, y-40, "", true )
	end
	
	LoadPixelScene( "data/biome_impl/temple/solid.png", "", x, y-40+300, "", true )
end

function spawn_portal( x, y )
	EntityLoad( "data/entities/buildings/teleport_end_wall.xml", x, y )
end