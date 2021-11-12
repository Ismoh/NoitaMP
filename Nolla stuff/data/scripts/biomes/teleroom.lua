CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffa9d024, "spawn_tele1" )
RegisterSpawnFunction( 0xffb9d024, "spawn_tele2" )
RegisterSpawnFunction( 0xffc9d024, "spawn_tele3" )
RegisterSpawnFunction( 0xffd9d024, "spawn_tele4" )
RegisterSpawnFunction( 0xffe9d024, "spawn_tele5" )
RegisterSpawnFunction( 0xfff9d024, "spawn_tele6" )

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
	LoadPixelScene( "data/biome_impl/teleroom.png", "", x, y, "", true )
end

function spawn_orb(x, y)
end

function spawn_tele1(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_1.xml", x, y )
end

function spawn_tele2(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_2.xml", x, y )
end

function spawn_tele3(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_3.xml", x, y )
end

function spawn_tele4(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_4.xml", x, y )
end

function spawn_tele5(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_5.xml", x, y )
end

function spawn_tele6(x, y)
	EntityLoad( "data/entities/buildings/teleport_teleroom_6.xml", x, y )
end