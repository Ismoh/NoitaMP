-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")

RegisterSpawnFunction( 0xffC8C800, "spawn_lamp2" )
RegisterSpawnFunction( 0xff01a1fa, "spawn_turret" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xffc78f20, "spawn_barricade" )
RegisterSpawnFunction( 0xffc022f5, "spawn_forcefield_generator" )
RegisterSpawnFunction( 0xffa3d900, "spawn_brimstone" )
RegisterSpawnFunction( 0xff00d982, "spawn_vasta_or_vihta" )
RegisterSpawnFunction( 0xff932020, "spawn_cook" )

RegisterSpawnFunction( 0xff614630, "load_panel_01" )
RegisterSpawnFunction( 0xff614635, "load_panel_02" )
RegisterSpawnFunction( 0xff61463e, "load_panel_03" )
RegisterSpawnFunction( 0xff614638, "load_panel_04" )
RegisterSpawnFunction( 0xff614646, "load_panel_07" )
RegisterSpawnFunction( 0xff614650, "load_panel_08" )
RegisterSpawnFunction( 0xff614658, "load_panel_09" )

RegisterSpawnFunction( 0xffc133ff, "load_chamfer_top_r" )
RegisterSpawnFunction( 0xff8b33ff, "load_chamfer_top_l" )
RegisterSpawnFunction( 0xff8824b3, "load_chamfer_bottom_r" )
RegisterSpawnFunction( 0xff5f23ad, "load_chamfer_bottom_l" )
RegisterSpawnFunction( 0xff73ffa7, "load_chamfer_inner_top_r" )
RegisterSpawnFunction( 0xffd5ff7f, "load_chamfer_inner_top_l" )
RegisterSpawnFunction( 0xff387d51, "load_chamfer_inner_bottom_r" )
RegisterSpawnFunction( 0xff97b55b, "load_chamfer_inner_bottom_l" )

RegisterSpawnFunction( 0xff44609c, "load_pillar_filler" )
RegisterSpawnFunction( 0xff44449c, "load_pillar_filler_tall" )

RegisterSpawnFunction( 0xffb03058, "load_pod_large" )
RegisterSpawnFunction( 0xffb05830, "load_pod_small_l" )
RegisterSpawnFunction( 0xffb09030, "load_pod_small_r" )
RegisterSpawnFunction( 0xffffa659, "load_furniture" )
RegisterSpawnFunction( 0xfffec390, "load_furniture_bunk" )
RegisterSpawnFunction( 0xff4c63e0, "spawn_root_grower" )
RegisterSpawnFunction( 0xff4cacab, "spawn_forge_check" )
RegisterSpawnFunction( 0xff2a78ff, "spawn_drill_laser" )

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/scavenger_grenade.xml",
			"data/entities/animals/scavenger_smg.xml",
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
				entity	= "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 0,
				max_count	= 2,
				entity	= "data/entities/animals/scavenger_smg.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/sniper.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/shotgunner.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
	{
		prob   		= 0.002,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/tank_super.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_heal.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drone_lasership.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_super.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_leader.xml",
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
				entity	= "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count	= 2,
				entity	= "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 0,
				max_count	= 1,
				entity	= "data/entities/animals/coward.xml",
			},
		}
	},

	-- jussi
	{
		prob   		= 1.1,
		min_count	= 1,
		max_count	= 2,    
		entities 	= {
			"data/entities/animals/drunk/scavenger_grenade.xml",
			"data/entities/animals/drunk/scavenger_smg.xml",
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
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
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/sniper.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/miner.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/drunk/shotgunner.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.05,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.01,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.002,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/scavenger_heal.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 1.1,
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
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
}

------------ BIG ENEMIES ------------------------------------------------------

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.3,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
			"data/entities/animals/scavenger_leader.xml",
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		ngpluslevel	= 1,
		entities 	=  {
			"data/entities/animals/scavenger_leader.xml",
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/coward.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_heal.xml"
	},
	{
		prob   		= 0.005,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_super.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
			"data/entities/animals/scavenger_clusterbomb.xml",
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 1,
				entity = "data/entities/animals/scavenger_heal.xml",
			},
		}
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/drone_lasership.xml",
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drone_shield.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
			"data/entities/animals/coward.xml",
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/scavenger_smg.xml",
			},
		}
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/hpcrystal.xml",
		ngpluslevel = 1,
	},
	{
		prob   		= 0.075,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot.xml",
		ngpluslevel = 2,
	},
	{
		prob   		= 0.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/necrobot_super.xml",
		ngpluslevel = 3,
	},
	-- jussi
	{
		prob   		= 2.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
			"data/entities/animals/drunk/scavenger_leader.xml",
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/drunk/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/drunk/scavenger_smg.xml",
			},
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.1,
		min_count	= 1,
		max_count	= 1,
		ngpluslevel	= 1,
		entities 	=  {
			"data/entities/animals/drunk/scavenger_leader.xml",
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/drunk/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 2,
				entity = "data/entities/animals/drunk/scavenger_smg.xml",
			},
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.04,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/scavenger_heal.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.02,
		min_count	= 1,
		max_count	= 1,    
		entities 	=  {
			"data/entities/animals/drunk/scavenger_clusterbomb.xml",
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/drunk/scavenger_grenade.xml",
			},
			{
				min_count	= 1,
				max_count 	= 3,
				entity = "data/entities/animals/drunk/scavenger_smg.xml",
			},
			{
				min_count	= 1,
				max_count 	= 1,
				entity = "data/entities/animals/drunk/scavenger_heal.xml",
			},
		},
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
}

---------- UNIQUE ENCOUNTERS ---------------

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
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_rocket.xml"
	},
	{
		prob   		= 0.002,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/tank_super.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/healderdrone_physics.xml"
	},
}

g_unique_enemy2 =
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
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/scavenger_grenade.xml"
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/scavenger_smg.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/sniper.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/scavenger_heal.xml"
	},
	-- jussi 
	{
		prob   		= 2.6,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/drunk/scavenger_grenade.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.6,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/drunk/scavenger_smg.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/sniper.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
	{
		prob   		= 2.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/drunk/scavenger_heal.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
}

------------ ITEMS ------------------------------------------------------------

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
		entity 	= "data/entities/items/wand_level_03.xml"
	},
	-- debug tests
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_03_better.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_03.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 3,    		
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	}
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
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
		entity 	= "data/entities/props/physics_tubelamp.xml"
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
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 3,    		
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
	},
}

g_props2 =
{
	total_prob = 0,
	{
		prob   		= 0.3,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_crate.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 2,
		max_count	= 3,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_propane_tank.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 3,    		
		entity 	= "data/entities/items/easter/beer_bottle.xml",
		spawn_check = function()
			local year,month,day,temp1,temp2,temp3,jussi = GameGetDateAndTimeLocal()
			return jussi
		end,
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
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/items/pickup/potion_alcohol.xml"
	},
	{
		prob   		= 0.025,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/items/pickup/potion.xml"
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcastle/shaft.png",
		visual_file		= "data/biome_impl/snowcastle/shaft_visual.png",
		background_file	= "",
		is_unique		= 0
	},
		{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcastle/bridge.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcastle/drill.png",
		visual_file		= "data/biome_impl/snowcastle/drill_visual.png",
		background_file	= "data/biome_impl/snowcastle/drill_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/snowcastle/greenhouse.png",
		visual_file		= "data/biome_impl/snowcastle/greenhouse_visual.png",
		background_file	= "data/biome_impl/snowcastle/greenhouse_background.png",
		is_unique		= 0
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcastle/cargobay.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/snowcastle/bar.png",
		visual_file		= "data/biome_impl/snowcastle/bar_visual.png",
		background_file	= "data/biome_impl/snowcastle/bar_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.8,
		material_file 	= "data/biome_impl/snowcastle/bedroom.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/bedroom_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcastle/acidpool.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.4,
		material_file 	= "data/biome_impl/snowcastle/polymorphroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.2,
		material_file 	= "data/biome_impl/snowcastle/teleroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/snowcastle/sauna.png",
		visual_file		= "data/biome_impl/snowcastle/sauna_visual.png",
		background_file	= "data/biome_impl/snowcastle/sauna_background.png",
		is_unique		= 0
	},
	{
		prob   			= 0.3,
		material_file 	= "data/biome_impl/snowcastle/kitchen.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
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
		entity 	= "data/entities/animals/turret_right.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/animals/turret_left.xml"
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
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 2.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_hanging_wire.xml"
	},
}

g_forcefield_generator =
{
	total_prob = 0,
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1, 
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/forcefield_generator.xml"
	},
}

g_pods_large =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_large_blank_01.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_large_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_large_01_background.png",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_large_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_large_01_background_b.png",
		is_unique		= 0
	},
		{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_large_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_large_01_background_c.png",
		is_unique		= 0
	},
}

g_pods_small_l =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_l_blank_01.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_l_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_small_l_01_background.png",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_l_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_small_l_01_background_b.png",
		is_unique		= 0
	},
}

g_pods_small_r =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_r_blank_01.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_r_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_small_r_01_background.png",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/snowcastle/pod_small_r_01.png",
		visual_file		= "",
		background_file	= "data/biome_impl/snowcastle/pod_small_r_01_background_b.png",
		is_unique		= 0
	},
}

g_furniture =
{
	total_prob = 0,
	{
		prob   		= 2.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_bunk.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_table.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_locker.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_footlocker.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_stool.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/furniture_cryopod.xml"
	},
}

function safe( x, y )
	if ( x >= 125 ) and ( x <= 249 ) and ( y >= 5118 ) and ( y <= 5259 ) then
		return false -- close to entrance
	end

	if y > 6100 then return false end -- close to portal
	
	return true
end

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	if safe( x, y ) then
		spawn(g_small_enemies,x,y)
	end
end

function spawn_big_enemies(x, y)
	if safe( x, y ) then
		spawn(g_big_enemies,x,y)
	end
end

function spawn_unique_enemy(x, y)
	if safe( x, y ) then
		spawn(g_unique_enemy,x,y)
	end
end

function spawn_unique_enemy2(x, y)
	if safe( x, y ) then
		spawn(g_unique_enemy2,x,y)
	end
end

function spawn_turret(x, y)
	if safe( x, y ) then
		spawn(g_turret,x,y,0,0)
	end
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.2) then
		LoadPixelScene( "data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x-5, y-9, "", true )
	end
end

function spawn_lamp(x, y)
	if safe( x, y ) then
		spawn(g_lamp,x+5,y,0,0)
	end
end

function spawn_lamp2(x, y)
	if safe( x, y ) then
		spawn(g_lamp,x,y,0,0)
	end
end

function spawn_props(x, y)
	if safe( x, y ) then
		spawn(g_props,x,y-3,0,0)
	end
end

function spawn_props2(x, y)
	if safe( x, y ) then
		spawn(g_props2,x,y-3,0,0)
	end
end

function spawn_props3(x, y)
	if safe( x, y ) then
		spawn(g_props3,x,y,0,0)
	end
end

function spawn_props4(x, y)
	if safe( x, y ) then
		spawn(g_props4,x,y,0,0)
	end
end

function load_pixel_scene( x, y )
	if not safe(x,y) then return end
	--print("pixel scene spawned at: " .. x .. ", " .. y)
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene2( x, y )
	if not safe(x,y) then return end
	--print("pixel scene spawned at: " .. x .. ", " .. y)
	load_random_pixel_scene( g_pixel_scene_02, x, y )
end

function load_paneling(x,y,id)
	LoadPixelScene( "data/biome_impl/snowcastle/paneling_wall.png", "", x, y, "data/biome_impl/snowcastle/paneling_" .. id .. ".png", true, false, {}, 60 )
end

function load_panel_01(x, y)
	load_paneling(x-15,y-30,"01")
end

function load_panel_02(x, y)
	load_paneling(x-10,y-20,"02")
end

function load_panel_03(x, y)
	load_paneling(x-60,y-20,"03")
end

function load_panel_04(x, y)
	load_paneling(x-20,y-20,"04")
end

function load_panel_05(x, y)
	load_paneling(x-60,y-60,"05")
end

function load_panel_06(x, y)
	load_paneling(x-20,y-60,"06")
end

function load_panel_07(x, y)
	load_paneling(x-40,y-40,"07")
end

function load_panel_08(x, y)
	load_paneling(x-40,y-20,"08")
end

function load_panel_09(x, y)
	load_paneling(x-20,y-20,"09")
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar_vault.png", "data/biome_impl/potion_altar_vault_visual.png", x-3, y-9, "", true )
	end
end

function spawn_barricade(x, y)
	spawn(g_barricade,x,y,0,0)
end

function spawn_forcefield_generator(x, y)
	if not safe(x,y) then return end
	spawn(g_forcefield_generator,x,y-2,0,0)
end

function spawn_brimstone(x, y)
	EntityLoad("data/entities/items/pickup/brimstone.xml", x, y)
	EntityLoad("data/entities/buildings/sauna_stove_heat.xml", x, y+10)
end

function spawn_vasta_or_vihta(x, y)
	if x > 190 then
		EntityLoad("data/entities/items/wand_vasta.xml", x, y)
	else
		EntityLoad("data/entities/items/wand_vihta.xml", x, y)
	end
end


-- Chamfer corner pieces. 4 outer corners + 4 inner corners
-- /\ /\
-- \/ \/

function load_chamfer_top_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_top_r.png", "", x-10, y, "", true )
end

function load_chamfer_top_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_top_l.png", "", x-1, y, "", true )
end

function load_chamfer_bottom_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_bottom_r.png", "", x-10, y-20, "", true )
end

function load_chamfer_bottom_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_bottom_l.png", "", x-1, y-20, "", true )
end

function load_chamfer_inner_top_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_top_r.png", "", x-10, y, "", true )
end

function load_chamfer_inner_top_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_top_l.png", "", x, y, "", true )
end

function load_chamfer_inner_bottom_r(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_bottom_r.png", "", x-10, y-20, "", true )
end

function load_chamfer_inner_bottom_l(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/chamfer_inner_bottom_l.png", "", x, y-20, "", true )
end

function load_pillar_filler(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/pillar_filler_01.png", "", x, y, "", true )
end

function load_pillar_filler_tall(x,y)
	if not safe(x,y) then return end
	LoadPixelScene( "data/biome_impl/snowcastle/pillar_filler_tall_01.png", "", x, y, "", true )
end

function load_pod_large( x, y )
	if not safe(x,y-50) then return end
	load_random_pixel_scene(g_pods_large, x, y-50)
end

function load_pod_small_l( x, y )
	if not safe(x,y-40) then return end
	load_random_pixel_scene(g_pods_small_l, x-30, y-40)
end

function load_pod_small_r( x, y )
	if not safe(x,y-40) then return end
	load_random_pixel_scene(g_pods_small_r, x-10, y-40)
end

function load_furniture( x, y )
	if ProceduralRandomf(x,y) < 0.002 then
		load_bunk_with_surprise(x,y)
	else
		spawn(g_furniture,x,y+5,0,0)
	end
end

function load_furniture_bunk( x, y )
	if ProceduralRandomf(x,y) < 0.02 then
		load_bunk_with_surprise(x,y)
	else
		EntityLoad("data/entities/props/furniture_bunk.xml", x, y+5)
	end
end

function load_bunk_with_surprise( x,y )
	EntityLoad("data/entities/props/furniture_bunk.xml", x, y+5)
	EntityLoad("data/entities/props/physics_propane_tank.xml", x, y)
end

function spawn_root_grower(x, y)
	EntityLoad( "data/entities/props/root_grower.xml", x, y )
end

function spawn_forge_check(x, y)
	EntityLoad( "data/entities/buildings/forge_item_check.xml", x, y )
end

function spawn_drill_laser(x, y)
	EntityLoad( "data/entities/buildings/drill_laser.xml", x, y )
end

function spawn_cook(x, y)
	EntityLoad( "data/entities/animals/miner_chef.xml", x, y )
end
