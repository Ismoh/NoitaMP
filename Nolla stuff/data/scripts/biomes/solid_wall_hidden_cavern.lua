-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}


------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.8,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/lantern_small.xml"
	},
}

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
}

g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

g_ghostlamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
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


-- actual functions that get called from the wang generator

function init(x, y, w, h)
	-- only load the pixel scene in one of the possible locations
	local location = ProceduralRandomi(1240,-750, 3)
	local spawn = (location == 0 and y > -100 and y < 100)
		or (location == 1 and y > 8100 and y < 8300)
		or (location == 2 and y > 8600 and y < 8800)
		or (location == 3 and y > 11200 and y < 11400)

	if spawn then
		LoadPixelScene( "data/biome_impl/solid_wall_hidden_cavern.png", "", x-30, y, "", true )
	end
	
	--print("cavern spawn location id: " .. location .. ", y: " .. y)
end

function spawn_small_enemies(x, y) end

function spawn_big_enemies(x, y) end

function spawn_items(x, y) end

function spawn_unique_enemy(x, y) end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+6,0,0)
end

function spawn_props(x, y) end

function spawn_potions( x, y ) end