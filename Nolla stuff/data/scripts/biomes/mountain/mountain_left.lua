-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biomes/mountain/mountain.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/mountain/left_bottom.png", "", x, y + 512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/left.png", "data/biome_impl/mountain/left_visual.png", x, y, "data/biome_impl/mountain/left_background.png", true )
end