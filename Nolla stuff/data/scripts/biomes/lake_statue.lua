-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xfff21df0, "load_building_stash" )
RegisterSpawnFunction( 0xffb4a00a, "spawn_fish" )
RegisterSpawnFunction( 0xffb40b76, "spawn_bigfish" )
RegisterSpawnFunction( 0xff3ae124, "spawn_small_animals" )
RegisterSpawnFunction( 0xff31d0b4, "spawn_essence" )
RegisterSpawnFunction( 0xff30D14E, "spawn_secret_checker" )

g_fish =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/fish.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
}

g_small_animals =
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
		max_count	= 3,    
		entity 	= "data/entities/animals/deer.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/duck.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/elk.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 2,
		max_count	= 5,    
		entity 	= "data/entities/animals/sheep.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wolf.xml"
	},
}

g_hiisi =
{
	total_prob = 0,
	{
		prob   		= 0.3,
		min_count	= 2,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/miner_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/miner_fire.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/shotgunner.xml"
	},
		{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/drunk/miner.xml",
			"data/entities/animals/drunk/miner.xml",
			"data/entities/animals/drunk/shotgunner.xml",
		}
	},
	{
		prob   		= 0.12,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/shotgunner.xml"
	},
		{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/drunk/scavenger_grenade.xml",
			"data/entities/animals/drunk/scavenger_smg.xml",
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			{
				min_count	= 1,
				max_count	= 2,
				entity	= "data/entities/animals/drunk/scavenger_grenade.xml",
			},
			{
				min_count	= 0,
				max_count	= 2,
				entity	= "data/entities/animals/drunk/scavenger_smg.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/sniper.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/miner.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/shotgunner.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/scavenger_heal.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drone_lasership.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/scavenger_leader.xml",
		ngpluslevel = 2,
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			{
				min_count	= 0,
				max_count	= 1,
				entity	= "data/entities/animals/drunk/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count	= 2,
				entity	= "data/entities/animals/drunk/scavenger_smg.xml",
			},
		}
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_lantern_small.xml"
	},
}

function spawn_small_enemies( x, y ) end
function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props( x, y ) end
function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function spawn_chest( x, y ) end
function spawn_blood( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_save( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_persistent_teleport( x, y ) end
function spawn_candles( x, y ) end

function init( x, y, w, h )
	--LoadPixelScene( "data/biome_impl/lake_statue.png", "", x, y, "", true )
end

function is_jussi() 
	local year, month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
	return jussi
end

function spawn_lamp( x, y ) 
	-- jussi
	if( is_jussi() ) then
		LoadPixelScene( "data/biome_impl/fire_5x5.png", "", x-2, y-2 )
	end
end


function load_building_stash( x, y )
end

function spawn_orb(x, y)
	EntityLoad( "data/entities/items/orbs/orb_01.xml", x-16, y )
	EntityLoad( "data/entities/items/books/book_02.xml", x+16, y )
end

function spawn_bigfish(x,y)
	EntityLoad( "data/entities/animals/eel.xml", x, y )
end

function spawn_small_animals(x,y)
	spawn( g_small_animals, x, y )
	-- if Jussi
	if( is_jussi() ) then
		spawn( g_hiisi, x, y )
		-- effect_drunk_forever.xml
		local r = ProceduralRandom( x-11.631, y+10.2257 )
		if( r >= 0.1 ) then EntityLoad( "data/entities/items/easter/beer_bottle.xml", x, y ) end
		if( r >= 0.3 ) then EntityLoad( "data/entities/items/easter/beer_bottle.xml", x+5, y-5 ) end
		if( r >= 0.6 ) then EntityLoad( "data/entities/items/easter/beer_bottle.xml", x+10, y-10 ) end
		if( r >= 0.9 ) then EntityLoad( "data/entities/items/easter/beer_bottle.xml", x+15, y-15 ) end
	end
end

function spawn_fish(x, y)
	spawn(g_fish,x,y)
end

function spawn_essence(x, y)
	EntityLoad( "data/entities/items/pickup/essence_fire.xml", x, y )
end

function spawn_secret_checker( x, y )

	local entity = EntityLoad( "data/entities/buildings/lake_statue_materialchecker.xml", x, y )

	local material1 = CellFactory_GetType( "blood" )
	local material2 = -1
	
	local comp_mat = EntityGetFirstComponent( entity, "MaterialAreaCheckerComponent" )
	if comp_mat ~= nil then
		ComponentSetValue( comp_mat, "material", tostring(material1) )
		ComponentSetValue( comp_mat, "material2", tostring(material2) )
	end

	local comp_lua = EntityGetFirstComponent( entity, "LuaComponent" )
	if comp_lua ~= nil then
		ComponentSetValue( comp_lua, "script_material_area_checker_success", "data/scripts/biomes/lake_statue.lua" )
	end

end

function material_area_checker_success( x, y )
	GameScreenshake( 100 )
	EntityLoad( "data/entities/buildings/teleport_desert.xml", x, y - 300 )
	
	GamePrintImportant( "$log_fasttravel", "$logdesc_fasttravel" )
end