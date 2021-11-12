-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xffC8C800, "spawn_lamp" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff03deaf, "spawn_fish" )
RegisterSpawnFunction( 0xffff2974, "spawn_hourglass_blood" )
RegisterSpawnFunction( 0xffff9122, "spawn_hourglass_master" )
RegisterSpawnFunction( 0xff216bff, "spawn_hourglass_music_trigger" )

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


g_props =
{
	total_prob = 0,
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_propane_tank.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,  
		offset_y 	= -8,
		entity 	= "data/entities/props/physics_seamine.xml"
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
		offset_y	= 10,
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}


g_vines =
{
	total_prob = 0,
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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
	},
}

g_fish =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 2,
		max_count	= 5,    
		entity 	= "data/entities/animals/fish.xml"
	},
}

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	-- the pixel scene spawns to left or right by random
	local is_right = ProceduralRandom(0,0) > 0.5

	-- don't spawn when looping around world to avoid incorrect placement
	if x > 10000 or x < -10000 then return end

	if is_right and x > 0 then
		LoadPixelScene( "data/biome_impl/snowcastle/side_cavern_right.png", "data/biome_impl/snowcastle/side_cavern_right_visual.png", x-50, y, "data/biome_impl/snowcastle/side_cavern_right_background.png", true )
	elseif not is_right and x < 0 then
		LoadPixelScene( "data/biome_impl/snowcastle/side_cavern_left.png", "data/biome_impl/snowcastle/side_cavern_left_visual.png", x+50, y, "data/biome_impl/snowcastle/side_cavern_left_background.png", true )
	end
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, nil )
end

function spawn_small_enemies(x, y) end
function spawn_big_enemies(x, y) end
function spawn_unique_enemy(x, y) end
function spawn_items(x, y) end

function spawn_lamp(x, y) spawn(g_lamp,x,y,0,0) end
function spawn_props(x, y) spawn(g_props,x,y-3,0,0)	end

function spawn_vines(x, y) spawn(g_vines,x+5,y+5) end
function spawn_barricade(x, y) spawn(g_barricade,x,y,0,0) end
function spawn_fish(x, y) spawn(g_fish,x,y,0,0) end

function spawn_hourglass_blood(x, y)
	EntityLoad( "data/entities/buildings/hourglass_blood.xml", x, y )
end

function spawn_hourglass_master(x, y)
	EntityLoad( "data/entities/buildings/hourglass_master.xml", x, y )
	EntityLoad( "data/entities/buildings/teleport_hourglass.xml", x, y )
end

function spawn_hourglass_music_trigger(x, y)
	-- NOTE: this has a separate spawnto keep area symmetrical if scene spawns on the other side
	EntityLoad( "data/entities/buildings/hourglass_music.xml", x, y )
end
