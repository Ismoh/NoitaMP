-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biomes/mountain/mountain.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffffd1a1, "spawn_sampo_spot" )

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/mountain/floating_island.png", "data/biome_impl/mountain/floating_island_visual.png", x, y, "", true )
end

function spawn_orb(x, y)
	EntityLoad( "data/entities/items/orbs/orb_00.xml", x, y )
	EntityLoad( "data/entities/items/books/book_00.xml", x+18, y )
end

function spawn_sampo_spot(x, y)
	EntityLoad( "data/entities/animals/boss_centipede/ending/ending_sampo_spot_mountain.xml", x, y )
end