-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )
dofile( "data/scripts/biomes/temple_shared.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff6d934c, "spawn_hp" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xff33935F, "spawn_cheap_shopitem" )
RegisterSpawnFunction( 0xff10822d, "spawn_workshop" )
RegisterSpawnFunction( 0xff5a822d, "spawn_workshop_extra" )
RegisterSpawnFunction( 0xffFAABBA, "spawn_motordoor" )
RegisterSpawnFunction( 0xffFAABBB, "spawn_pressureplate" )
RegisterSpawnFunction( 0xffFF5A0A, "spawn_music_trigger" )
RegisterSpawnFunction( 0xff667e0a, "spawn_duplicator" )
RegisterSpawnFunction( 0xff03DEAD, "spawn_areachecks" )
RegisterSpawnFunction( 0xffc128ff, "spawn_rubble" )
RegisterSpawnFunction( 0xffa7a707, "spawn_lamp_long" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
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

g_fish =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 4,    
		entity 	= "data/entities/animals/fish.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
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

g_vines =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_long.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
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
	temple_random( x, y )
	
	-- LoadPixelScene( "data/biome_impl/temple/wall_top.png", "", x, y-30, "data/biome_impl/temple/wall_top_background.png", true )
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x, y - 30, 35 )
	
	LoadPixelScene( "data/biome_impl/temple/altar_top.png", "", x, y-40, "", true )
	LoadPixelScene( "data/biome_impl/temple/altar_left.png", "data/biome_impl/temple/altar_left_visual.png", x, y-40+300, "data/biome_impl/temple/altar_left_background.png", true )
end

function spawn_hp( x, y )
end

function spawn_shopitem( x, y )
end

function spawn_cheap_shopitem( x, y )
end

function spawn_workshop( x, y )
end

function spawn_workshop_extra( x, y )
end

function spawn_motordoor( x, y )
end

function spawn_pressureplate( x, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp,x,y,0,15)
end

function spawn_music_trigger( x, y )
	--EntityLoad( "data/entities/buildings/music_trigger_temple_left.xml", x, y )
end

function spawn_duplicator( x, y )
	-- EntityLoad( "data/entities/buildings/temple_duplicator.xml", x, y )
end

function spawn_areachecks( x, y )
end

function spawn_rubble(x, y)
	spawn(g_rubble,x,y,5,0)
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_statue( x, y )
	EntityLoad( "data/entities/props/temple_statue_01.xml", x , y )
end

function spawn_fish(x, y)
	local f = GameGetOrbCountAllTime()
	
	for i=1,f do
		EntityLoad( "data/entities/animals/fish.xml", x, y )
	end
end