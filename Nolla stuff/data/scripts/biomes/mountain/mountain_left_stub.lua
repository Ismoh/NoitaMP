-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biomes/mountain/mountain.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function spawn_wands( x, y ) end

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/mountain/left_stub.png", "", x, y, "data/biome_impl/mountain/left_stub_background.png", true )
	LoadPixelScene( "data/biome_impl/mountain/left_entrance_below.png", "", x+512, y, "data/biome_impl/mountain/left_entrance_below_background.png", true )
end