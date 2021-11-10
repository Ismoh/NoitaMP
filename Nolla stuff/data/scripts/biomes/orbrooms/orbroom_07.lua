-- location: lava lake

CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/biomes/orbrooms/orbroom_shared.lua" )
-- the one after the lavalake

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
	LoadPixelScene( "data/biome_impl/orbroom.png", "data/biome_impl/orbroom_visual.png", x, y, "data/biome_impl/orbroom_background.png", true )
	
	EntityLoad( "data/entities/misc/orb_07_pitcheck_b.xml", x - 64, y + 256 )
end

------------------------------------------------------------------------


------------------------------------------------------------------------

function spawn_orb(x, y)
	EntityLoad( "data/entities/items/orbs/orb_07.xml", x, y )
	EntityLoad( "data/entities/misc/orb_07_pitcheck_a.xml", x, y )
	--EntityLoad( "data/entities/items/pickup/heart_better.xml", x + 30, y - 20 )
	EntityLoad( "data/entities/items/books/book_07.xml", x - 30, y + 40 )
	EntityLoad( "data/entities/misc/music_energy_000.xml", x, y - 10 )

	spawn_material_checker( x - 197, y - 11, "slime", "data/scripts/biomes/orbrooms/orbroom_shared.lua", "data/particles/image_emitters/orbrooms/05_02.xml", x, y - 100 )
	spawn_material_checker( x + 198, y - 11, "slime", "data/scripts/biomes/orbrooms/orbroom_shared.lua", "data/particles/image_emitters/orbrooms/05_02.xml", x, y - 100 )

	-- EntityLoad( "data/entities/buildings/orb_room_materialchecker.xml", x - 197, y - 11 )
	-- EntityLoad( "data/entities/buildings/orb_room_materialchecker.xml", x + 198, y - 11 )

	EntityLoad( "data/entities/particles/gold_dust.xml", x, y )
end