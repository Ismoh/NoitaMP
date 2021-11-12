-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/biomes/temple_shared.lua" )
dofile( "data/scripts/perks/perk.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff6d934c, "spawn_hp" )
RegisterSpawnFunction( 0xff33934c, "spawn_all_shopitems" )
-- RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
-- RegisterSpawnFunction( 0xff33935F, "spawn_cheap_shopitem" )
RegisterSpawnFunction( 0xff10822d, "spawn_workshop" )
RegisterSpawnFunction( 0xff5a822d, "spawn_workshop_extra" )
RegisterSpawnFunction( 0xffFAABBA, "spawn_motordoor" )
RegisterSpawnFunction( 0xffFAABBB, "spawn_pressureplate" )
RegisterSpawnFunction( 0xff03DEAD, "spawn_areachecks" )
RegisterSpawnFunction( 0xff03deaf, "spawn_fish" )
RegisterSpawnFunction( 0xff784dd2, "spawn_worm_deflector" )
RegisterSpawnFunction( 0xff7345DF, "spawn_perk_reroll" )
RegisterSpawnFunction( 0xff420A3D, "spawn_trigger_check_stats" )
RegisterSpawnFunction( 0xff420a3f, "spawn_trigger_check_stats_reference" )
RegisterSpawnFunction( 0xffc128ff, "spawn_rubble" )
RegisterSpawnFunction( 0xffa7a707, "spawn_lamp_long" )
RegisterSpawnFunction( 0xff03fade, "spawn_spell_visualizer" )


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
	{
		prob   		= 5.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 2,
		max_count	= 5,    
		entity 	= "data/entities/animals/fish.xml"
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
	temple_random( x, y )

	SetRandomSeed( x, y )
	local randomtop = Random(1, 50)
	
	-- LoadPixelScene( "data/biome_impl/temple/wall_top.png", "", x, y-30, "data/biome_impl/temple/wall_top_background.png", true )
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x, y - 30, 35 )
	
	if (randomtop == 5) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", "", x, y-40, "", true )
	elseif (randomtop == 8) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", "", x, y-40, "", true )
	elseif (randomtop == 11) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", "", x, y-40, "", true )
	elseif (randomtop == 13) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", "", x, y-40, "", true )
	elseif (randomtop == 15) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", "", x, y-40, "", true )
	else
		LoadPixelScene( "data/biome_impl/temple/altar_top.png", "", x, y-40, "", true )
	end
	
	LoadPixelScene( "data/biome_impl/temple/altar_empty.png", "data/biome_impl/temple/altar_empty_visual.png", x, y-40+300, "data/biome_impl/temple/altar_background.png", true )
end

function spawn_hp( x, y )

end

function spawn_shopitem( x, y )
end

function spawn_cheap_shopitem( x, y )
end

function spawn_all_shopitems( x, y )
end

function spawn_workshop( x, y )
end

function spawn_workshop_extra( x, y )
	-- EntityLoad( "data/entities/buildings/workshop_allow_mods.xml", x, y )
end

function spawn_motordoor( x, y )
	-- EntityLoad( "data/entities/props/physics_templedoor2.xml", x, y )
end

function spawn_pressureplate( x, y )
	-- EntityLoad( "data/entities/props/temple_pressure_plate.xml", x, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp,x,y,0,15)
end

function spawn_areachecks( x, y )
end

function spawn_worm_deflector( x, y )
	-- EntityLoad( "data/entities/buildings/physics_worm_deflector.xml", x, y )
	EntityLoad( "data/entities/buildings/physics_worm_deflector_crystal.xml", x, y + 5 )
	EntityLoad( "data/entities/buildings/physics_worm_deflector_base.xml", x, y + 5 )
end

function spawn_all_perks( x, y )
end

function spawn_perk_reroll( x, y )
	EntityLoad( "data/entities/items/pickup/perk_reroll.xml", x, y )
end

function spawn_trigger_check_stats( x, y )
	-- EntityLoad( "data/entities/buildings/workshop_trigger_check_stats.xml", x, y )
end

function spawn_trigger_check_stats_reference( x, y )
	-- EntityLoad( "data/entities/buildings/workshop_trigger_check_stats_reference.xml", x, y )
end

function spawn_fish(x, y)
	spawn(g_fish,x,y)
end

function spawn_rubble(x, y)
	spawn(g_rubble,x,y,5,0)
end

function spawn_spell_visualizer( x, y )
	EntityLoad( "data/entities/buildings/workshop_spell_visualizer.xml", x, y )
	EntityLoad( "data/entities/buildings/workshop_aabb.xml", x, y )
end
