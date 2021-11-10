-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffff5a0f, "spawn_music_trigger" )
RegisterSpawnFunction( 0xffff5b5f, "spawn_corpse" )

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
function init( x, y, w, h ) end
function spawn_wands() end

function spawn_music_trigger( x, y )
	EntityLoad( "data/entities/buildings/music_trigger_lavalake.xml", x, y )
end

function spawn_orb(x, y)
	EntityLoad( "data/entities/items/orbs/orb_03.xml", x-10, y )
	-- EntityLoad( "data/entities/items/pickup/heart_better.xml", x + 5, y )
	EntityLoad( "data/entities/items/books/book_03.xml", x + 20, y )
end

function spawn_corpse( x, y )
	EntityLoad( "data/entities/props/physics_skull_01.xml", x, y-4 )
	EntityLoad( "data/entities/props/physics_bone_01.xml", x+8, y-4 )
	EntityLoad( "data/entities/props/physics_bone_06.xml", x-12, y-4 )
	EntityLoad( "data/entities/items/books/book_corpse.xml", x, y )
end

function spawn_small_enemies( x, y )
	EntityLoad( "data/entities/animals/fireskull.xml", x, y )
end

