-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xff0000ff, "spawn_nest" )
RegisterSpawnFunction( 0xffB40000, "spawn_fungi" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff55AF8C, "spawn_skulls" )
RegisterSpawnFunction( 0xff55FF8C, "spawn_chest" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )

------------ small enemies -------------------------------

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
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_001.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_002.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_003.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_004.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_005.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_006.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_007.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_008.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_009.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_01.xml"
	},
}

--- barrels ---

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
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -3,
		entity 	= "data/entities/props/physics/minecart.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -5,    
		entity 	= "data/entities/props/physics_cart.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_01.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_02.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_skull_03.xml"
	},
}

g_props2 =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -3,
		entity 	= "data/entities/props/physics/minecart.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_brewing_stand.xml"
	},
}

g_props3 =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/items/pickup/potion.xml"
	},
	--[[
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_green.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_red.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_blue.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_yellow.xml"
	},
	]]--
}

--- pixelscenes ---

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/coalpit01.png",
		visual_file		= "data/biome_impl/coalmine/coalpit01_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/coalpit02.png",
		visual_file		= "data/biome_impl/coalmine/coalpit02_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/carthill.png",
		visual_file		= "data/biome_impl/coalmine/carthill_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/coalpit03.png",
		visual_file		= "data/biome_impl/coalmine/coalpit03_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/coalpit04.png",
		visual_file		= "data/biome_impl/coalmine/coalpit04_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/coalpit05.png",
		visual_file		= "data/biome_impl/coalmine/coalpit05_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/shrine01.png",
		visual_file		= "data/biome_impl/coalmine/shrine01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/shrine02.png",
		visual_file		= "data/biome_impl/coalmine/shrine02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/slimepit.png",
		visual_file		= "data/biome_impl/coalmine/slimepit_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/laboratory.png",
		visual_file		= "data/biome_impl/coalmine/laboratory_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/swarm.png",
		visual_file		= "data/biome_impl/coalmine/swarm_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine/symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine/physics_01.png",
		visual_file		= "data/biome_impl/coalmine/physics_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine/physics_02.png",
		visual_file		= "data/biome_impl/coalmine/physics_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine/physics_03.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.75,
		material_file 	= "data/biome_impl/coalmine/shop.png",
		visual_file		= "data/biome_impl/coalmine/shop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/coalmine/radioactivecave.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_02.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_04.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_04_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "oil", "alcohol", "gunpowder_explosive", "oil", "alcohol", "oil", "alcohol" } }
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_06.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_06_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "magic_liquid_teleportation", "magic_liquid_polymorph", "magic_liquid_random_polymorph", "radioactive_liquid" } }
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_07.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_06_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "alcohol", "radioactive_liquid" } }
	},
	--[[
	-- TODO( Petri ): Disabled the other wand traps for now, to test if this box2d electricty based wand trap is even a good idea
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_01.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine/wandtrap_h_03.png",
		visual_file		= "data/biome_impl/coalmine/wandtrap_h_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	]]--
}

g_oiltank =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_1.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_1_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "coal", "radioactive_liquid" } }
	},
	-- secret / magic materials tanker
	{
		prob   			= 0.0004,
		material_file 	= "data/biome_impl/coalmine/oiltank_1.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_1_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "magic_liquid_teleportation", "magic_liquid_polymorph", "magic_liquid_random_polymorph", "magic_liquid_berserk", "magic_liquid_charm", "magic_liquid_invisibility", "magic_liquid_hp_regeneration", "salt", "blood", "gold", "honey" } }
	},
	-- more common, but weirder
	{
		prob   			= 0.01,
		material_file 	= "data/biome_impl/coalmine/oiltank_2.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_2_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "blood_fungi", "blood_cold", "lava", "poison", "slime", "gunpowder_explosive", "soil", "salt", "blood", "cement" } }
	},

	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_2.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_2_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "oil", "coal", "radioactive_liquid" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_3.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_3_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "water", "coal", "radioactive_liquid", "magic_liquid_teleportation" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_4.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_4_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "coal", "radioactive_liquid", "magic_liquid_polymorph" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_5.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "radioactive_liquid", "coal", "radioactive_liquid" } }
	},
}

g_oiltank_alt =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine/oiltank_alt.png",
		visual_file		= "data/biome_impl/coalmine/oiltank_alt_visual.png",
		background_file	= "",
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "radioactive_liquid", "radioactive_liquid", "magic_liquid_berserk" } }
	},
}

g_i_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_i_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_i_structure_02.xml"
	},
}

g_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_structure_01.xml"
	},
}

g_large_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_large_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_large_structure_02.xml"
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

g_nest =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/flynest.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
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
		prob   		= 1.5,
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

--------------

function safe( x, y )
	local result = true
	
	if ( x >= 9676 ) and ( x <= 9804 ) and ( y >= 9086 ) and ( y <= 9214 ) then
		result = false
	end
	
	return result
end

-- this is a special function tweaked for spawning things in coalmine
function spawn_items( pos_x, pos_y )

	local x_offset,y_offset = 5,5

	local r = ProceduralRandom( pos_x, pos_y )
	-- 20% is air, nothing happens
	if( r < 0.47 ) then return end
	r = ProceduralRandom( pos_x-11.431, pos_y+10.5257 )
	
	if( r < 0.755 ) then
	else
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10+x_offset, pos_y-17+x_offset, "", true )
	end

	-- LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10, pos_y-17, "", true )
end

-- actual functions that get called from the wang generator

local enemy_list = { "acidshooter", "alchemist", "ant", "assassin", "barfer", "bat", "bigbat", "bigfirebug", "bigzombie", "blob", "bloodcrystal_physics", "bloom", "chest_mimic", "coward", "crystal_physics", "drone_physics",  "drone_shield", "enlightened_alchemist", "failed_alchemist", "failed_alchemist_b", "firebug", "firemage", "fireskull", "flamer", "fly", "frog", "frog_big", "fungus", "fungus_big", "fungus_giga", "gazer", "ghoul", "giant", "giantshooter", "healerdrone_physics", "icemage", "icer", "iceskull", "lasershooter", "longleg", "maggot", "miner", "miner_fire", "missilecrab", "monk", "necromancer", "necromancer_shop", "phantom_a", "phantom_b", "rat", "roboguard", "scavenger_clusterbomb", "scavenger_heal", "scavenger_grenade", "scavenger_leader", "scavenger_mine", "scavenger_poison", "scavenger_smg", "shooterflower", "shotgunner", "skullfly", "skullrat", "slimeshooter", "sniper", "spitmonster", "statue_physics", "tank", "tank_rocket", "tank_super", "tentacler", "tentacler_small", "thundermage", "thundermage_big", "thunderskull", "turret_left", "turret_right", "wizard_dark", "wizard_hearty", "wizard_neutral", "wizard_poly", "wizard_returner", "wizard_swapper", "wizard_tele", "wizard_twitchy", "wizard_weaken", "wizard_homing", "wolf", "wraith", "wraith_glowing", "wraith_storm", "zombie", "skycrystal_physics", "scavenger_shield", "spearbot", "statue", "goblin_bomb", "buildings/snowcrystal", "buildings/hpcrystal" }

function spawn_any_enemy( x, y )
	SetRandomSeed( x, y )
	if safe( x, y ) then
		local rnd = Random( 1, #enemy_list )
		local target = enemy_list[rnd]
		
		local folder = "animals/"
		if ( string.sub( target, 1, 10 ) == "buildings/" ) then
			folder = ""
		end
		
		local eid = EntityLoad( "data/entities/" .. folder .. target .. ".xml", x, y )
		
		if ( target ~= "scavenger_heal" ) and ( target ~= "healerdrone_physics" ) then
			local damagemodels = EntityGetComponent( eid, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) ) * 4
					
					ComponentSetValue( damagemodel, "max_hp", hp )
					ComponentSetValue( damagemodel, "hp", hp )
				end
			end
		end
	end
end

function spawn_small_enemies(x, y, w, h, is_open_path)
	spawn_any_enemy( x, y )
end

function spawn_big_enemies(x, y, w, h, is_open_path)
	spawn_any_enemy( x, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+2,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x,y-3,0,0)
end

function spawn_props2(x, y)
	spawn(g_props2,x,y-3,0,0)
end

function spawn_props3(x, y)
	spawn(g_props3,x,y,0,0)
end

function spawn_unique_enemy(x, y)
	spawn_any_enemy( x, y )
end

function spawn_unique_enemy2(x, y)
	spawn_any_enemy( x, y )
end

function spawn_unique_enemy3(x, y)
	spawn_any_enemy( x, y )
end

function spawn_fungi(x, y)
	spawn_any_enemy( x, y )
end

function load_pixel_scene( x, y )
end

function load_pixel_scene2( x, y )
end

function spawn_stash(x,y)
end

function spawn_nest(x, y)
	spawn_any_enemy( x, y )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
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

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 6 )
end
