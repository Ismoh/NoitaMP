CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff31d0b4, "spawn_essence" )

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
	LoadPixelScene( "data/biome_impl/essenceroom.png", "data/biome_impl/essenceroom_visual.png", x, y, "data/biome_impl/essenceroom_background_with_diamond.png", true )
end

function spawn_orb(x, y)
end

function spawn_essence(x, y)
	EntityLoad( "data/entities/items/wands/wand_good/wand_good_1.xml", x - 20, y + 12 )
	EntityLoad( "data/entities/items/wands/wand_good/wand_good_2.xml", x, y + 12 )
	EntityLoad( "data/entities/items/wands/wand_good/wand_good_3.xml", x + 20, y + 12 )
	EntityLoad( "data/entities/buildings/mystery_teleport_back.xml", x, y - 200 )
end