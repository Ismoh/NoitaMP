-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biomes/mountain/mountain.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/mountain/hall_3_long.png", "data/biome_impl/mountain/hall_3_long_visual.png", x, y, "data/biome_impl/mountain/hall_3_long_background.png", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_3_top.png", "", x, y-512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_3_bottom.png", "", x, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/inside_bottom_right.png", "", x + 512, y - 512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/inside_bottom_left.png", "", x, y - 512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/inside_top_right.png", "", x, y - 1024, "", true )
	LoadPixelScene( "data/biome_impl/mountain/inside_top_left.png", "", x, y - 1024, "", true )
end

function spawn_persistent_teleport(x, y)
	--spawn(g_persistent_teleport,x,y,0,0)
end