-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )
dofile( "data/scripts/biomes/temple_shared.lua" )
dofile( "data/scripts/perks/perk.lua" )
dofile_once("data/scripts/biomes/temple_altar_top_shared.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff6d934c, "spawn_hp" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xff33935F, "spawn_cheap_shopitem" )
RegisterSpawnFunction( 0xff10822d, "spawn_workshop" )
RegisterSpawnFunction( 0xff5a822d, "spawn_workshop_extra" )
RegisterSpawnFunction( 0xffFAABBA, "spawn_motordoor" )
RegisterSpawnFunction( 0xffFAABBB, "spawn_pressureplate" )
RegisterSpawnFunction( 0xffA85454, "spawn_control_workshop" )
RegisterSpawnFunction( 0xff03DEAD, "spawn_areachecks" )
RegisterSpawnFunction( 0xff7345DF, "spawn_perk_reroll" )
RegisterSpawnFunction( 0xffc128ff, "spawn_rubble" )
RegisterSpawnFunction( 0xffa7a707, "spawn_lamp_long" )
RegisterSpawnFunction( 0xff9f2a00, "spawn_statue" )

g_lamp =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/temple_lantern.xml"
	},
}

g_rubble =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 2.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_01.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_02.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_03.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_04.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_05.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_06.xml"
	},
}

function spawn_small_enemies( x, y ) end
function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props( x, y ) end
function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_candles( x, y ) end
function spawn_potions( x, y ) end

function init( x, y, w, h )
	spawn_altar_top(x, y, false)

	LoadPixelScene( "data/biome_impl/temple/altar_right.png", "data/biome_impl/temple/altar_right_visual.png", x, y-40+300, "data/biome_impl/temple/altar_right_background.png", true )
	LoadPixelScene( "data/biome_impl/temple/altar_right_extra.png", "", x, y-40+300+282, "", true )
end

function spawn_hp( x, y )
	EntityLoad( "data/entities/items/pickup/heart_fullhp_temple.xml", x, y )
end

function spawn_shopitem( x, y )
	EntityLoad( "data/entities/items/shop_item.xml", x, y )
end

function spawn_shopitem( x, y )
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item( x, y, false )
end

function spawn_cheap_shopitem( x, y )
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item( x, y, true )
end


function spawn_workshop( x, y )
	EntityLoad( "data/entities/buildings/workshop.xml", x, y )
	EntityLoad( "data/entities/buildings/workshop_show_hint.xml", x, y )
end

function spawn_workshop_extra( x, y )
	EntityLoad( "data/entities/buildings/workshop_allow_mods.xml", x, y )
end

function spawn_motordoor( x, y )
	EntityLoad( "data/entities/props/physics_templedoor2.xml", x, y )
end

function spawn_pressureplate( x, y )
	EntityLoad( "data/entities/props/temple_pressure_plate.xml", x, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp,x,y,0,15)
end

function spawn_control_workshop(x,y)
	EntityLoad( "data/entities/buildings/workshop_exit.xml", x, y )
end

function spawn_all_perks( x, y )
	print( "ERROR! Spawn_all_perks should not be called from here!")

	--[[
	SetRandomSeed( x, y )
	
	if( GlobalsGetValue( "TEMPLE_SPAWN_GUARDIAN" ) == "1" ) then
		EntityLoad( "data/entities/misc/spawn_necromancer_shop.xml", x + 30, y - 30 )
	end

	local spawn_shop, do_spawn_perks = temple_random( x, y )
	if( do_spawn_perks == "0" ) then
		return
	end
	
	perk_spawn_many( x, y )
	]]--
end

function spawn_perk_reroll( x, y )
	EntityLoad( "data/entities/items/pickup/perk_reroll.xml", x, y )
end

function spawn_areachecks( x, y )
	
	if( temple_should_we_spawn_checkers( x, y ) ) then
		EntityLoad( "data/entities/buildings/temple_areacheck_horizontal.xml", x - 190 - 24, y - 69 - 20 )
		EntityLoad( "data/entities/buildings/temple_areacheck_horizontal.xml", x - 190 + 32, y + 140 + 12 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y + 50 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y + 100 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 69 + 32 - 16, y - 69 - 20 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 69 + 32 - 16, y - 69  )
		-- EntityLoad( "data/entities/buildings/temple_areacheck_vertical.xml", x - 120, y )
	end

end

function spawn_rubble(x, y)
	spawn(g_rubble,x,y,5,0)
end

function spawn_statue( x, y )
	EntityLoad( "data/entities/props/temple_statue_02.xml", x , y )
end
