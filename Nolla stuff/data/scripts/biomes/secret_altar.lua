-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )

g_small_enemies =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/chest_secret.xml"
	},
}

g_lamp2 =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,   
		offset_x	= 5,
		offset_y	= 6,
		entity 	= "data/entities/props/physics_chandelier.xml"
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
	spawn(g_lamp2,x-1,y,0,0)
end

function spawn_small_enemies(x, y)
	spawn(g_small_enemies,x,y)
end

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/secret_altar.png", "", x, y, "", true )
	local book_boss = EntityLoad( "data/entities/animals/boss_book/book_physics.xml", x + 100, y + 100 )
end

function spawn_potions( x, y ) end