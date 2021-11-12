-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 6
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")

RegisterSpawnFunction( 0xff400000, "spawn_robots" )
RegisterSpawnFunction( 0xff00AC64, "load_pixel_scene4" )
RegisterSpawnFunction( 0xff01a1fa, "spawn_turret" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xff504B64, "spawn_machines" )
RegisterSpawnFunction( 0xffBE8246, "spawn_pipes_hor" )
RegisterSpawnFunction( 0xffBE8264, "spawn_pipes_turn_right" )
RegisterSpawnFunction( 0xffBE8282, "spawn_pipes_turn_left" )
RegisterSpawnFunction( 0xffBE82A0, "spawn_pipes_ver" )
RegisterSpawnFunction( 0xffBE82BE, "spawn_pipes_cross" )
RegisterSpawnFunction( 0xffc78f20, "spawn_barricade" )

------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/drone_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/lasershooter.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 		= "data/entities/animals/vault/roboguard.xml",
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/assassin.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/acidshooter.xml"
	},
	{
		prob   		= 0.18,
		min_count	= 3,
		max_count	= 5,    
		entity 	= "data/entities/animals/vault/blob.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/bigzombie.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/scavenger_mine.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_invis.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/icer.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/icemage.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/thunderskull.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_shield.xml"
	},
	{
		prob   		= 0.002,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/ultimate_killer.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_twitchy.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_neutral.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drone_shield.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 4,    
		entity 	= "data/entities/animals/vault/scavenger_glue.xml",
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/scavenger_leader.xml",
			"data/entities/animals/vault/scavenger_smg.xml",
			"data/entities/animals/vault/scavenger_grenade.xml",
			"data/entities/animals/vault/scavenger_glue.xml",
			"data/entities/animals/vault/coward.xml",
		},
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/vault/firemage.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/thundermage.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage_big.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/roboguard.xml",
			"data/entities/animals/vault/healerdrone_physics.xml",
			"data/entities/animals/scavenger_invis.xml"
		},
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			{
				min_count	= 1,
				max_count	= 3,    
				entity 	= "data/entities/animals/vault/scavenger_smg.xml"
			},
			{
				min_count	= 1,
				max_count	= 3,    
				entity 	= "data/entities/animals/vault/scavenger_grenade.xml"
			},
			{
				min_count	= 0,
				max_count	= 1,    
				entity 	= "data/entities/animals/vault/coward.xml"
			},
			"data/entities/animals/vault/scavenger_leader.xml",
			"data/entities/animals/vault/scavenger_heal.xml",
			"data/entities/animals/scavenger_invis.xml",
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tank_rocket.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/tank_super.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_shield.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/vault/missilecrab.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/spearbot.xml"
	},
	{
		prob   		= 0.07,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot_super.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_hearty.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wizard_weaken.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/icer.xml",
			"data/entities/animals/vault/healerdrone_physics.xml",
		}
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/vault/missilecrab.xml",
			"data/entities/animals/drone_shield.xml",
		}
	},
}

g_lamp =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_tubelamp.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_water.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_water_heavy.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_oil.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/dripping_radioactive.xml"
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
		entity 	= "data/entities/items/wand_level_05.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_03.xml"
	},
	{
		prob   		= 2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_04.xml"
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
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_pressure_tank.xml"
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_propane_tank.xml"
	},
}

--- robots ---

g_robots =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

--------------------------------------------------------------

g_pipes_hor =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_hor_1.png",
		visual_file		= "data/biome_impl/vault/pipe_hor_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_hor_2.png",
		visual_file		= "data/biome_impl/vault/pipe_hor_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_ver =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_ver_1.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_1_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_ver_2.png",
		visual_file		= "data/biome_impl/vault/pipe_ver_2_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_turn_right =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_turn_right.png",
		visual_file		= "data/biome_impl/vault/pipe_turn_right_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_turn_left =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_turn_left.png",
		visual_file		= "data/biome_impl/vault/pipe_turn_left_visual.png",
		background_file	= "",
		is_unique		= 0
	},
}

g_pipes_cross =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/vault/pipe_cross.png",
		visual_file		= "data/biome_impl/vault/pipe_cross_visual.png",
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
		offset_y	= 10,
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

g_turret =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/animals/vault/turret_right.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/animals/vault/turret_left.xml"
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

g_vines =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/cords/verlet_cord.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/cords/verlet_cord_long.xml"
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
		entity 	= "data/entities/verlet_chains/cords/verlet_cord_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/cords/verlet_cord_shorter.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/slime_vine/slime_vine_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/slime_vine/slime_vine.xml"
	},
}

g_machines =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_1.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_2.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_3.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_4.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_5.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/vault_machine_6.xml"
	},
	{
		prob   		= 1.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
}

g_barricade =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_box_harmless.xml"
	},
}

function safe( x, y )
	local result = true
	
	if ( x >= 125 ) and ( x <= 249 ) and ( y >= 8694 ) and ( y <= 8860 ) then
		result = false
	end
	
	return result
end

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	if safe( x, y ) then
		spawn(g_small_enemies,x,y)
	end
	-- spawn_hp_mult(g_small_enemies,x,y,0,0,4,"vault")
end

function spawn_big_enemies(x, y)
	if safe( x, y ) then
		spawn(g_big_enemies,x,y)
	end
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,4,"vault")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r < 0.93) then
		LoadPixelScene( "data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x-5, y-10, "", true )
	end
end

function spawn_lamp(x, y)
	if safe( x, y ) then
		spawn(g_lamp,x,y,0,0)
	end
end

function spawn_props(x, y)
	if safe( x, y ) then
		spawn(g_props,x,y)
	end
end

function spawn_robots(x, y)
	if safe( x, y ) then
		spawn(g_robots,x,y)
	end
	-- spawn_hp_mult(g_robots,x,y,0,0,4,"vault")
end

function spawn_turret(x, y)
	if safe( x, y ) then
		spawn(g_turret,x,y,0,0)
	end
	-- spawn_hp_mult(g_turret,x,y,0,0,4,"vault")
end

function load_pixel_scene( x, y )
end

function load_pixel_scene2( x, y )
end

function load_pixel_scene4( x, y )
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_machines(x, y)
	spawn(g_machines,x+5,y+5,0,0)
end

function spawn_pipes_hor( x, y )
	load_random_pixel_scene( g_pipes_hor, x, y)
end

function spawn_pipes_ver( x, y )
	load_random_pixel_scene( g_pipes_ver, x, y)
end

function spawn_pipes_turn_right( x, y )
	load_random_pixel_scene( g_pipes_turn_right, x, y)
end

function spawn_pipes_turn_left( x, y )
	load_random_pixel_scene( g_pipes_turn_left, x, y)
end

function spawn_pipes_cross( x, y )
	load_random_pixel_scene( g_pipes_cross, x, y)
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar_vault.png", "data/biome_impl/potion_altar_vault_visual.png", x-3, y-10, "", true )
	end
end

function spawn_barricade(x, y)
	spawn(g_barricade,x,y,0,0)
end