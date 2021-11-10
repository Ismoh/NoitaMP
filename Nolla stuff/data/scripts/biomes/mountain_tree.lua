-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xff3461C7, "spawn_book" )
RegisterSpawnFunction( 0xff9393d2, "spawn_egg" )
RegisterSpawnFunction( 0xff3482c7, "spawn_ocarina" )
RegisterSpawnFunction( 0xff31d0b4, "spawn_secret" )
RegisterSpawnFunction( 0xffc2d0b4, "spawn_pillars" )

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
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/zombie.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/miner.xml"
	},
	{
		prob   		= 0.025,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rat.xml"
	},
}


------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

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
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/grenadelauncher.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/machinegun.xml"
	},
	{
		prob   		= 0.001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/opgun.xml"
	},
	{
		prob   		= 0.0001,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/lightninggun.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/rocketlauncher.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/shotgun.xml"
	},
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
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/slimeshooter.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/acidshooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/giantshooter.xml"
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

g_stash =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/items/pickup/heart.xml",
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

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_mining_lamp.xml"
	}
}

g_egg =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/pickup/egg_worm.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/pickup/egg_purple.xml"
	},
}

------------ MISC --------------------------------------

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	-- print("spawn_small_enemies")
	if( y < 0 ) then return 0 end
	spawn(g_small_enemies,x,y)
end

function spawn_big_enemies(x, y)
	-- print("spawn_small_enemies")
	if( y < 0 ) then return 0 end
	-- spawn(g_big_enemies,x,y)
end

function spawn_items(x, y)
	return
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+6,0,0)
end

function spawn_props(x, y)
	return
end

function spawn_potions( x, y ) end

function spawn_book( x, y ) 
	EntityLoad( "data/entities/items/books/book_tree.xml", x, y )
end

function spawn_egg( x, y )
	spawn( g_egg, x, y )
end

function spawn_ocarina( x, y )
	--local ocarina_cards = { "OCARINA_A", "OCARINA_B", "OCARINA_C", "OCARINA_D", "OCARINA_E", "OCARINA_F", "OCARINA_GSHARP", "OCARINA_A2", }
	local ocarina_cards = { "KANTELE_A", "KANTELE_D", "KANTELE_DIS", "KANTELE_E", "KANTELE_G" }
	local distance = 20
	
	for i,v in ipairs( ocarina_cards ) do
		local x_ = x - #ocarina_cards * distance * 0.5 + i * distance
		
		CreateItemActionEntity( v, x_, y )
	end
	
	for i,v in ipairs( ocarina_cards ) do
		local x_ = x - #ocarina_cards * distance * 0.5 + i * distance
		
		CreateItemActionEntity( v, x_, y + distance )
	end
	
	EntityLoad( "data/entities/items/kantele.xml", x, y - 32 )
	
	local year, month, day = GameGetDateAndTimeLocal()
	
	if ( month == 12 ) and ( day >= 23 ) and ( day <= 27 ) then
		EntityLoad( "data/entities/buildings/workshop_tree_holiday.xml", x, y )
	end
end

function spawn_secret( x, y )
	EntityLoad( "data/entities/items/pickup/greed_curse.xml", x, y )
end

function spawn_pillars( x, y )
	local count = 6
	local width = 660
	local inc = width / count
	local size = 48
	
	local under = 1
	local above = 3
	
	SetRandomSeed( x, y )
	local flags = 
	{
		{ { "misc_chest_rain", "crain" }, { "misc_worm_rain", "wrain" }, { "misc_greed_rain", "grain" }, { "misc_altar_tablet", "train" }, { "misc_monk_bots", "mbots" }, { "misc_sun_effect", "seffect" }, { "misc_darksun_effect", "dseffect" }, { "secret_tower", "secrett" }, { "player_status_ghostly", "pghost" }, { "player_status_ratty", "prat" }, { "player_status_funky", "pfungi" }, { "player_status_lukky", "plukki" }, { "player_status_halo", "phalo" } },
		{ { "essence_fire", "essencef" }, { "essence_water", "essencew" }, { "essence_laser", "essencee" }, { "essence_air", "essencea" }, { "essence_alcohol", "essenceal" }, { "secret_moon", "moon" }, { "secret_moon2", "moona" }, { "special_mood", "moong" }, { "secret_dmoon", "dmoon" }, { "dead_mood", "dmoong" }, { "secret_sun_collision", "sunmoon" }, { "secret_darksun_collision", "dsunmoon" } },
		{ { "progress_ending0", "end0" }, { "progress_ending1_toxic", "endt" }, { "progress_ending1_gold", "endb" }, { "progress_ending2", "endg" }, { "progress_newgameplusplus3", "endp" }, { "progress_nightmare", "endn" } },
		{ { "miniboss_dragon", "minid" }, { "miniboss_limbs", "minil" }, { "miniboss_ghost", "minigh" }, { "miniboss_pit", "minip" }, { "miniboss_alchemist", "minia" }, { "miniboss_robot", "minir" }, { "miniboss_wizard", "meme" }, { "miniboss_maggot", "maggot" }, { "miniboss_fish", "fish" }, { "miniboss_gate_monsters", "minigm" }, { "final_secret_orb3", "yeah3" }, { "boss_centipede", "boss" } },
		{ { "progress_orb_1", "orbf" }, { "progress_orb_evil", "orbe" }, { "progress_orb_all", "orba" }, { "progress_pacifist", "pacifist" }, { "progress_nogold", "nogold" }, { "progress_clock", "clock" }, { "progress_minit", "minit" }, { "progress_nohit", "nohit" }, { "progress_sun", "sun" }, { "progress_darksun", "dsun" }, { "progress_sunkill", "sunkill" }, { "secret_supernova", "col" } },
		{ { "secret_greed", "secretg" }, { "final_secret_orb", "yeah" }, { "final_secret_orb2", "yeah2" }, { "secret_chest_dark", "secretcd" }, { "secret_chest_light", "secretcl" }, { "card_unlocked_everything", "secretall" }, { "card_unlocked_divide", "secretten" }, { "secret_fruit", "secretf" }, { "secret_allessences", "secretae" }, { "secret_meditation", "secretme" }, { "secret_buried_eye", "secretbe" }, { "secret_hourglass", "secrethg" }, { "progress_hut_a", "huta" }, { "progress_hut_b", "hutb" }, { "secret_null", "null" } },
	}
	
	for i=1,count do
		local px = x - (count) * inc * 0.5 + (i-1) * inc
		local py = y
		
		for j=1,under do
			LoadPixelScene( "data/biome_impl/pillars/pillar_part_material.png", "", px, py, "data/biome_impl/pillars/pillar_part.png", true )
			py = py + size
		end
		
		LoadPixelScene( "data/biome_impl/pillars/pillar_part_material.png", "", px, py, "data/biome_impl/pillars/pillar_part_fade.png", true )
		
		local data = flags[i] or {}
		
		local total = above + #data
		
		py = y
		
		for j=1,above do
			py = py - size
			LoadPixelScene( "data/biome_impl/pillars/pillar_part_material.png", "", px, py, "data/biome_impl/pillars/pillar_part.png", true )
		end
		
		for j,v in ipairs(data) do
			local valid = HasFlagPersistent( v[1] )
			
			--print( "Checked for " .. tostring(v[1]) .. ", result: " .. tostring(valid) )
			
			if valid then
				py = py - size
				LoadPixelScene( "data/biome_impl/pillars/pillar_part_material.png", "", px, py, "data/biome_impl/pillars/pillar_part_" .. v[2] .. ".png", true )
			end
		end
		
		py = py - size
		local opts = { "pillar_end_01", "pillar_end_03", "pillar_end_06", "pillar_end_02", "pillar_end_05", "pillar_end_04", }
		local opt = ((i-1) % #opts) + 1
		
		LoadPixelScene( "data/biome_impl/pillars/pillar_part_material.png", "", px, py, "data/biome_impl/pillars/" .. opts[opt] .. ".png", true )
	end
end