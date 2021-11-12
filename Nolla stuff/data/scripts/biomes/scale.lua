CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff31d0b4, "spawn_rock1" )
RegisterSpawnFunction( 0xffadd0b4, "spawn_rock2" )
RegisterSpawnFunction( 0xffad5cb4, "spawn_prize" )

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
	local pw = check_parallel_pos( x )
	
	if ( pw == 0 ) and ( HasFlagPersistent( "progress_sun" ) or HasFlagPersistent( "progress_darksun" ) ) then
		LoadPixelScene( "data/biome_impl/overworld/scale.png", "", x + 100, y + 382, "", true )
	else
		LoadPixelScene( "data/biome_impl/overworld/scale_old.png", "", x + 100, y + 382, "", true )
	end
end

function spawn_orb(x, y)
end

function spawn_rock1(x, y)
	if HasFlagPersistent( "progress_sun" ) then
		EntityLoad( "data/entities/props/physics_sun_rock.xml", x, y )
	end
end

function spawn_rock2(x, y)
	if HasFlagPersistent( "progress_darksun" ) then
		EntityLoad( "data/entities/props/physics_darksun_rock.xml", x, y )
	end
end

function spawn_prize(x, y)
	if ( HasFlagPersistent( "progress_sun" ) and HasFlagPersistent( "progress_darksun" ) ) and ( HasFlagPersistent( "card_unlocked_black_hole" ) == false ) then
		CreateItemActionEntity( "BLACK_HOLE_GIGA", x, y )
	end
end