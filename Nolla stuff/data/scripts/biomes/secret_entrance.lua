-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )

function init( x, y, w, h )
	print( "end init called: " .. x .. ", " .. y )
	LoadPixelScene( "data/biome_impl/secret_entrance.png", "data/biome_impl/secret_entrance_visual.png", x, y, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_bottom.png", "", x, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/inside_bottom_right.png", "", x, y-512, "", true )
end

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/drone_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/lasershooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/roboguard.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/assassin.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/acidshooter.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 3,
		max_count	= 5,    
		entity 	= "data/entities/animals/blob.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/bigzombie.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/sniper.xml",
			"data/entities/animals/flamer.xml",
		}
	},
}

g_candles =
{
	total_prob = 0,
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_1.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_2.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_3.xml"
	},
}

function spawn_lamp2(x, y)
	spawn(g_lamp2,x-1,y+18,0,0)
end

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function spawn_lamp(x, y)
	return
end

function spawn_potions( x, y ) end