-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 8
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )
--dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xffbe704d, "spawn_specialshop" )

------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/gazer.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/spitmonster.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/bloodcrystal_physics.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/worm_end.xml"
	},
	{
		prob   		= 0.004,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith.xml"
	},
	{
		prob   		= 0.001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/thunderskull.xml"
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

g_small_enemies_sky =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/skygazer.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/spearbot.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/skycrystal_physics.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/worm_skull.xml"
	},
	{
		prob   		= 0.004,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_storm.xml"
	},
	{
		prob   		= 0.001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/thunderskull.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/wizard_tele.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage_big.xml"
	},
}

g_big_enemies_sky =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
}


------------ items -------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_04.xml"
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_torch_stand.xml"
	},
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= ""
	},
	--[[
	These are very buggy, commented out for now
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/buildings/spike.xml"
	},
	]]--
}

g_unique_enemy =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 2,		
		entity 	= "data/entities/buildings/arrowtrap_right.xml"
	},
}

g_large_enemies =
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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,  
		offset_x	= 1,
		entity 	= "data/entities/buildings/arrowtrap_left.xml"
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cathedral.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/mining.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
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
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	if ( y > -7000 ) then
		spawn(g_small_enemies,x,y)
	else
		spawn(g_small_enemies_sky,x,y)
	end
end

function spawn_big_enemies(x, y)
	if ( y > -7000 ) then
		spawn(g_big_enemies,x,y)
	else
		spawn(g_big_enemies_sky,x,y)
	end
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,16,"the_end")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.38) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-10, y-17, "", true )
	end
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x+6, y-4)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+4,y,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x+5,y+5)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x-1,y,0,0)
	-- spawn_hp_mult(g_unique_enemy,x-1,y,0,0,16,"the_end")
end

function spawn_large_enemies(x, y)
	spawn(g_large_enemies,x-1,y,0,0)
	-- spawn_hp_mult(g_large_enemies,x-1,y,0,0,16,"the_end")
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene3( x, y )
end

function load_pixel_scene4( x, y )
end

function spawn_apparition() end

function spawn_potions( x, y ) end

function spawn_heart( x, y ) end

function spawn_moon( x, y )
	if ( y <= 0 ) then
		EntityLoad( "data/entities/buildings/moon_altar.xml", x, y )
	else
		EntityLoad( "data/entities/buildings/dark_moon_altar.xml", x, y )
	end
end

function spawn_wands()
end

function spawn_potion_altar()
end

function load_pixel_scene2( x, y )
end

function spawn_props2(x, y)
end

function spawn_props3(x, y)
end

function spawn_unique_enemy2(x, y)
end

function spawn_unique_enemy3(x, y)
end

function spawn_shopitem( x, y )
	if ( y > -3000 ) and ( y < 1000 ) then
		generate_shop_item( x, y, false, 0 )
	else
		SetRandomSeed( x, y )
		
		if ( Random( 1, 50 ) == 1 ) then
			generate_shop_item( x, y, false, 10 )
		end
	end
end

function spawn_specialshop( x, y )
	if ( y > -3000 ) and ( y < 1000 ) then
		generate_shop_item( x, y, false, 0 )
	else
		generate_shop_item( x, y, false, 10 )
	end
end

function spawn_stash(x,y)
end

function spawn_nest(x, y)
end

function spawn_altar_torch(x, y)
end

function spawn_chest(x, y)
	SetRandomSeed( x, y )
	local rnd = Random(1,100)
	
	if (rnd >= 99) then
		EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y)
	else
		EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y)
	end
end

function spawn_skulls(x, y) end

function spawn_trapwand(x, y)
end

function spawn_bbqbox( x, y )
end

function load_structures( x, y )
end

function load_large_structures( x, y )
end

function load_i_structures( x, y )
end

function load_oiltank( x, y )
end

function load_oiltank_alt( x, y )
end

function load_altar( x, y )
end