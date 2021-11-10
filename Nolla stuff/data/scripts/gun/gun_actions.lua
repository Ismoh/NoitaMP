actions =
{
	-- projectiles --
	--[[{
		id          = "TESTBULLET", -- REMOVE THIS ONCE PHYSICS_EXPLOSION_POWER IS ADJUSTED, JUST FOR TESTING
		name 		= "$action_testbullet",
		description = "$actiondesc_testbullet",
		sprite 		= "data/debug/icon_testbullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- TESTBULLET
		spawn_probability                        = "", -- TESTBULLET
		price = 100,
		mana = 0,
		max_uses = 999,
		action 		= function()
			add_projectile("data/entities/animals/boss_centipede/firepillar.xml")
			c.fire_rate_wait = 0
			current_reload_time = current_reload_time * 0.01
		end,
	},]]--
	{
		id          = "BOMB",
		name 		= "$action_bomb",
		description = "$actiondesc_bomb",
		sprite 		= "data/ui_gfx/gun_actions/bomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability                 = "1,1,1,1,1,1,1", -- BOMB
		price = 200,
		mana = 25, 
		max_uses    = 3, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
		end,
	},
	{
		id          = "LIGHT_BULLET",
		name 		= "$action_light_bullet",
		description = "$actiondesc_light_bullet",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2", -- LIGHT_BULLET
		spawn_probability                 = "2,1,0.5", -- LIGHT_BULLET
		price = 100,
		mana = 5,
		--max_uses = -1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/light_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
			c.damage_critical_chance = c.damage_critical_chance + 5
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER",
		name 		= "$action_light_bullet_trigger",
		description = "$actiondesc_light_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3", -- LIGHT_BULLET_TRIGGER
		spawn_probability                   = "1,0.5,0.5,0.5", -- LIGHT_BULLET_TRIGGER
		price = 140,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet.xml", 1)
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER_2",
		name 		= "$action_light_bullet_trigger_2",
		description = "$actiondesc_light_bullet_trigger_2",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_trigger_2.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet_blue.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,5,6,10", -- LIGHT_BULLET_TRIGGER_2
		spawn_probability                   = "1,0.5,1,1,0.2", -- LIGHT_BULLET_TRIGGER_2
		price = 250,
		mana = 15,
		--max_uses = 100,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 1
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet_blue.xml", 2)
		end,
	},
	{
		id          = "LIGHT_BULLET_TIMER",
		name 		= "$action_light_bullet_timer",
		description = "$actiondesc_light_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "1,2,3", -- LIGHT_BULLET_TIMER
		spawn_probability                   = "0.5,0.5,0.5", -- LIGHT_BULLET_TIMER
		price = 140,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_timer("data/entities/projectiles/deck/light_bullet.xml", 10, 1)
		end,
	},
	{
		id          = "BULLET",
		name 		= "$action_bullet",
		description = "$actiondesc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- BULLET
		spawn_probability                 = "1,1,1,1,1", -- BULLET
		price = 150,
		mana = 20,
		--max_uses = -1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "BULLET_TRIGGER",
		name 		= "$action_bullet_trigger",
		description = "$actiondesc_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/bullet_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "1,2,3,4,5", -- BULLET_TRIGGER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.5", -- BULLET_TRIGGER
		price = 190,
		mana = 35,
		--max_uses = 80,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "BULLET_TIMER",
		name 		= "$action_bullet_timer",
		description = "$actiondesc_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/bullet_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- BULLET_TIMER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.5", -- BULLET_TIMER
		price = 190,
		mana = 35,
		--max_uses = 80,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "HEAVY_BULLET",
		name 		= "$action_heavy_bullet",
		description = "$actiondesc_heavy_bullet",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- HEAVY_BULLET
		spawn_probability                 = "0.5,1,1,1,1,1", -- HEAVY_BULLET
		price = 200,
		mana = 30,
		--max_uses = 50,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_heavy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TRIGGER",
		name 		= "$action_heavy_bullet_trigger",
		description = "$actiondesc_heavy_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- HEAVY_BULLET_TRIGGER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.5", -- HEAVY_BULLET_TRIGGER
		price = 240,
		mana = 40,
		--max_uses = 50,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_heavy.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TIMER",
		name 		= "$action_heavy_bullet_timer",
		description = "$actiondesc_heavy_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_heavy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "2,3,4,5,6", -- HEAVY_BULLET_TIMER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.5", -- HEAVY_BULLET_TIMER
		price = 240,
		mana = 40,
		--max_uses = 50,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 5.0
			c.damage_critical_chance = c.damage_critical_chance + 5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_heavy.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "AIR_BULLET",
		name 		= "$action_air_bullet",
		description = "$actiondesc_air_bullet",
		sprite 		= "data/ui_gfx/gun_actions/air_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/air_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet_air.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2", -- AIR_BULLET
		spawn_probability                 = "1,1", -- AIR_BULLET
		price = 80,
		mana = 5,
		--max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/light_bullet_air.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			--c.screenshake = c.screenshake + 0.1
			c.spread_degrees = c.spread_degrees - 2.0
			--c.knockback_force = c.knockback_force + 2
		end,
	},
	{
		id          = "SLOW_BULLET",
		name 		= "$action_slow_bullet",
		description = "$actiondesc_slow_bullet",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- SLOW_BULLET
		spawn_probability                 = "1,1,1,1", -- SLOW_BULLET
		price = 160,
		mana = 30,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_slow.xml")
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 3.6
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "SLOW_BULLET_TRIGGER",
		name 		= "$action_slow_bullet_trigger",
		description = "$actiondesc_slow_bullet_trigger",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SLOW_BULLET_TRIGGER
		spawn_probability                 = "0.5,0.5,0.5,0.5,1", -- SLOW_BULLET_TRIGGER
		price = 200,
		mana = 50,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 25
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 10
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_slow.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "SLOW_BULLET_TIMER",
		name 		= "$action_slow_bullet_timer",
		description = "$actiondesc_slow_bullet_timer",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slow_bullet_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bullet_slow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- SLOW_BULLET_TIMER
		spawn_probability                 = "0.5,0.5,0.5,0.5,1,1", -- SLOW_BULLET_TIMER
		price = 200,
		mana = 50,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 3.6
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_slow.xml", 100, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "BLACK_HOLE",
		name 		= "$action_black_hole",
		description = "$actiondesc_black_hole",
		sprite 		= "data/ui_gfx/gun_actions/black_hole.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4,5", -- BLACK_HOLE
		spawn_probability                 = "0.8,0.8,0.8,0.8", -- BLACK_HOLE
		price = 200,
		mana = 180,
		max_uses    = 3, 
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/black_hole.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 20
		end,
	},
	{
		id          = "BLACK_HOLE_DEATH_TRIGGER",
		name 		= "$action_black_hole_death_trigger",
		description = "$actiondesc_black_hole_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/black_hole_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- BLACK_HOLE
		spawn_probability                 = "0.5,0.5,0.5,0.5", -- BLACK_HOLE
		price = 220,
		mana = 200,
		max_uses    = 3, 
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole.xml",
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/black_hole.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 90
			c.screenshake = c.screenshake + 20
		end,
	},
	{
		id          = "BLACK_HOLE_BIG",
		name 		= "$action_black_hole_big",
		description = "$actiondesc_black_hole_big",
		sprite 		= "data/ui_gfx/gun_actions/black_hole_big.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole_big.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6,10", -- BLACK_HOLE_BIG
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.5", -- BLACK_HOLE_BIG
		price = 320,
		mana = 240,
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/black_hole_big.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/black_hole_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 10
		end,
	},
	{
		id          = "BLACK_HOLE_GIGA",
		name 		= "$action_black_hole_giga",
		description = "$actiondesc_black_hole_giga",
		sprite 		= "data/ui_gfx/gun_actions/black_hole_giga.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/black_hole_big_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/black_hole_giga.xml"},
		spawn_requires_flag = "card_unlocked_black_hole",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10", -- BLACK_HOLE_BIG
		spawn_probability                 = "1", -- BLACK_HOLE_BIG
		price = 600,
		mana = 500,
		max_uses    = 6,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/black_hole_giga.xml",
		action 		= function()
			local black_holes = EntityGetWithTag( "black_hole_giga" )
			
			if ( #black_holes < 3 ) then
				add_projectile("data/entities/projectiles/deck/black_hole_giga.xml")
				c.fire_rate_wait = c.fire_rate_wait + 120
				current_reload_time = current_reload_time + 100
				c.screenshake = c.screenshake + 40
			end
		end,
	},
	{
		id          = "TENTACLE_PORTAL",
		name 		= "$action_tentacle_portal",
		description = "$actiondesc_tentacle_portal",
		sprite 		= "data/ui_gfx/gun_actions/tentacle_portal.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle_portal.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,10", -- TENTACLE_PORTAL
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.2", -- TENTACLE_PORTAL
		price = 220,
		mana = 140,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tentacle_portal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	--[[{
		id          = "DECOY",
		name 		= "$action_decoy",
		description = "$actiondesc_decoy",
		sprite 		= "data/ui_gfx/gun_actions/decoy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/decoy_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- DECOY
		spawn_probability                 = "", -- DECOY
		price = 130,
		mana = 60,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/decoy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/decoy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "DECOY_TRIGGER",
		name 		= "$action_decoy_trigger",
		description = "$actiondesc_decoy_trigger",
		sprite 		= "data/ui_gfx/gun_actions/decoy_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/decoy_trigger_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- DECOY_TRIGGER
		spawn_probability                 = "", -- DECOY_TRIGGER
		price = 150,
		mana = 80,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/decoy_trigger.xml",
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/decoy_trigger.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},]]--
	{
		id          = "SPITTER",
		name 		= "$action_spitter",
		description = "$actiondesc_spitter",
		sprite 		= "data/ui_gfx/gun_actions/spitter.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- SPITTER
		spawn_probability                 = "1,1,1,0.5", -- SPITTER
		price = 110,
		mana = 5,
		--max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 1
			c.screenshake = c.screenshake + 0.1
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 6.0
		end,
	},
	{
		id          = "SPITTER_TIMER",
		name 		= "$action_spitter_timer",
		description = "$actiondesc_spitter_timer",
		sprite 		= "data/ui_gfx/gun_actions/spitter_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- SPITTER_TIMER
		spawn_probability                 = "0.5,0.5,0.5,1", -- SPITTER_TIMER
		price = 140,
		mana = 10,
		--max_uses = 120,
		action 		= function()
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 1
			c.screenshake = c.screenshake + 0.1
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 6.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter.xml", 40, 1)
		end,
	},
	{
		id          = "SPITTER_TIER_2",
		name 		= "$action_spitter_tier_2",
		description = "$actiondesc_spitter_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/spitter_green.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- SPITTER_TIER_2
		spawn_probability                 = "1,1,1,0.5", -- SPITTER_TIER_2
		price = 190,
		mana = 25,
		--max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter_tier_2.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.screenshake = c.screenshake + 1.1
			c.dampening = 0.2
			c.spread_degrees = c.spread_degrees + 7.5
		end,
	},
	{
		id          = "SPITTER_TIER_2_TIMER",
		name 		= "$action_spitter_tier_2_timer",
		description = "$actiondesc_spitter_tier_2_timer",
		sprite 		= "data/ui_gfx/gun_actions/spitter_green_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- SPITTER_TIER_2_TIMER
		spawn_probability                 = "0.5,0.5,0.5,1", -- SPITTER_TIER_2_TIMER
		price = 220,
		mana = 30,
		--max_uses = 120,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter_tier_2.xml", 40, 1)
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.screenshake = c.screenshake + 1.1
			c.dampening = 0.2
			c.spread_degrees = c.spread_degrees + 7.5
		end,
	},
	{
		id          = "SPITTER_TIER_3",
		name 		= "$action_spitter_tier_3",
		description = "$actiondesc_spitter_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/spitter_purple.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- SPITTER_TIER_3
		spawn_probability                 = "0.8,0.8,1,1", -- SPITTER_TIER_3
		price = 240,
		mana = 40,
		--max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter_tier_3.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 4
			c.screenshake = c.screenshake + 3.1
			c.dampening = 0.3
			c.spread_degrees = c.spread_degrees + 9.0
		end,
	},
	{
		id          = "SPITTER_TIER_3_TIMER",
		name 		= "$action_spitter_tier_3_timer",
		description = "$actiondesc_spitter_tier_3_timer",
		sprite 		= "data/ui_gfx/gun_actions/spitter_purple_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spitter_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spitter_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6", -- SPITTER_TIER_3_TIMER
		spawn_probability                 = "0.5,0.5,0.5", -- SPITTER_TIER_3_TIMER
		price = 260,
		mana = 45,
		--max_uses = 120,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter_tier_3.xml", 40, 1)
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 4
			c.screenshake = c.screenshake + 3.1
			c.dampening = 0.3
			c.spread_degrees = c.spread_degrees + 9.0
		end,
	},
	{
		id          = "BUBBLESHOT",
		name 		= "$action_bubbleshot",
		description = "$actiondesc_bubbleshot",
		sprite 		= "data/ui_gfx/gun_actions/bubbleshot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bubbleshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3", -- BUBBLESHOT
		spawn_probability                 = "1,1,1,0.5", -- BUBBLESHOT
		price = 100,
		mana = 5,
		--max_uses = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bubbleshot.xml")
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.dampening = 0.1
		end,
	},
	{
		id          = "BUBBLESHOT_TRIGGER",
		name 		= "$action_bubbleshot_trigger",
		description = "$actiondesc_bubbleshot_trigger",
		sprite 		= "data/ui_gfx/gun_actions/bubbleshot_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bubbleshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- BUBBLESHOT_TRIGGER
		spawn_probability                 = "0.5,0.5,1", -- BUBBLESHOT_TRIGGER
		price = 120,
		mana = 16,
		--max_uses = 120,
		action 		= function()
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.dampening = 0.1
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bubbleshot.xml", 1)
		end,
	},
	{
		id          = "DISC_BULLET",
		name 		= "$action_disc_bullet",
		description = "$actiondesc_disc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/disc_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- DISC_BULLET
		spawn_probability                 = "1,1,1", -- DISC_BULLET
		price = 120,
		mana = 20,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees + 2.0
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "DISC_BULLET_BIG",
		name 		= "$action_disc_bullet_big",
		description = "$actiondesc_disc_bullet_big",
		sprite 		= "data/ui_gfx/gun_actions/disc_bullet_big.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4,10", -- DISC_BULLET_BIG
		spawn_probability                 = "0.6,0.6,0.6,0.1", -- DISC_BULLET_BIG
		price = 180,
		mana = 38,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet_big.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.spread_degrees = c.spread_degrees + 3.4
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "DISC_BULLET_BIGGER",
		name 		= "$action_omega_disc_bullet",
		description = "$actiondesc_omega_disc_bullet",
		sprite 		= "data/ui_gfx/gun_actions/omega_disc_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		spawn_requires_flag = "card_unlocked_everything",
		related_projectiles	= {"data/entities/projectiles/deck/disc_bullet_bigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,5,10", -- DISC_BULLET_BIG
		spawn_probability                 = "0.1,0.6,1.0,0.1", -- DISC_BULLET_BIG
		price = 270,
		mana = 70,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet_bigger.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.spread_degrees = c.spread_degrees + 6.4
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			c.damage_projectile_add = c.damage_projectile_add + 0.2
		end,
	},
	{
		id          = "BOUNCY_ORB",
		name 		= "$action_bouncy_orb",
		description = "$actiondesc_bouncy_orb",
		sprite 		= "data/ui_gfx/gun_actions/bouncy_orb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bouncy_orb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- BOUNCY_ORB
		spawn_probability                 = "1,1,1", -- BOUNCY_ORB
		price = 120,
		mana = 20,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bouncy_orb.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "BOUNCY_ORB_TIMER",
		name 		= "$action_bouncy_orb_timer",
		description = "$actiondesc_bouncy_orb_timer",
		sprite 		= "data/ui_gfx/gun_actions/bouncy_orb_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bouncy_orb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2,4", -- BOUNCY_ORB_TIMER
		spawn_probability                 = "0.5,0.5,0.5", -- BOUNCY_ORB_TIMER
		price = 150,
		mana = 50,
		--max_uses = 40,
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/bouncy_orb.xml",200,1)
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "RUBBER_BALL",
		name 		= "$action_rubber_ball",
		description = "$actiondesc_rubber_ball",
		sprite 		= "data/ui_gfx/gun_actions/rubber_ball.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rubber_ball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,6", -- RUBBER_BALL
		spawn_probability                 = "1,1,1", -- RUBBER_BALL
		price = 60,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rubber_ball.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},
	{
		id          = "ARROW",
		name 		= "$action_arrow",
		description = "$actiondesc_arrow",
		sprite 		= "data/ui_gfx/gun_actions/arrow.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arrow_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/arrow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5", -- ARROW
		spawn_probability                 = "1,1,1,1", -- ARROW
		price = 140,
		mana = 15,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/arrow.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees - 20
			shot_effects.recoil_knockback = 30.0
		end,
	},
	{
		id          = "POLLEN",
		name 		= "$action_pollen",
		description = "$actiondesc_pollen",
		sprite 		= "data/ui_gfx/gun_actions/pollen.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arrow_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pollen.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,3,4", -- ARROW
		spawn_probability                 = "0.6,1,1,0.8", -- ARROW
		price = 110,
		mana = 10,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pollen.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.spread_degrees = c.spread_degrees + 20
		end,
	},
	{
		id          = "LANCE",
		name 		= "$action_lance",
		description = "$actiondesc_lance",
		sprite 		= "data/ui_gfx/gun_actions/lance.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lance_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lance.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- LANCE
		spawn_probability                 = "1,1,1,1", -- LANCE
		price = 180,
		mana = 30,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/lance.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lance.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.spread_degrees = c.spread_degrees - 20
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id          = "ROCKET",
		name 		= "$action_rocket",
		description = "$actiondesc_rocket",
		sprite 		= "data/ui_gfx/gun_actions/rocket.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- ROCKET
		spawn_probability                 = "1,1,1,0.5,0.5", -- ROCKET
		price = 220,
		mana = 70,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 120.0
		end,
	},
	{
		id          = "ROCKET_TIER_2",
		name 		= "$action_rocket_tier_2",
		description = "$actiondesc_rocket_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/rocket_tier_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- ROCKET_TIER_2
		spawn_probability                 = "0.5,1,1,1,1", -- ROCKET_TIER_2
		price = 240,
		mana = 90,
		max_uses    = 8, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket_tier_2.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_tier_2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 90
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 160.0
		end,
	},
	{
		id          = "ROCKET_TIER_3",
		name 		= "$action_rocket_tier_3",
		description = "$actiondesc_rocket_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/rocket_tier_3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rocket_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- ROCKET_TIER_3
		spawn_probability                 = "0.25,0.5,1,1,1", -- ROCKET_TIER_3
		price = 250,
		mana = 120,
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket_tier_3.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_tier_3.xml")
			c.fire_rate_wait = c.fire_rate_wait + 120
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 180.0
		end,
	},
	{
		id          = "GRENADE",
		name 		= "$action_grenade",
		description = "$actiondesc_grenade",
		sprite 		= "data/ui_gfx/gun_actions/grenade.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- GRENADE
		spawn_probability                 = "1,1,0.5,0.25,0.25", -- GRENADE
		price = 170,
		mana = 50,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 4.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_TRIGGER",
		name 		= "$action_grenade_trigger",
		description = "$actiondesc_grenade_trigger",
		sprite 		= "data/ui_gfx/gun_actions/grenade_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5", -- GRENADE_TRIGGER
		spawn_probability                   = "0.5,0.5,0.5,0.5,0.5,1", -- GRENADE_TRIGGER
		price = 210,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_trigger.xml",
		mana = 50,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 4.0
			--current_reload_time = current_reload_time + 60
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/grenade.xml", 1)
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_TIER_2",
		name 		= "$action_grenade_tier_2",
		description = "$actiondesc_grenade_tier_2",
		sprite 		= "data/ui_gfx/gun_actions/grenade_tier_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_tier_2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- GRENADE_TIER_2
		spawn_probability                 = "0.5,1,1,1,1", -- GRENADE_TIER_2
		price = 220,
		mana = 90,
		max_uses    = 20, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_tier_2.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_tier_2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			c.screenshake = c.screenshake + 8.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 120.0
		end,
	},
	{
		id          = "GRENADE_TIER_3",
		name 		= "$action_grenade_tier_3",
		description = "$actiondesc_grenade_tier_3",
		sprite 		= "data/ui_gfx/gun_actions/grenade_tier_3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_tier_3.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- GRENADE_TIER_3
		spawn_probability                 = "0.25,0.5,0.75,1,1", -- GRENADE_TIER_3
		price = 220,
		mana = 90,
		max_uses    = 20, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_tier_3.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_tier_3.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 15.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.9
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 140.0
		end,
	},
	{
		id          = "GRENADE_ANTI",
		name 		= "$action_grenade_anti",
		description = "$actiondesc_grenade_anti",
		sprite 		= "data/ui_gfx/gun_actions/grenade_anti.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_anti.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GRENADE_ANTI
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- GRENADE_ANTI
		price = 170,
		mana = 50,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_anti.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 4.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_LARGE",
		name 		= "$action_grenade_large",
		description = "$actiondesc_grenade_large",
		sprite 		= "data/ui_gfx/gun_actions/grenade_large.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_large.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GRENADE_LARGE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- GRENADE_LARGE
		price = 150,
		mana = 80,
		max_uses    = 35, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_large.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.screenshake = c.screenshake + 5.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			--current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id 			= "MINE",
		name 		= "$action_mine",
		description = "$actiondesc_mine",
		sprite 		= "data/ui_gfx/gun_actions/mine.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/mine_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mine.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "1,3,4,6", -- MINE
		spawn_probability	   = "1,1,1,1", -- MINE
		price = 200,
		mana = 20,
		max_uses	= 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mine.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = 60.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id 			= "MINE_DEATH_TRIGGER",
		name 		= "$action_mine_death_trigger",
		description = "$actiondesc_mine_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/mine_death_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/mine_death_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mine.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "2,6", -- MINE_DEATH_TRIGGER
		spawn_probability	   = "1,1", -- MINE_DEATH_TRIGGER
		price = 240,
		mana = 20,
		max_uses	= 15, 
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/mine.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = 60.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id 			= "PIPE_BOMB",
		name 		= "$action_pipe_bomb",
		description = "$actiondesc_pipe_bomb",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/pipe_bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pipe_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "2,3,4", -- PIPE_BOMB
		spawn_probability	   = "1,1,1", -- PIPE_BOMB
		price = 200,
		mana = 20,
		max_uses	= 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pipe_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "PIPE_BOMB_DEATH_TRIGGER",
		name 		= "$action_pipe_bomb_death_trigger",
		description = "$actiondesc_pipe_bomb_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb_death_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/pipe_bomb_death_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pipe_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- PIPE_BOMB_DEATH_TRIGGER
		spawn_probability                 = "1,1,1,1", -- PIPE_BOMB_DEATH_TRIGGER
		price = 230,
		mana = 20,
		max_uses    = 20, 
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			add_projectile_trigger_death("data/entities/projectiles/deck/pipe_bomb.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "EXPLODING_DEER",
		name 		= "$action_exploding_deer",
		description = "$actiondesc_exploding_deer",
		spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/exploding_deer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/exploding_deer.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5", -- EXPLODING_DEER
		spawn_probability                 = "0.6,0.6,0.6", -- EXPLODING_DEER
		price = 170,
		mana = 120,
		max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/exploding_deer.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "EXPLODING_DUCKS",
		name 		= "$action_exploding_ducks",
		description = "$actiondesc_exploding_ducks",
		spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/duck_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/duck.xml", 3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5", -- EXPLODING_DEER
		spawn_probability                 = "0.6,0.8,0.6", -- EXPLODING_DEER
		price = 200,
		mana = 100,
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/duck.xml")
			add_projectile("data/entities/projectiles/deck/duck.xml")
			add_projectile("data/entities/projectiles/deck/duck.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "WORM_SHOT",
		name 		= "$action_worm_shot",
		description = "$actiondesc_worm_shot",
		spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "data/ui_gfx/gun_actions/worm.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/exploding_deer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/worm_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5", -- EXPLODING_DEER
		spawn_probability                 = "0.6,0.8,0.6", -- EXPLODING_DEER
		price = 200,
		mana = 150,
		max_uses    = 10,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/worm_shot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			current_reload_time = current_reload_time + 40
			c.spread_degrees = c.spread_degrees + 20
		end,
	},
	--[[
	{
		id          = "PIPE_BOMB_DETONATOR",
		name 		= "$action_pipe_bomb_detonator",
		description = "$actiondesc_pipe_bomb_detonator",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb_detonator.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/pipe_bomb_detonator_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pipe_bomb_detonator.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- PIPE_BOMB_DETONATOR
		spawn_probability                 = "1,1,1,1,1", -- PIPE_BOMB_DETONATOR
		price = 50,
		mana = 50,
		--max_uses = 50,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pipe_bomb_detonator.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
			--current_reload_time = current_reload_time + 5
		end,
	},
	]]--
	{
		id          = "BOMB_DETONATOR",
		name 		= "$action_bomb_detonator",
		description = "$actiondesc_bomb_detonator",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb_detonator.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/meteor_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bomb_detonator.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- PIPE_BOMB_DETONATOR
		spawn_probability                 = "1,1,1,1,1", -- PIPE_BOMB_DETONATOR
		price = 120,
		mana = 50,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bomb_detonator.xml")
		end,
	},
	{
		id          = "LASER",
		name 		= "$action_laser",
		description = "$actiondesc_laser",
		sprite 		= "data/ui_gfx/gun_actions/laser.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/laser.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4", -- LASER
		spawn_probability                 = "1,1,1", -- LASER
		price = 180,
		mana = 30,
		--max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/laser.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/laser.xml")
			c.fire_rate_wait = c.fire_rate_wait - 22
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "MEGALASER",
		name 		= "$action_megalaser",
		description = "$actiondesc_megalaser",
		sprite 		= "data/ui_gfx/gun_actions/megalaser.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/megalaser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/megalaser.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,10", -- MEGALASER
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.1", -- MEGALASER
		price = 300,
		mana = 110,
		action 		= function()
			-- beams are added in advance so that they inherit modifiers
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			add_projectile("data/entities/projectiles/deck/megalaser_beam.xml")
			
			add_projectile("data/entities/projectiles/deck/megalaser.xml")
			c.fire_rate_wait = c.fire_rate_wait + 90
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
		end,
	},
	{
		id          = "LIGHTNING",
		name 		= "$action_lightning",
		description = "$actiondesc_lightning",
		sprite 		= "data/ui_gfx/gun_actions/lightning.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lightning.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- LIGHTNING
		spawn_probability                 = "1,1,1,1", -- LIGHTNING
		price = 250,
		mana = 70,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lightning.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			shot_effects.recoil_knockback = 180.0
		end,
	},
	{
		id          = "BALL_LIGHTNING",
		name 		= "$action_ball_lightning",
		description = "$actiondesc_ball_lightning",
		sprite 		= "data/ui_gfx/gun_actions/ball_lightning.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/ball_lightning.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5", -- LIGHTNING
		spawn_probability                 = "0.2,0.2,1,1", -- LIGHTNING
		price = 250,
		mana = 70,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			add_projectile("data/entities/projectiles/deck/ball_lightning.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			shot_effects.recoil_knockback = 120.0
		end,
	},
	{
		id          = "LASER_EMITTER",
		name 		= "$action_laser_emitter",
		description = "$actiondesc_laser_emitter",
		sprite 		= "data/ui_gfx/gun_actions/laser_emitter.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- LASER
		spawn_probability                 = "0.2,1,1,0.5", -- LASER
		price = 180,
		mana = 60,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
		end,
	},
	{
		id          = "LASER_EMITTER_FOUR",
		name 		= "$action_laser_emitter_four",
		description = "$actiondesc_laser_emitter_four",
		sprite 		= "data/ui_gfx/gun_actions/laser_emitter_four.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- LASER
		spawn_probability                 = "0.2,1,0.2,0.5,1", -- LASER
		price = 200,
		mana = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter_four.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
		end,
	},
	{
		id          = "LASER_EMITTER_CUTTER",
		name 		= "$action_laser_emitter_cutter",
		description = "$actiondesc_laser_emitter_cutter",
		sprite 		= "data/ui_gfx/gun_actions/laser_emitter_cutter.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/laser_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/orb_laseremitter_cutter.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- LASER
		spawn_probability                 = "0.2,0.3,1,0.5,0.1", -- LASER
		price = 120,
		mana = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_laseremitter_cutter.xml")
			current_reload_time = current_reload_time + 10
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
		end,
	},
	{
		id          = "DIGGER",
		name 		= "$action_digger",
		description = "$actiondesc_digger",
		sprite 		= "data/ui_gfx/gun_actions/digger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/digger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/digger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2", -- DIGGER
		spawn_probability                 = "1,0.5", -- DIGGER
		price = 70,
		mana = 0,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/digger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "POWERDIGGER",
		name 		= "$action_powerdigger",
		description = "$actiondesc_powerdigger",
		sprite 		= "data/ui_gfx/gun_actions/powerdigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/powerdigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/powerdigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4", -- POWERDIGGER
		spawn_probability                 = "0.5,1,1", -- POWERDIGGER
		price = 110,
		mana = 0,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/powerdigger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "CHAINSAW",
		name 		= "$action_chainsaw",
		description = "$actiondesc_chainsaw",
		sprite 		= "data/ui_gfx/gun_actions/chainsaw.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/chainsaw.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2", -- CHAINSAW
		spawn_probability                 = "1,1", -- CHAINSAW
		price = 80,
		mana = 1,
		--max_uses = 1000,
		sound_loop_tag = "sound_chainsaw",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chainsaw.xml")
			c.fire_rate_wait = 0
			c.spread_degrees = c.spread_degrees + 6.0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "LUMINOUS_DRILL",
		name 		= "$action_luminous_drill",
		description = "$actiondesc_luminous_drill",
		sprite 		= "data/ui_gfx/gun_actions/luminous_drill.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/luminous_drill.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2", -- LUMINOUS_DRILL
		spawn_probability                 = "1,1", -- LUMINOUS_DRILL
		price = 150,
		mana = 10,
		--max_uses = 1000,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/luminous_drill.xml")
			c.fire_rate_wait = c.fire_rate_wait - 35
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "LASER_LUMINOUS_DRILL",
		name 		= "$action_luminous_drill_timer",
		description = "$actiondesc_luminous_drill_timer",
		sprite 		= "data/ui_gfx/gun_actions/luminous_drill_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/luminous_drill.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,2", -- LASER_LUMINOUS_DRILL
		spawn_probability                 = "1,1", -- LASER_LUMINOUS_DRILL
		price = 220,
		mana = 30,
		--max_uses = 1000,
		sound_loop_tag = "sound_digger",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/luminous_drill.xml",4,1)
			c.fire_rate_wait = c.fire_rate_wait - 35
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "TENTACLE",
		name 		= "$action_tentacle",
		description = "$actiondesc_tentacle",
		spawn_requires_flag = "card_unlocked_tentacle",
		sprite 		= "data/ui_gfx/gun_actions/tentacle.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- TENTACLE
		spawn_probability                 = "1,1,1,1", -- TENTACLE
		price = 200,
		mana = 20,
		--max_uses = 40,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tentacle.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "TENTACLE_TIMER",
		name 		= "$action_tentacle_timer",
		description = "$actiondesc_tentacle_timer",
		spawn_requires_flag = "card_unlocked_tentacle",
		sprite 		= "data/ui_gfx/gun_actions/tentacle_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_timer_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- TENTACLE_TIMER
		spawn_probability                 = "0.6,0.6,0.6,0.6", -- TENTACLE_TIMER
		price = 250,
		mana = 20,
		--max_uses = 40,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle_timer.xml",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/tentacle.xml",20,1)
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	--[[
	{
		id          = "BLOODTENTACLE",
		name 		= "$action_bloodtentacle",
		description = "$actiondesc_bloodtentacle",
		spawn_requires_flag = "card_unlocked_pyramid",
		sprite 		= "data/ui_gfx/gun_actions/bloodtentacle.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/tentacle_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/bloodtentacle.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- TENTACLE
		spawn_probability                 = "0.2,0.5,1,1", -- TENTACLE
		price = 170,
		mana = 30,
		--max_uses = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bloodtentacle.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	]]--
	{
		id          = "HEAL_BULLET",
		name 		= "$action_heal_bullet",
		description = "$actiondesc_heal_bullet",
		sprite 		= "data/ui_gfx/gun_actions/heal_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heal_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/heal_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4", -- HEAL_BULLET
		spawn_probability                 = "1,1,1", -- HEAL_BULLET
		price = 60,
		mana = 15,
		max_uses = 20,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/heal_bullet.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/heal_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.spread_degrees = c.spread_degrees + 2.0
		end,
	},
	{
		id          = "SPIRAL_SHOT",
		name 		= "$action_spiral_shot",
		description = "$actiondesc_spiral_shot",
		spawn_requires_flag = "card_unlocked_spiral_shot",
		sprite 		= "data/ui_gfx/gun_actions/spiral_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spiral_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1", -- SPIRAL_SHOT
		price = 190,
		mana = 50,
		max_uses    = 15, 
		custom_xml_file = "data/entities/misc/custom_cards/spiral_shot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spiral_shot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "MAGIC_SHIELD",
		name 		= "$action_magic_shield",
		description = "$actiondesc_magic_shield",
		sprite 		= "data/ui_gfx/gun_actions/magic_shield.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/magic_shield_start.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.5,0.5,1,1", -- SPIRAL_SHOT
		price = 100,
		mana = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/magic_shield_start.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "BIG_MAGIC_SHIELD",
		name 		= "$action_big_magic_shield",
		description = "$actiondesc_big_magic_shield",
		sprite 		= "data/ui_gfx/gun_actions/big_magic_shield.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/big_magic_shield_start.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.2,0.5,0.5,0.1", -- SPIRAL_SHOT
		price = 120,
		mana = 60,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/big_magic_shield_start.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "CHAIN_BOLT",
		name 		= "$action_chain_bolt",
		description = "$actiondesc_chain_bolt",
		sprite 		= "data/ui_gfx/gun_actions/chain_bolt.png",
		related_projectiles	= {"data/entities/projectiles/deck/chain_bolt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,4,5,6", -- CHAIN_BOLT
		spawn_probability                 = "1,1,1,1", -- CHAIN_BOLT
		price = 240,
		mana = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chain_bolt.xml")
			c.spread_degrees = c.spread_degrees + 14.0
			c.fire_rate_wait = c.fire_rate_wait + 45
		end,
	},
	{
		id          = "FIREBALL",
		name 		= "$action_fireball",
		description = "$actiondesc_fireball",
		sprite 		= "data/ui_gfx/gun_actions/fireball.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fireball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,3,4,6", -- FIREBALL
		spawn_probability                 = "1,1,1,1", -- FIREBALL
		price = 220,
		mana = 70,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/fireball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fireball.xml")
			c.spread_degrees = c.spread_degrees + 4.0
			c.fire_rate_wait = c.fire_rate_wait + 50
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "METEOR",
		name 		= "$action_meteor",
		description = "$actiondesc_meteor",
		sprite 		= "data/ui_gfx/gun_actions/meteor.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/meteor_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/meteor.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,10", -- METEOR
		spawn_probability                 = "0.6,0.6,0.6,0.5", -- METEOR
		price = 280,
		mana = 150,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/meteor.xml")
		end,
	},
	{
		id          = "FLAMETHROWER",
		name 		= "$action_flamethrower",
		description = "$actiondesc_flamethrower",
		sprite 		= "data/ui_gfx/gun_actions/flamethrower.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/flamethrower_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/flamethrower.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,6", -- FLAMETHROWER
		spawn_probability                 = "1,1,1", -- FLAMETHROWER
		price = 220,
		mana = 20,
		max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/flamethrower.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/flamethrower.xml")
			c.spread_degrees = c.spread_degrees + 4.0
		end,
	},
	{
		id          = "ICEBALL",
		name 		= "$action_iceball",
		description = "$actiondesc_iceball",
		sprite 		= "data/ui_gfx/gun_actions/iceball.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fireball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/iceball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,6", -- FIREBALL
		spawn_probability                 = "1,1,1,1", -- FIREBALL
		price = 260,
		mana = 90,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/iceball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/iceball.xml")
			c.spread_degrees = c.spread_degrees + 8.0
			c.fire_rate_wait = c.fire_rate_wait + 80
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	--[[
	{
		id          = "ICETHROWER",
		name 		= "$action_icethrower",
		description = "$actiondesc_icethrower",
		sprite 		= "data/ui_gfx/gun_actions/icethrower.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- ICETHROWER
		spawn_probability                        = "", -- ICETHROWER
		price = 260,
		mana = 20,
		max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/icethrower.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/icethrower.xml")
			c.spread_degrees = c.spread_degrees + 2.0
		end,
	},
	]]--
	{
		id          = "SLIMEBALL",
		name 		= "$action_slimeball",
		description = "$actiondesc_slimeball",
		sprite 		= "data/ui_gfx/gun_actions/slimeball.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/slime.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,3,4", -- SLIMEBALL
		spawn_probability                 = "1,1,1", -- SLIMEBALL
		price = 130,
		mana = 20,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/slimeball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/slime.xml")
			c.spread_degrees = c.spread_degrees + 4.0
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier * 1.1
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "DARKFLAME",
		name 		= "$action_darkflame",
		description = "$actiondesc_darkflame",
		sprite 		= "data/ui_gfx/gun_actions/darkflame.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/darkflame_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/darkflame.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,5,6", -- DARKFLAME
		spawn_probability                 = "1,1,1", -- DARKFLAME
		price = 180,
		mana = 90,
		custom_xml_file = "data/entities/misc/custom_cards/darkflame.xml",
		max_uses    = 60, 
		action 		= function()
			add_projectile("data/entities/projectiles/darkflame.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "MISSILE",
		name 		= "$action_missile",
		description = "$actiondesc_missile",
		sprite 		= "data/ui_gfx/gun_actions/missile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,5", -- MISSILE
		spawn_probability                        = "0.5,0.5,1,1", -- MISSILE
		price = 200,
		mana = 60,
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_player.xml")
			current_reload_time = current_reload_time + 30
			c.spread_degrees = c.spread_degrees + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end,
	},
	{
		id          = "FUNKY_SPELL",
		name 		= "???",
		description = "???",
		sprite 		= "data/ui_gfx/gun_actions/machinegun_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/machinegun_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_requires_flag = "card_unlocked_funky",
		spawn_level                       = "6,10", -- LIGHT_BULLET
		spawn_probability                 = "0.1,0.1", -- LIGHT_BULLET
		price = 50,
		mana = 5,
		--max_uses = -1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/machinegun_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.2
			c.spread_degrees = c.spread_degrees + 2.0
			c.damage_critical_chance = c.damage_critical_chance + 1
		end,
	},
	{
		id          = "PEBBLE",
		name 		= "$action_pebble",
		description = "$actiondesc_pebble",
		sprite 		= "data/ui_gfx/gun_actions/pebble.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/pebble_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/pebble_player.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- PEBBLE
		spawn_probability                 = "1,1,1,1", -- PEBBLE
		price = 200,
		mana = 120,
		max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pebble_player.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "DYNAMITE",
		name 		= "$action_dynamite",
		description = "$actiondesc_dynamite",
		sprite 		= "data/ui_gfx/gun_actions/dynamite.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tnt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- DYNAMITE
		spawn_probability                 = "1,1,1,1,1", -- DYNAMITE
		price = 160,
		mana = 50,
		max_uses    = 16,
		custom_xml_file = "data/entities/misc/custom_cards/tnt.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tnt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			c.spread_degrees = c.spread_degrees + 6.0
		end,
	},
	{
		id          = "GLITTER_BOMB",
		name 		= "$action_glitter_bomb",
		description = "$actiondesc_glitter_bomb",
		sprite 		= "data/ui_gfx/gun_actions/glitter_bomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glitter_bomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- GLITTER_BOMB
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8", -- GLITTER_BOMB
		price = 200,
		mana = 70,
		max_uses	= 16,
		custom_xml_file = "data/entities/misc/custom_cards/glitter_bomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			c.spread_degrees = c.spread_degrees + 12.0
		end,
	},
	{
		id          = "BUCKSHOT",
		name 		= "$action_buckshot",
		description = "$actiondesc_buckshot",
		sprite 		= "data/ui_gfx/gun_actions/buckshot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/buckshot_player.xml",3},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4", -- BUCKSHOT
		spawn_probability                 = "1,1,1,1,1", -- BUCKSHOT
		price = 160,
		mana = 25,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			add_projectile("data/entities/projectiles/deck/buckshot_player.xml")
			c.fire_rate_wait = c.fire_rate_wait + 8
			c.spread_degrees = c.spread_degrees + 14.0
		end,
	},
	{
		id          = "FREEZING_GAZE",
		name 		= "$action_freezing_gaze",
		description = "$actiondesc_freezing_gaze",
		sprite 		= "data/ui_gfx/gun_actions/freezing_gaze.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/freezing_gaze_beam.xml",12},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4", -- FREEZING_GAZE
		spawn_probability                 = "1,1,1", -- FREEZING_GAZE
		price = 180,
		mana = 45,
		max_uses	= 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			add_projectile("data/entities/projectiles/deck/freezing_gaze_beam.xml")
			c.pattern_degrees = 30
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "GLOWING_BOLT",
		name 		= "$action_glowing_bolt",
		description = "$actiondesc_glowing_bolt",
		sprite 		= "data/ui_gfx/gun_actions/glowing_bolt.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glowing_bolt.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,10", -- FREEZING_GAZE
		spawn_probability                 = "1,1,1,0.1", -- FREEZING_GAZE
		price = 220,
		mana = 65,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glowing_bolt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.spread_degrees = c.spread_degrees + 6.0
		end,
	},
	--[[
	{
		id          = "BOMB_LEGACY",
		name 		= "$action_bomb_legacy",
		description = "$actiondesc_bomb_legacy",
		sprite 		= "data/ui_gfx/gun_actions/bomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- BOMB_LEGACY
		spawn_probability                 = "", -- BOMB_LEGACY
		price = 200,
		mana = 50, 
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bomb.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	]]--
	{
		id          = "SPORE_POD",
		name 		= "$action_spore_pod",
		description = "$actiondesc_spore_pod",
		sprite 		= "data/ui_gfx/gun_actions/spore_pod.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spore_pod_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/spore_pod.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SPORE_POD
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8", -- SPORE_POD
		price = 200,
		mana = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spore_pod.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "GLUE_SHOT",
		name 		= "$action_glue_shot",
		description = "$actiondesc_glue_shot",
		sprite 		= "data/ui_gfx/gun_actions/glue_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/glue_shot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5", -- GLUE_SHOT
		spawn_probability                 = "0.6,0.2,0.2,0.6", -- GLUE_SHOT
		price = 140,
		mana = 25,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/glue_shot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.spread_degrees = c.spread_degrees + 5.0
		end,
	},
	{
		id          = "BOMB_HOLY",
		name 		= "$action_bomb_holy",
		description = "$actiondesc_bomb_holy",
		spawn_requires_flag = "card_unlocked_bomb_holy",
		sprite 		= "data/ui_gfx/gun_actions/bomb_holy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_holy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- BOMB_HOLY
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2,0.5", -- BOMB_HOLY
		price = 400,
		mana = 300, 
		max_uses    = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_holy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_holy.xml")
			current_reload_time = current_reload_time + 80
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "BOMB_HOLY_GIGA",
		name 		= "$action_bomb_holy_giga",
		description = "$actiondesc_bomb_holy_giga",
		spawn_requires_flag = "card_unlocked_bomb_holy_giga",
		sprite 		= "data/ui_gfx/gun_actions/bomb_holy_giga.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_holy_giga.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "10", -- BOMB_HOLY
		spawn_probability                 = "1", -- BOMB_HOLY
		price = 600,
		mana = 600, 
		max_uses    = 2,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/bomb_holy_giga.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_holy_giga.xml")
			current_reload_time = current_reload_time + 160
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
			c.fire_rate_wait = c.fire_rate_wait + 120
		end,
	},
	{
		id          = "PROPANE_TANK",
		name 		= "$action_propane_tank",
		description = "$actiondesc_propane_tank",
		sprite 		= "data/ui_gfx/gun_actions/propane_tank.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/propane_tank.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- PROPANE_TANK
		spawn_probability                 = "0,0,1,1,1,1,1", -- PROPANE_TANK
		price = 200,
		mana = 75, 
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/propane_tank.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/propane_tank.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
		end,
	},
	{
		id          = "BOMB_CART",
		name 		= "$action_bomb_cart",
		description = "$actiondesc_bomb_cart",
		sprite 		= "data/ui_gfx/gun_actions/bomb_cart.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_cart.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- BOMB_CART
		spawn_probability                 = "0,0,0.6,0.6,0.6,0.6,0.6", -- BOMB_CART
		price = 200,
		mana = 75, 
		max_uses    = 6, 
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_cart.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	{
		id          = "CURSED_ORB",
		name 		= "$action_cursed_orb",
		description = "$actiondesc_cursed_orb",
		sprite 		= "data/ui_gfx/gun_actions/cursed_orb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/orb_cursed.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- CURSED_ORB
		spawn_probability                 = "0.3,0.2,0.1", -- CURSED_ORB
		price = 200,
		mana = 40,
		action 		= function()
			add_projectile("data/entities/projectiles/orb_cursed.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
			shot_effects.recoil_knockback = 40.0
		end,
	},
	{
		id          = "EXPANDING_ORB",
		name 		= "$action_expanding_orb",
		description = "$actiondesc_expanding_orb",
		sprite 		= "data/ui_gfx/gun_actions/expanding_orb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/orb_expanding.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- CURSED_ORB
		spawn_probability                 = "0.5,0.5,1.0,1.0,1.0", -- CURSED_ORB
		price = 200,
		mana = 70,
		action 		= function()
			add_projectile("data/entities/projectiles/orb_expanding.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "CRUMBLING_EARTH",
		name 		= "$action_crumbling_earth",
		description = "$actiondesc_crumbling_earth",
		spawn_requires_flag = "card_unlocked_crumbling_earth",
		sprite 		= "data/ui_gfx/gun_actions/crumbling_earth.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/crumbling_earth.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- CRUMBLING_EARTH
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- CRUMBLING_EARTH
		price = 300,
		mana = 240, 
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/crumbling_earth.xml")
		end,
	},
	{
		id          = "SUMMON_ROCK",
		name 		= "$action_summon_rock",
		description = "$actiondesc_summon_rock",
		sprite 		= "data/ui_gfx/gun_actions/summon_rock.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/rock.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- SUMMON_ROCK
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8,0.8", -- SUMMON_ROCK
		price = 160,
		mana = 100, 
		max_uses    = 3, 
		custom_xml_file = "data/entities/misc/custom_cards/summon_rock.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rock.xml")
		end,
	},
	{
		id          = "SUMMON_EGG",
		name 		= "$action_summon_egg",
		description = "$actiondesc_summon_egg",
		sprite 		= "data/ui_gfx/gun_actions/summon_egg.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/items/pickup/egg_monster.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- SUMMON_EGG
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8,0.8", -- SUMMON_EGG
		price = 220,
		mana = 100, 
		max_uses    = 2, 
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local types = {"monster","slime","red","fire"}
			local rnd = Random(1, #types)
			local egg_name = "egg_" .. tostring(types[rnd]) .. ".xml"
			add_projectile("data/entities/items/pickup/" .. egg_name)
		end,
	},
	{
		id          = "SUMMON_HOLLOW_EGG",
		name 		= "$action_summon_hollow_egg",
		description = "$actiondesc_summon_hollow_egg",
		sprite 		= "data/ui_gfx/gun_actions/summon_hollow_egg.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/items/pickup/egg_hollow.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- SUMMON_HOLLOW_EGG
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8,0.8", -- SUMMON_HOLLOW_EGG
		price = 140,
		mana = 30, 
		action 		= function()
			add_projectile_trigger_death("data/entities/items/pickup/egg_hollow.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait - 12
		end,
	},
	{
		id          = "TNTBOX",
		name 		= "$action_tntbox",
		description = "$actiondesc_tntbox",
		sprite 		= "data/ui_gfx/gun_actions/tntbox.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tntbox.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SUMMON_ROCK
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8", -- SUMMON_ROCK
		price = 150,
		mana = 40, 
		max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tntbox.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "TNTBOX_BIG",
		name 		= "$action_tntbox_big",
		description = "$actiondesc_tntbox_big",
		sprite 		= "data/ui_gfx/gun_actions/tntbox_big.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/tntbox_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5", -- SUMMON_ROCK
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8", -- SUMMON_ROCK
		price = 170,
		mana = 40, 
		max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tntbox_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "SWARM_FLY",
		name 		= "$action_swarm_fly",
		description = "$actiondesc_swarm_fly",
		sprite 		= "data/ui_gfx/gun_actions/swarm_fly.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/swarm_fly.xml",5},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.2,0.5,0.5", -- SPIRAL_SHOT
		price = 90,
		mana = 70,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/swarm_fly.xml")
			add_projectile("data/entities/projectiles/deck/swarm_fly.xml")
			add_projectile("data/entities/projectiles/deck/swarm_fly.xml")
			add_projectile("data/entities/projectiles/deck/swarm_fly.xml")
			add_projectile("data/entities/projectiles/deck/swarm_fly.xml")
			c.spread_degrees = c.spread_degrees + 6.0
			c.fire_rate_wait = c.fire_rate_wait + 60
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "SWARM_FIREBUG",
		name 		= "$action_swarm_firebug",
		description = "$actiondesc_swarm_firebug",
		sprite 		= "data/ui_gfx/gun_actions/swarm_firebug.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/swarm_firebug.xml",4},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.2,0.5,0.5", -- SPIRAL_SHOT
		price = 100,
		mana = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/swarm_firebug.xml")
			add_projectile("data/entities/projectiles/deck/swarm_firebug.xml")
			c.spread_degrees = c.spread_degrees + 12.0
			c.fire_rate_wait = c.fire_rate_wait + 60
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "SWARM_WASP",
		name 		= "$action_swarm_wasp",
		description = "$actiondesc_swarm_wasp",
		sprite 		= "data/ui_gfx/gun_actions/swarm_wasp.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/swarm_wasp.xml",6},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.2,0.5,0.5", -- SPIRAL_SHOT
		price = 120,
		mana = 90,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			add_projectile("data/entities/projectiles/deck/swarm_wasp.xml")
			c.spread_degrees = c.spread_degrees + 24.0
			c.fire_rate_wait = c.fire_rate_wait + 60
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "FRIEND_FLY",
		name 		= "$action_friend_fly",
		description = "$actiondesc_friend_fly",
		sprite 		= "data/ui_gfx/gun_actions/friend_fly.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spiral_shot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/friend_fly.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "0.2,0.5,0.5", -- SPIRAL_SHOT
		price = 160,
		mana = 120,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/friend_fly.xml")
			c.spread_degrees = c.spread_degrees + 24.0
			c.fire_rate_wait = c.fire_rate_wait + 80
			current_reload_time = current_reload_time + 40
		end,
	},
	--[[
	{
		id          = "KNIFE",
		name 		= "$action_knife",
		description = "$actiondesc_knife",
		sprite 		= "data/ui_gfx/gun_actions/knife.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- KNIFE
		spawn_probability                 = "", -- KNIFE
		price = 200,
		mana = 50, 
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/knife.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/knife.xml")
		end,
	},
	{
		id          = "CIRCLESHOT_A",
		name 		= "$action_circleshot_a",
		description = "$actiondesc_circleshot_a",
		sprite 		= "data/ui_gfx/gun_actions/phantomshot_a.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- CIRCLESHOT_A
		spawn_probability                        = "", -- CIRCLESHOT_A
		price = 100,
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_a.xml",
		max_uses    = 40, 
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner_green.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "CIRCLESHOT_B",
		name 		= "$action_circleshot_b",
		description = "$actiondesc_circleshot_b",
		sprite 		= "data/ui_gfx/gun_actions/phantomshot_b.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- CIRCLESHOT_B
		spawn_probability                        = "", -- CIRCLESHOT_B
		price = 100,
		mana = 80,
		max_uses    = 40, 
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_b.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	]]--
	{
		id          = "ACIDSHOT",
		name 		= "$action_acidshot",
		description = "$actiondesc_acidshot",
		sprite 		= "data/ui_gfx/gun_actions/acidshot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/acidshot_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/acidshot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- ACIDSHOT
		spawn_probability                 = "1,1,1,1", -- ACIDSHOT
		price = 180,
		mana = 20,
		max_uses = 20,
		custom_xml_file = "data/entities/misc/custom_cards/acidshot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/acidshot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "THUNDERBALL",
		name 		= "$action_thunderball",
		description = "$actiondesc_thunderball",
		sprite 		= "data/ui_gfx/gun_actions/thunderball.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/thunderball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/thunderball.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,6,10", -- THUNDERBALL
		spawn_probability                 = "1,1,1,0.2", -- THUNDERBALL
		price = 300,
		mana = 120,
		max_uses    = 3, 
		custom_xml_file = "data/entities/misc/custom_cards/thunderball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/thunderball.xml")
			c.fire_rate_wait = c.fire_rate_wait + 120
		end,
	},
	--[[
	{
		id          = "BLOOMSHOT",
		name 		= "$action_bloomshot",
		description = "$actiondesc_bloomshot",
		sprite 		= "data/ui_gfx/gun_actions/bloomshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- BLOOMSHOT
		spawn_probability                        = "", -- BLOOMSHOT
		price = 150,
		mana = 80,
		max_uses    = 30, 
		custom_xml_file = "data/entities/misc/custom_cards/bloomshot.xml",
		-- max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/bloomshot.xml")
			current_reload_time = current_reload_time + 40
		end,
	},
	{
		id          = "ICECIRCLE",
		name 		= "$action_icecircle",
		description = "$actiondesc_icecircle",
		sprite 		= "data/ui_gfx/gun_actions/icecircle.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- ICECIRCLE
		spawn_probability                        = "", -- ICECIRCLE
		price = 130,
		mana = 100,
		max_uses    = 30, 
		custom_xml_file = "data/entities/misc/custom_cards/icecircle.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/iceskull_explosion.xml")
			current_reload_time = current_reload_time + 60
		end,
	},
	]]--
	{
		id          = "FIREBOMB",
		name 		= "$action_firebomb",
		description = "$actiondesc_firebomb",
		sprite 		= "data/ui_gfx/gun_actions/firebomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/firebomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/firebomb.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3", -- FIREBOMB
		spawn_probability                 = "1,1,1", -- FIREBOMB
		price = 90,
		mana = 10,
		--max_uses    = 70, 
		custom_xml_file = "data/entities/misc/custom_cards/firebomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/firebomb.xml")
		end,
	},
	{
		id          = "SOILBALL",
		name 		= "$action_soilball",
		description = "$actiondesc_soilball",
		sprite 		= "data/ui_gfx/gun_actions/soil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/firebomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/chunk_of_soil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,5", -- SOILBALL
		spawn_probability                 = "1,1,1,1", -- SOILBALL
		price = 10,
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/chunk_of_soil.xml")
		end,
	},
	--[[
	{
		id          = "PINK_ORB",
		name 		= "$action_pink_orb",
		description = "$actiondesc_pink_orb",
		sprite 		= "data/ui_gfx/gun_actions/pink_orb.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- PINK_ORB
		spawn_probability                        = "", -- PINK_ORB
		price = 160,
		mana = 60,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/pink_orb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pink_orb.xml")
			current_reload_time = current_reload_time + 40
		end,
	},
	]]--
	{
		id          = "DEATH_CROSS",
		name 		= "$action_death_cross",
		description = "$actiondesc_death_cross",
		sprite 		= "data/ui_gfx/gun_actions/death_cross.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/death_cross.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- DEATH_CROSS
		spawn_probability                        = "1,0.6,0.6,0.6,0.6,0.6", -- DEATH_CROSS
		price = 210,
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/death_cross.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "DEATH_CROSS_BIG",
		name 		= "$action_death_cross_big",
		description = "$actiondesc_death_cross_big",
		sprite 		= "data/ui_gfx/gun_actions/death_cross_big.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/death_cross_big.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- DEATH_CROSS_BIG
		spawn_probability                        = "0.4,0.4,0.4,0.4,0.4,0.2", -- DEATH_CROSS_BIG
		price = 310,
		mana = 150,
		max_uses = 8,
		custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/death_cross_big.xml")
			c.fire_rate_wait = c.fire_rate_wait + 70
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "INFESTATION",
		name 		= "$action_infestation",
		description = "$actiondesc_infestation",
		sprite 		= "data/ui_gfx/gun_actions/infestation.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/infestation.xml",10},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4", -- RUBBER_BALL
		spawn_probability                 = "0.1,0.3,0.3", -- RUBBER_BALL
		price = 160,
		mana = 40,
		--max_uses = 150,
		action 		= function()
			for i=1,6 do
				add_projectile("data/entities/projectiles/deck/infestation.xml")
			end
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait - 2
			c.spread_degrees = c.spread_degrees + 25
		end,
	},
	{
		id          = "WALL_HORIZONTAL",
		name 		= "$action_wall_horizontal",
		description = "$actiondesc_wall_horizontal",
		sprite 		= "data/ui_gfx/gun_actions/wall_horizontal.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_horizontal.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_HORIZONTAL
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- WALL_HORIZONTAL
		price = 160,
		mana = 70,
		--max_uses = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_horizontal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
		end,
	},
	{
		id          = "WALL_VERTICAL",
		name 		= "$action_wall_vertical",
		description = "$actiondesc_wall_vertical",
		sprite 		= "data/ui_gfx/gun_actions/wall_vertical.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_vertical.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_VERTICAL
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- WALL_VERTICAL
		price = 160,
		mana = 70,
		--max_uses = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_vertical.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
		end,
	},
	{
		id          = "WALL_SQUARE",
		name 		= "$action_wall_square",
		description = "$actiondesc_wall_square",
		sprite 		= "data/ui_gfx/gun_actions/wall_square.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wall_square.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_SQUARE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- WALL_SQUARE
		price = 160,
		mana = 70,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wall_square.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "TEMPORARY_WALL",
		name 		= "$action_temporary_wall",
		description = "$actiondesc_temporary_wall",
		sprite 		= "data/ui_gfx/gun_actions/temporary_wall.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/temporary_wall.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_SQUARE
		spawn_probability                 = "0.1,0.1,0.3,0.4,0.2,0.1", -- WALL_SQUARE
		price = 100,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/temporary_wall.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "TEMPORARY_PLATFORM",
		name 		= "$action_temporary_platform",
		description = "$actiondesc_temporary_platform",
		sprite 		= "data/ui_gfx/gun_actions/temporary_platform.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/temporary_platform.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5,6", -- WALL_SQUARE
		spawn_probability                 = "0.1,0.1,0.3,0.4,0.2,0.1", -- WALL_SQUARE
		price = 90,
		mana = 30,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/temporary_platform.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "PURPLE_EXPLOSION_FIELD",
		name 		= "$action_purple_explosion_field",
		description = "$actiondesc_purple_explosion_field",
		sprite 		= "data/ui_gfx/gun_actions/purple_explosion_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/purple_explosion_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- PURPLE_EXPLOSION_FIELD
		spawn_probability                 = "1,1,1,1,1,1", -- PURPLE_EXPLOSION_FIELD
		price = 160,
		mana = 90,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/purple_explosion_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier - 2
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "DELAYED_SPELL",
		name 		= "$action_delayed_spell",
		description = "$actiondesc_delayed_spell",
		sprite 		= "data/ui_gfx/gun_actions/delayed_spell.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/delayed_spell.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- DELAYED_SPELL
		spawn_probability                 = "1,1,1,1,1,1", -- DELAYED_SPELL
		price = 240,
		mana = 20,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/delayed_spell.xml", 3)
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "LONG_DISTANCE_CAST",
		name 		= "$action_long_distance_cast",
		description = "$actiondesc_long_distance_cast",
		sprite 		= "data/ui_gfx/gun_actions/long_distance_cast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/long_distance_cast.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5,6", -- LONG_DISTANCE_CAST
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6,0.6", -- LONG_DISTANCE_CAST
		price = 90,
		mana = 0,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/long_distance_cast.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait - 5
		end,
	},
	{
		id          = "TELEPORT_CAST",
		name 		= "$action_teleport_cast",
		description = "$actiondesc_teleport_cast",
		sprite 		= "data/ui_gfx/gun_actions/teleport_cast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_cast.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_CAST
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6,0.6", -- TELEPORT_CAST
		price = 190,
		mana = 100,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/teleport_cast.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.spread_degrees = c.spread_degrees + 24
		end,
	},
	{
		id          = "SUPER_TELEPORT_CAST",
		name 		= "$action_super_teleport_cast",
		description = "$actiondesc_super_teleport_cast",
		sprite 		= "data/ui_gfx/gun_actions/super_teleport_cast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/super_teleport_cast.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_CAST
		spawn_probability                 = "0.2,0.2,0.2,0.6,0.6,0.6", -- TELEPORT_CAST
		price = 160,
		mana = 20,
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/super_teleport_cast.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees - 6
		end,
	},
	--[[
	{
		id          = "COMMANDER_BULLET",
		name 		= "$action_commander_bullet",
		description = "$actiondesc_commander_bullet",
		sprite 		= "data/ui_gfx/gun_actions/commander_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- COMMANDER_BULLET
		spawn_probability                 = "", -- COMMANDER_BULLET
		price = 160,
		mana = 50,
		--max_uses = 80,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/commander_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 3, true )
		end,
	},
	{
		id          = "PLASMA_FLARE",
		name 		= "$action_plasma_flare",
		description = "$actiondesc_plasma_flare",
		sprite 		= "data/ui_gfx/gun_actions/plasma_flare.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- PLASMA_FLARE
		spawn_probability                        = "", -- PLASMA_FLARE
		price = 230,
		mana = 40,
		max_uses    = 30, 
		custom_xml_file = "data/entities/misc/custom_cards/plasma_flare.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/orb_pink_fast.xml")
		end,
	},
	{
		id          = "KEYSHOT",
		name 		= "$action_keyshot",
		description = "$actiondesc_keyshot",
		sprite 		= "data/ui_gfx/gun_actions/keyshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- KEYSHOT
		spawn_probability                        = "", -- KEYSHOT
		price = 999,
		mana = 300,
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/keyshot.xml")
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "MANA",
		name 		= "$action_mana",
		description = "$actiondesc_mana",
		sprite 		= "data/ui_gfx/gun_actions/mana.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- MANA
		spawn_probability                        = "", -- MANA
		price = 100,
		mana = -200,
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/mana.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mana.xml")
		end,
	},
	{
		id          = "SKULL",
		name 		= "$action_skull",
		description = "$actiondesc_skull",
		sprite 		= "data/ui_gfx/gun_actions/skull.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- SKULL
		spawn_probability                        = "", -- SKULL
		price = 150,
		mana = 60,
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/skull.xml")
		end,
	},
	-- DEBUG REMOVE ME --
	{
		id          = "MATERIAL_DEBUG",
		name 		= "$action_material_debug",
		description = "$actiondesc_material_debug",
		sprite 		= "data/ui_gfx/gun_actions/material_debug.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_DEBUG
		spawn_probability                 = "", -- MATERIAL_DEBUG
		price = 100,
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_debug.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_LIQUID",
		name 		= "$action_material_liquid",
		description = "$actiondesc_material_liquid",
		sprite 		= "data/ui_gfx/gun_actions/material_liquid.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_LIQUID
		spawn_probability                 = "", -- MATERIAL_LIQUID
		price = 100,
		mana = 0,
		custom_xml_file = "data/entities/misc/custom_cards/material_liquid.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_liquid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	]]--
	{
		id          = "MIST_RADIOACTIVE",
		name 		= "$action_mist_radioactive",
		description = "$actiondesc_mist_radioactive",
		sprite 		= "data/ui_gfx/gun_actions/mist_radioactive.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_radioactive.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_RADIOACTIVE
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- MIST_RADIOACTIVE
		price = 80,
		mana = 40,
		--max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mist_radioactive.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "MIST_ALCOHOL",
		name 		= "$action_mist_alcohol",
		description = "$actiondesc_mist_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/mist_alcohol.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_alcohol.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_ALCOHOL
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- MIST_ALCOHOL
		price = 80,
		mana = 40,
		--max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mist_alcohol.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "MIST_SLIME",
		name 		= "$action_mist_slime",
		description = "$actiondesc_mist_slime",
		sprite 		= "data/ui_gfx/gun_actions/mist_slime.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_slime.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_SLIME
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- MIST_SLIME
		price = 80,
		mana = 40,
		--max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mist_slime.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "MIST_BLOOD",
		name 		= "$action_mist_blood",
		description = "$actiondesc_mist_blood",
		sprite 		= "data/ui_gfx/gun_actions/mist_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/mist_blood.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- MIST_BLOOD
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- MIST_BLOOD
		price = 120,
		mana = 40,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mist_blood.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "CIRCLE_FIRE",
		name 		= "$action_circle_fire",
		description = "$actiondesc_circle_fire",
		sprite 		= "data/ui_gfx/gun_actions/circle_fire.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_fire.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_FIRE
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- CIRCLE_FIRE
		price = 170,
		mana = 20,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/circle_fire.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "CIRCLE_ACID",
		name 		= "$action_circle_acid",
		description = "$actiondesc_circle_acid",
		sprite 		= "data/ui_gfx/gun_actions/circle_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_acid.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_ACID
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- CIRCLE_ACID
		price = 180,
		mana = 40,
		max_uses = 4,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/circle_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "CIRCLE_OIL",
		name 		= "$action_circle_oil",
		description = "$actiondesc_circle_oil",
		sprite 		= "data/ui_gfx/gun_actions/circle_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_OIL
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- CIRCLE_OIL
		price = 160,
		mana = 20,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/circle_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	{
		id          = "CIRCLE_WATER",
		name 		= "$action_circle_water",
		description = "$actiondesc_circle_water",
		sprite 		= "data/ui_gfx/gun_actions/circle_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/circle_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4", -- CIRCLE_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- CIRCLE_WATER
		price = 160,
		mana = 20,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/circle_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},
	-- Materials --
	{
		id          = "MATERIAL_WATER",
		name 		= "$action_material_water",
		description = "$actiondesc_material_water",
		sprite 		= "data/ui_gfx/gun_actions/material_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_WATER
		price = 110,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_water.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_wet.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_OIL",
		name 		= "$action_material_oil",
		description = "$actiondesc_material_oil",
		sprite 		= "data/ui_gfx/gun_actions/material_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_oil_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_OIL
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_OIL
		price = 140,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_oil.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_oiled.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	-- Note( Petri ): 10.7.2019 - this could be just removed (vampirism, the limited uses in these is extremely silly)
	{
		id          = "MATERIAL_BLOOD",
		name 		= "$action_material_blood",
		description = "$actiondesc_material_blood",
		sprite 		= "data/ui_gfx/gun_actions/material_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_blood_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_blood.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5", -- MATERIAL_BLOOD
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_BLOOD
		price = 130,
		max_uses = 250,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_blood.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_bloody.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_ACID",
		name 		= "$action_material_acid",
		description = "$actiondesc_material_acid",
		sprite 		= "data/ui_gfx/gun_actions/material_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_acid.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "2,3,4,5,6", -- MATERIAL_ACID
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_ACID
		price = 150,
		-- Note( Petri ): 10.7.2019 - removed uses. We have acid trail already
		-- max_uses = 250,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_CEMENT",
		name 		= "$action_material_cement",
		description = "$actiondesc_material_cement",
		spawn_requires_flag = "card_unlocked_material_cement",
		sprite 		= "data/ui_gfx/gun_actions/material_cement.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_cement_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/material_cement.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "2,3,4,5,6", -- MATERIAL_CEMENT
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_CEMENT
		price = 100,
		-- Note( Petri ): 10.7.2019 - removed uses. We have acid trail already
		-- max_uses = 250,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_cement.xml")
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	--[[
	{
		id          = "MATERIAL_LAVA",
		name 		= "$action_material_lava",
		description = "$actiondesc_material_lava",
		sprite 		= "data/ui_gfx/gun_actions/material_lava.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_LAVA
		spawn_probability                 = "", -- MATERIAL_LAVA
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_lava.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_GUNPOWDER_EXPLOSIVE",
		name 		= "$action_material_gunpowder_explosive",
		description = "$actiondesc_material_gunpowder_explosive",
		sprite 		= "data/ui_gfx/gun_actions/material_gunpowder_explosive.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		spawn_probability                 = "", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_gunpowder_explosive.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_DIRT",
		name 		= "$action_material_dirt",
		description = "$actiondesc_material_dirt",
		sprite 		= "data/ui_gfx/gun_actions/material_dirt.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_DIRT
		spawn_probability                 = "", -- MATERIAL_DIRT
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_dirt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "BUILDING_BOARD_WOOD",
		name 		= "$action_building_board_wood",
		description = "$actiondesc_building_board_wood",
		sprite 		= "data/ui_gfx/gun_actions/building_board_wood.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_BOARD_WOOD
		spawn_probability                 = "", -- BUILDING_BOARD_WOOD
		price = 100,
		mana = 1,
		max_uses    = 3,
		custom_uses_logic = true,
		custom_xml_file = "data/entities/misc/custom_cards/action_building_board_wood.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
		end,
	},
	{
		id          = "BUILDING_BACK_WALL_ROCK",
		name 		= "$action_building_back_wall_rock",
		description = "$actiondesc_building_back_wall_rock",
		sprite 		= "data/ui_gfx/gun_actions/building_back_wall_rock.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_BACK_WALL_ROCK
		spawn_probability                 = "", -- BUILDING_BACK_WALL_ROCK
		price = 100,
		mana = 1,
		max_uses    = 3,
		custom_uses_logic = true,
		custom_xml_file = "data/entities/misc/custom_cards/action_building_back_wall.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 
		end,
	},
	{
		id          = "BUILDING_PRESSURE_PLATE",
		name 		= "$action_building_pressure_plate",
		description = "$actiondesc_building_pressure_plate",
		sprite 		= "data/ui_gfx/gun_actions/building_pressure_plate.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_PRESSURE_PLATE
		spawn_probability                 = "", -- BUILDING_PRESSURE_PLATE
		price = 100,
		mana = 1,
		max_uses    = 3,
		custom_uses_logic = true,
		custom_xml_file = "data/entities/misc/custom_cards/action_building_pressure_plate.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
		end,
	},
	{
		id          = "BUILDING_PHYSICS_TEMPLEDOOR",
		name 		= "$action_building_physics_templedoor",
		description = "$actiondesc_building_physics_templedoor",
		sprite 		= "data/ui_gfx/gun_actions/building_physics_templedoor.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_PHYSICS_TEMPLEDOOR
		spawn_probability                 = "", -- BUILDING_PHYSICS_TEMPLEDOOR
		price = 100,
		mana = 1,
		max_uses    = 3,
		custom_uses_logic = true,
		custom_xml_file = "data/entities/misc/custom_cards/action_building_physics_templedoor.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
		end,
	},
	]]--
	-- SPELL STUFF
	{
		id          = "TELEPORT_PROJECTILE",
		name 		= "$action_teleport_projectile",
		description = "$actiondesc_teleport_projectile",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 40,
		--max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_SHORT",
		name 		= "$action_teleport_projectile_short",
		description = "$actiondesc_teleport_projectile_short",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile_short.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_short.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 20,
		--max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile_short.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_short.xml")
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_STATIC",
		name 		= "$action_teleport_projectile_static",
		description = "$actiondesc_teleport_projectile_static",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile_static.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_static.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE_STATIC
		spawn_probability                 = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE_STATIC
		price = 90,
		mana = 40,
		--max_uses = 80,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile_static.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_static.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	{
		id          = "SWAPPER_PROJECTILE",
		name 		= "$action_swapper_projectile",
		description = "$actiondesc_swapper_projectile",
		sprite 		= "data/ui_gfx/gun_actions/swapper_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/swapper.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- SWAPPER_PROJECTILE
		spawn_probability                 = "0.05,0.05,0.05,0.05,0.05,0.05", -- SWAPPER_PROJECTILE
		price = 100,
		mana = 5,
		--max_uses = -1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/swapper.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 2.0
			c.damage_critical_chance = c.damage_critical_chance + 5
		end,
	},
	{
		id          = "TELEPORT_PROJECTILE_CLOSER",
		name 		= "$action_teleport_closer",
		description = "$actiondesc_teleport_closer",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile_closer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_closer.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.6,0.6,0.6,0.4,0.4,0.4", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_closer.xml")
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	--[[
	{
		id          = "TELEPORT_HOME",
		name 		= "$action_teleport_home",
		description = "$actiondesc_teleport_home",
		sprite 		= "data/ui_gfx/gun_actions/teleport_home.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- TELEPORT_HOME
		spawn_probability                 = "", -- TELEPORT_HOME
		price = 100,
		mana = 70,
		max_uses    = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_home.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 5.0
		end,
	},
	{
		id          = "LEVITATION_PROJECTILE",
		name 		= "$action_levitation_projectile",
		description = "$actiondesc_levitation_projectile",
		sprite 		= "data/ui_gfx/gun_actions/levitation_projectile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- LEVITATION_PROJECTILE
		spawn_probability                        = "", -- LEVITATION_PROJECTILE
		price = 100,
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/levitation_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},
	]]--
	-- one shot actions -------------------------
	{
		id          = "NUKE",
		name 		= "$action_nuke",
		description = "$actiondesc_nuke",
		spawn_requires_flag = "card_unlocked_nuke",
		sprite 		= "data/ui_gfx/gun_actions/nuke.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/nuke_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/nuke.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,5,6,10", -- NUKE
		spawn_probability                 = "0.3,1,1,0.2", -- NUKE
		price = 400,
		mana = 200,
		max_uses    = 1,
		custom_xml_file = "data/entities/misc/custom_cards/nuke.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/nuke.xml")
			c.fire_rate_wait = 20
			c.speed_multiplier = c.speed_multiplier * 0.75
			c.material = "fire"
			c.material_amount = c.material_amount + 60
			c.ragdoll_fx = 2
			c.gore_particles = c.gore_particles + 10
			c.screenshake = c.screenshake + 10.5
			current_reload_time = current_reload_time + 600
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "NUKE_GIGA",
		name 		= "$action_nuke_giga",
		description = "$actiondesc_nuke_giga",
		sprite 		= "data/ui_gfx/gun_actions/nuke_giga.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/nuke_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/nuke_giga.xml"},
		spawn_requires_flag = "card_unlocked_nukegiga",
		spawn_manual_unlock = true,
		never_unlimited		= true,
		recursive	= true,
		ai_never_uses = true,
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "10", -- NUKE
		spawn_probability                 = "1", -- NUKE
		price = 800,
		mana = 500,
		max_uses    = 1,
		custom_xml_file = "data/entities/misc/custom_cards/nuke_giga.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/nuke_giga.xml")
			c.fire_rate_wait = 50
			c.speed_multiplier = c.speed_multiplier * 0.5
			c.material = "fire"
			c.material_amount = c.material_amount + 80
			c.ragdoll_fx = 2
			c.gore_particles = c.gore_particles + 30
			c.screenshake = c.screenshake + 30.5
			current_reload_time = current_reload_time + 800
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	--[[
	{
		id          = "HIGH_EXPLOSIVE",
		name 		= "$action_high_explosive",
		description = "$actiondesc_high_explosive",
		sprite 		= "data/ui_gfx/gun_actions/high_explosive.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HIGH_EXPLOSIVE
		spawn_probability                        = "", -- HIGH_EXPLOSIVE
		price = 100,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/high_explosive.xml",
		action 		= function()
			c.explosion_radius = c.explosion_radius + 64.0
			c.damage_explosion = c.damage_explosion + 3.2
			c.fire_rate_wait   = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier * 0.75
			c.ragdoll_fx = 2
			c.explosion_damage_to_materials = c.explosion_damage_to_materials + 300000
		end,
	},
	{
		id          = "DRONE",
		name 		= "$action_drone",
		description = "$actiondesc_drone",
		sprite 		= "data/ui_gfx/gun_actions/drone.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- DRONE
		spawn_probability                        = "", -- DRONE
		price = 100,
		mana = 60,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/action_drone.xml",
		action 		= function()
			add_projectile("data/entities/misc/player_drone.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	]]--
	-- all is code --------------------------------------
	--[[{
		id          = "BAAB_IS",
		name 		= "$action_baab_is",
		description = "$actiondesc_baab_is",
		sprite 		= "data/ui_gfx/gun_actions/baab_is.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_is.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_IS
		spawn_probability                 = "", -- BAAB_IS
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "is" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_ALL",
		name 		= "$action_baab_all",
		description = "$actiondesc_baab_all",
		sprite 		= "data/ui_gfx/gun_actions/baab_all.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_all.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_ALL
		spawn_probability                 = "", -- BAAB_ALL
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "all" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_EMPTY",
		name 		= "$action_baab_empty",
		description = "$actiondesc_baab_empty",
		sprite 		= "data/ui_gfx/gun_actions/baab_empty.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_empty.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_EMPTY
		spawn_probability                 = "", -- BAAB_EMPTY
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "empty" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_LAVA",
		name 		= "$action_baab_lava",
		description = "$actiondesc_baab_lava",
		sprite 		= "data/ui_gfx/gun_actions/baab_lava.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_lava.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_LAVA
		spawn_probability                 = "", -- BAAB_LAVA
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "lava" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_WATER",
		name 		= "$action_baab_water",
		description = "$actiondesc_baab_water",
		sprite 		= "data/ui_gfx/gun_actions/baab_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_water.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_WATER
		spawn_probability                 = "", -- BAAB_WATER
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "water" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_POOP",
		name 		= "$action_baab_poop",
		description = "$actiondesc_baab_poop",
		sprite 		= "data/ui_gfx/gun_actions/baab_poop.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_poop.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_POOP
		spawn_probability                 = "", -- BAAB_POOP
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "poo" )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BAAB_LOVE",
		name 		= "$action_baab_love",
		description = "$actiondesc_baab_love",
		sprite 		= "data/ui_gfx/gun_actions/baab_love.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/baab_love.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BAAB_LOVE
		spawn_probability                 = "", -- BAAB_LOVE
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			baab_instruction( "magic_liquid_charm" )
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "FIREWORK",
		name 		= "$action_firework",
		description = "$actiondesc_firework",
		spawn_requires_flag = "card_unlocked_firework",
		sprite 		= "data/ui_gfx/gun_actions/fireworks.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireworks/firework_pink.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- FIREWORK
		spawn_probability                 = "1,1,1,1,1,1", -- FIREWORK
		price = 220,
		mana = 70,
		max_uses    = 25, 
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local types = {"pink","green","blue","orange"}
			local rnd = Random(1, #types)
			local firework_name = "firework_" .. tostring(types[rnd]) .. ".xml"
			add_projectile("data/entities/projectiles/deck/fireworks/" .. firework_name)
			c.fire_rate_wait = c.fire_rate_wait + 60
			--current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 120.0
		end,
	},
	{	
		id          = "SUMMON_WANDGHOST",
		name 		= "$action_summon_wandghost",
		description = "$actiondesc_summon_wandghost",
		sprite 		= "data/ui_gfx/gun_actions/summon_wandghost.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/wand_ghost_player.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,4,5,6,10", -- SUMMON_WANDGHOST
		spawn_probability                 = "0.08,0.1,0.1,0.1,0.1", -- SUMMON_WANDGHOST
		price = 420,
		mana = 300,
		max_uses    = 1, 
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/wand_ghost_player.xml")
			add_projectile("data/entities/particles/image_emitters/wand_effect.xml")
		end,
	},
	{
		id          = "TOUCH_GOLD",
		name 		= "$action_touch_gold",
		description = "$actiondesc_touch_gold",
		sprite 		= "data/ui_gfx/gun_actions/touch_gold.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_gold.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_GOLD
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.5", -- TOUCH_GOLD
		price = 480,
		mana = 300,
		max_uses    = 1,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_gold.xml")
		end,
	},
	{
		id          = "TOUCH_WATER",
		name 		= "$action_touch_water",
		description = "$actiondesc_touch_water",
		sprite 		= "data/ui_gfx/gun_actions/touch_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_WATER
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.1", -- TOUCH_WATER
		price = 420,
		mana = 280,
		max_uses    = 5, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_water.xml")
		end,
	},
	{
		id          = "TOUCH_OIL",
		name 		= "$action_touch_oil",
		description = "$actiondesc_touch_oil",
		sprite 		= "data/ui_gfx/gun_actions/touch_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_OIL
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.1", -- TOUCH_OIL
		price = 380,
		mana = 260,
		max_uses    = 5, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_oil.xml")
		end,
	},
	{
		id          = "TOUCH_ALCOHOL",
		name 		= "$action_touch_alcohol",
		description = "$actiondesc_touch_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/touch_alcohol.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_alcohol.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_ALCOHOL
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.1", -- TOUCH_ALCOHOL
		price = 360,
		mana = 240,
		max_uses    = 5, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_alcohol.xml")
		end,
	},
	{
		id          = "TOUCH_BLOOD",
		name 		= "$action_touch_blood",
		description = "$actiondesc_touch_blood",
		sprite 		= "data/ui_gfx/gun_actions/touch_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_blood.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_BLOOD
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.5", -- TOUCH_BLOOD
		price = 390,
		mana = 270,
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_blood.xml")
		end,
	},
	{
		id          = "TOUCH_SMOKE",
		name 		= "$action_touch_smoke",
		description = "$actiondesc_touch_smoke",
		sprite 		= "data/ui_gfx/gun_actions/touch_smoke.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/touch_smoke.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- TOUCH_SMOKE
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0.1", -- TOUCH_SMOKE
		price = 350,
		mana = 230,
		max_uses    = 5, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/touch_smoke.xml")
		end,
	},
	{
		id          = "DESTRUCTION",
		name 		= "$action_destruction",
		description = "$actiondesc_destruction",
		sprite 		= "data/ui_gfx/gun_actions/destruction.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/destruction.xml"},
		spawn_requires_flag = "card_unlocked_destruction",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10", -- DESTRUCTION
		spawn_probability                 = "1", -- DESTRUCTION
		price = 600,
		mana = 600,
		max_uses    = 5,
		ai_never_uses = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/destruction.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 300
		end,
	},
	-- modifiers
	{
		id          = "BURST_2",
		name 		= "$action_burst_2",
		description = "$actiondesc_burst_2",
		sprite 		= "data/ui_gfx/gun_actions/burst_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burst_2_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6", -- BURST_2
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8,0.8", -- BURST_2
		price = 140,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			draw_actions( 2, true )
		end,
	},
	{
		id          = "BURST_3",
		name 		= "$action_burst_3",
		description = "$actiondesc_burst_3",
		sprite 		= "data/ui_gfx/gun_actions/burst_3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burst_3_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- BURST_3
		spawn_probability                 = "0.7,0.7,0.7,0.7,0.7,0.7", -- BURST_3
		price = 160,
		mana = 2,
		--max_uses = 100,
		action 		= function()
			draw_actions( 3, true )
		end,
	},
	{
		id          = "BURST_4",
		name 		= "$action_burst_4",
		description = "$actiondesc_burst_4",
		sprite 		= "data/ui_gfx/gun_actions/burst_4.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "2,3,4,5,6", -- BURST_4
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- BURST_4
		price = 180,
		mana = 5,
		--max_uses = 100,
		action 		= function()
			draw_actions( 4, true )
		end,
	},
	{
		id          = "BURST_8",
		name 		= "$action_burst_8",
		description = "$actiondesc_burst_8",
		sprite 		= "data/ui_gfx/gun_actions/burst_8.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "5,6,10", -- BURST_4
		spawn_probability                 = "0.1,0.1,0.5", -- BURST_4
		price = 300,
		mana = 30,
		--max_uses = 100,
		action 		= function()
			draw_actions( 8, true )
		end,
	},
	{
		id          = "BURST_X",
		name 		= "$action_burst_x",
		description = "$actiondesc_burst_x",
		sprite 		= "data/ui_gfx/gun_actions/burst_x.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burst_4_unidentified.png",
		spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "5,6,10", -- BURST_4
		spawn_probability                 = "0.1,0.1,0.5", -- BURST_4
		price = 500,
		mana = 50,
		max_uses = 30,
		action 		= function()
			if ( #deck > 0 ) then
				draw_actions( #deck, true )
			end
		end,
	},
	{

		id          = "SCATTER_2",
		name 		= "$action_scatter_2",
		description = "$actiondesc_scatter_2",
		sprite 		= "data/ui_gfx/gun_actions/scatter_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/scatter_2_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2", -- SCATTER_2
		spawn_probability                 = "0.8,0.8,0.8", -- SCATTER_2
		price = 100,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			draw_actions( 2, true )
			c.spread_degrees = c.spread_degrees + 10.0
		end,
	},
	{
		id          = "SCATTER_3",
		name 		= "$action_scatter_3",
		description = "$actiondesc_scatter_3",
		sprite 		= "data/ui_gfx/gun_actions/scatter_3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/scatter_3_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                      = "0,1,2,3", -- SCATTER_3
		spawn_probability                = "0.7,0.7,0.7,0.8", -- SCATTER_3
		price = 120,
		mana = 1,
		--max_uses = 100,
		action 		= function()
			draw_actions( 3, true )
			c.spread_degrees = c.spread_degrees + 20.0
		end,
	},
	{
		id          = "SCATTER_4",
		name 		= "$action_scatter_4",
		description = "$actiondesc_scatter_4",
		sprite 		= "data/ui_gfx/gun_actions/scatter_4.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/scatter_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- SCATTER_4
		spawn_probability                 = "0.6,0.6,0.7,0.8,0.8,0.8", -- SCATTER_4
		price = 140,
		mana = 2,
		--max_uses = 100,
		action 		= function()
			draw_actions( 4, true )
			c.spread_degrees = c.spread_degrees + 40.0
		end,
	},
	{
		id          = "I_SHAPE",
		name 		= "$action_i_shape",
		description = "$actiondesc_i_shape",
		sprite 		= "data/ui_gfx/gun_actions/i_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4", -- I_SHAPE
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- I_SHAPE
		price = 80,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			draw_actions(2, true)
			c.pattern_degrees = 180
		end,
	},
	{
		id          = "Y_SHAPE",
		name 		= "$action_y_shape",
		description = "$actiondesc_y_shape",
		sprite 		= "data/ui_gfx/gun_actions/y_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/y_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4", -- Y_SHAPE
		spawn_probability                 = "0.8,0.4,0.4,0.4,0.4", -- Y_SHAPE
		price = 100,
		mana = 2,
		--max_uses = 100,
		action 		= function()
			draw_actions(2, true)
			c.pattern_degrees = 45
		end,
	},
	{
		id          = "T_SHAPE",
		name 		= "$action_t_shape",
		description = "$actiondesc_t_shape",
		sprite 		= "data/ui_gfx/gun_actions/t_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/t_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5", -- T_SHAPE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- T_SHAPE
		price = 120,
		mana = 3,
		--max_uses = 100,
		action 		= function()
			draw_actions(3, true)
			c.pattern_degrees = 90
		end,
	},
	{
		id          = "W_SHAPE",
		name 		= "$action_w_shape",
		description = "$actiondesc_w_shape",
		sprite 		= "data/ui_gfx/gun_actions/w_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "2,3,4,5,6", -- W_SHAPE
		spawn_probability                 = "0.4,0.3,0.3,0.3,0.3", -- W_SHAPE
		price = 160,
		mana = 3,
		--max_uses = 100,
		action 		= function()
			draw_actions(3, true)
			c.pattern_degrees = 20
		end,
	},
	{
		id          = "CIRCLE_SHAPE",
		name 		= "$action_circle_shape",
		description = "$actiondesc_circle_shape",
		sprite 		= "data/ui_gfx/gun_actions/circle_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/circle_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5,6", -- CIRCLE_SHAPE
		spawn_probability                 = "0.1,0.2,0.3,0.3,0.3,0.3", -- CIRCLE_SHAPE
		price = 150,
		mana = 6,
		--max_uses = 100,
		action 		= function()
			draw_actions(6, true)
			c.pattern_degrees = 180
		end,
	},
	{
		id          = "PENTAGRAM_SHAPE",
		name 		= "$action_pentagram_shape",
		description = "$actiondesc_pentagram_shape",
		sprite 		= "data/ui_gfx/gun_actions/pentagram_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/pentagram_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "1,2,3,4,5", -- PENTAGRAM_SHAPE
		spawn_probability                 = "0.4,0.4,0.3,0.2,0.1", -- PENTAGRAM_SHAPE
		price = 150,
		mana = 5,
		--max_uses = 100,
		action 		= function()
			draw_actions(5, true)
			c.pattern_degrees = 180
			--c.rad_pattern_degrees_offset = 150 // TODO: implement this
			--c.pattern_pos_offset = 30
		end,
	},
	{
		id          = "SPREAD_REDUCE",
		name 		= "$action_spread_reduce",
		description = "$actiondesc_spread_reduce",
		sprite 		= "data/ui_gfx/gun_actions/spread_reduce.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- SPREAD_REDUCE
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8", -- SPREAD_REDUCE
		price = 100,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.spread_degrees = c.spread_degrees - 60.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HEAVY_SPREAD",
		name 		= "$action_heavy_spread",
		description = "$actiondesc_heavy_spread",
		sprite 		= "data/ui_gfx/gun_actions/heavy_spread.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,4,5,6", -- HEAVY_SPREAD
		spawn_probability                 = "0.8,0.8,0.8,0.8,0.8,0.8", -- HEAVY_SPREAD
		price = 100,
		mana = 2,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait - 7
			current_reload_time = current_reload_time - 15
			c.spread_degrees = c.spread_degrees + 720
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECHARGE",
		name 		= "$action_recharge",
		description = "$actiondesc_recharge",
		sprite 		= "data/ui_gfx/gun_actions/recharge.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- RECHARGE
		spawn_probability                 = "1,1,1,1,1,1", -- RECHARGE
		price = 200,
		mana = 12,
		--max_uses = 150,
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait - 10
			current_reload_time = current_reload_time - 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIFETIME",
		name 		= "$action_lifetime",
		description = "$actiondesc_lifetime",
		sprite 		= "data/ui_gfx/gun_actions/lifetime.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.1", -- LIFETIME
		price = 250,
		mana = 40,
		--max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime.xml",
		action 		= function()
			c.lifetime_add 		= c.lifetime_add + 75
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIFETIME_DOWN",
		name 		= "$action_lifetime_down",
		description = "$actiondesc_lifetime_down",
		sprite 		= "data/ui_gfx/gun_actions/lifetime_down.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME_DOWN
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.1", -- LIFETIME_DOWN
		price = 90,
		mana = 10,
		--max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime_down.xml",
		action 		= function()
			c.lifetime_add 		= c.lifetime_add - 42
			c.fire_rate_wait = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "NOLLA",
		name 		= "$action_nolla",
		description = "$actiondesc_nolla",
		sprite 		= "data/ui_gfx/gun_actions/nolla.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		related_extra_entities = { "data/entities/misc/nolla.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6,10", -- LIFETIME_DOWN
		spawn_probability                 = "0.2,0.2,0.5,0.5,1", -- LIFETIME_DOWN
		price = 50,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/nolla.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SLOW_BUT_STEADY",
		name 		= "$action_slow_but_steady",
		description = "$actiondesc_slow_but_steady",
		sprite 		= "data/ui_gfx/gun_actions/slow_but_steady.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6,10", -- LIFETIME
		spawn_probability                 = "0.1,0.2,0.3,0.4,0.4", -- LIFETIME
		price = 50,
		mana = 0,
		action 		= function()
			current_reload_time = 90
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 80.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION_REMOVE",
		name 		= "$action_explosion_remove",
		description = "$actiondesc_explosion_remove",
		sprite 		= "data/ui_gfx/gun_actions/explosion_remove.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/explosion_remove.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6", -- LIFETIME_DOWN
		spawn_probability                 = "0.2,0.6,0.7,0.2", -- LIFETIME_DOWN
		price = 50,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/explosion_remove.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			c.explosion_radius = c.explosion_radius - 30.0
			c.damage_explosion_add = c.damage_explosion_add - 0.8
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION_TINY",
		name 		= "$action_explosion_tiny",
		description = "$actiondesc_explosion_tiny",
		sprite 		= "data/ui_gfx/gun_actions/explosion_tiny.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/explosion_tiny.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5,6", -- LIFETIME_DOWN
		spawn_probability                 = "0.2,0.6,0.7,0.2", -- LIFETIME_DOWN
		price = 160,
		mana = 40,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/explosion_tiny.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.explosion_radius = c.explosion_radius - 30.0
			c.damage_explosion_add = c.damage_explosion_add + 0.8
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LASER_EMITTER_WIDER",
		name 		= "$action_laser_emitter_wider",
		description = "$actiondesc_laser_emitter_wider",
		sprite 		= "data/ui_gfx/gun_actions/laser_emitter_wider.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burn_trail_unidentified.png",
		related_extra_entities = { "data/entities/misc/laser_emitter_wider.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BURN_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- BURN_TRAIL
		price = 40,
		mana = 10,
		--max_uses = 120,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/laser_emitter_wider.xml,"
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "LIFETIME_INFINITE",
		name 		= "$action_lifetime_infinite",
		description = "$actiondesc_lifetime_infinite",
		sprite 		= "data/ui_gfx/gun_actions/lifetime_infinite.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6", -- LIFETIME
		spawn_probability                 = "0.5,0.5,0.5,0.5", -- LIFETIME
		spawn_requires_flag	= "card_unlocked_infinite",
		price = 350,
		mana = 120,
		max_uses = 3,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime_infinite.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/lifetime_infinite.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "MANA_REDUCE",
		name 		= "$action_mana_reduce",
		description = "$actiondesc_mana_reduce",
		sprite 		= "data/ui_gfx/gun_actions/mana.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "1,1,1,1,1,1", -- MANA_REDUCE
		price = 250,
		mana = -30,
		--max_uses = 150,
		custom_xml_file = "data/entities/misc/custom_cards/mana_reduce.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_MAGIC",
		name 		= "$action_blood_magic",
		description = "$actiondesc_blood_magic",
		sprite 		= "data/ui_gfx/gun_actions/blood_magic.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/blood_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.7,0.5", -- MANA_REDUCE
		price = 150,
		mana = -100,
		custom_xml_file = "data/entities/misc/custom_cards/blood_magic.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/blood_sparks.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 20
			current_reload_time = current_reload_time - 20
			draw_actions( 1, true )
			
			local entity_id = GetUpdatedEntityID()
			
			local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
				for a,b in ipairs( dcomps ) do
					local hp = ComponentGetValue2( b, "hp" )
					hp = math.max( hp - 0.16, 0.04 )
					ComponentSetValue2( b, "hp", hp )
				end
			end
		end,
	},
	{
		id          = "MONEY_MAGIC",
		name 		= "$action_money_magic",
		description = "$actiondesc_money_magic",
		sprite 		= "data/ui_gfx/gun_actions/golden_punch.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/gold_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.8,0.1,0.5", -- MANA_REDUCE
		price = 200,
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/money_magic.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			
			local dcomp = EntityGetFirstComponent( entity_id, "WalletComponent" )
			
			if ( dcomp ~= nil ) then
				local money = ComponentGetValue2( dcomp, "money" )
				local moneyspent = ComponentGetValue2( dcomp, "money_spent" )
				local damage = math.min( math.floor( money * 0.05 ), 24000 )
				
				if ( damage > 1 ) and ( money >= 10 ) then
					damage = math.max( damage, 10 )
					
					c.extra_entities = c.extra_entities .. "data/entities/particles/gold_sparks.xml,"
					
					money = money - damage
					moneyspent = moneyspent + damage
					ComponentSetValue2( dcomp, "money", money )
					ComponentSetValue2( dcomp, "money_spent", moneyspent )
					
					-- print( "Spent " .. tostring( damage ) )
					
					if ( damage < 120 ) then
						c.damage_projectile_add = c.damage_projectile_add + ( damage / 25 )
					elseif ( damage < 300 ) then
						c.damage_projectile_add = c.damage_projectile_add + ( damage / 35 )
					elseif ( damage < 500 ) then
						c.damage_projectile_add = c.damage_projectile_add + ( damage / 45 )
					else
						c.damage_projectile_add = c.damage_projectile_add + ( damage / 55 )
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_TO_POWER",
		name 		= "$action_blood_to_power",
		description = "$actiondesc_blood_to_power",
		sprite 		= "data/ui_gfx/gun_actions/blood_punch.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/particles/blood_sparks.xml" },
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.8,0.1,0.5", -- MANA_REDUCE
		price = 150,
		mana = 20,
		custom_xml_file = "data/entities/misc/custom_cards/blood_to_power.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			
			local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomp ~= nil ) then
				local hp = ComponentGetValue2( dcomp, "hp" )
				local damage = math.min( hp * 0.44, 960 )
				local self_damage = hp * 0.2
				
				if ( hp >= 0.4 ) and ( self_damage > 0.2 ) then
					c.extra_entities = c.extra_entities .. "data/entities/particles/blood_sparks.xml,"
					
					EntityInflictDamage( entity_id, self_damage, "DAMAGE_CURSE", "$action_blood_to_power", "NONE", 0, 0, entity_id )
					
					-- print( "Spent " .. tostring( damage ) )
					
					c.damage_projectile_add = c.damage_projectile_add + damage
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DUPLICATE",
		name 		= "$action_duplicate",
		description = "$actiondesc_duplicate",
		sprite 		= "data/ui_gfx/gun_actions/duplicate.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 250,
		mana = 250,
		action 		= function( recursion_level, iteration )
			local hand_count = #hand
			
			for i,v in ipairs( hand ) do
				local rec = check_recursion( v, recursion_level )
				if ( v.id ~= "DUPLICATE" ) and ( i <= hand_count ) and ( rec > -1 ) then
					v.action( rec )
				end
			end
			
			c.fire_rate_wait = c.fire_rate_wait + 20
			current_reload_time = current_reload_time + 20
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "QUANTUM_SPLIT",
		name 		= "$action_quantum_split",
		description = "$actiondesc_quantum_split",
		sprite 		= "data/ui_gfx/gun_actions/quantum_split.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		related_extra_entities = { "data/entities/misc/quantum_split.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "0.5,0.5,0.5,0.5,1", -- MANA_REDUCE
		price = 200,
		mana = 10,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/quantum_split.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY",
		name 		= "$action_gravity",
		description = "$actiondesc_gravity",
		sprite 		= "data/ui_gfx/gun_actions/gravity.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- GRAVITY
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5", -- GRAVITY
		price = 50,
		mana = 1,
		--max_uses = 100,
		action 		= function()
			c.gravity = c.gravity + 600.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY_ANTI",
		name 		= "$action_gravity_anti",
		description = "$actiondesc_gravity_anti",
		sprite 		= "data/ui_gfx/gun_actions/gravity_anti.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/w_shape_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- GRAVITY_ANTI
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5", -- GRAVITY_ANTI
		price = 50,
		mana = 1,
		--max_uses = 100,
		action 		= function()
			c.gravity = c.gravity - 600.0
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "PENETRATE_WALLS",
		name 		= "$action_penetrate_walls",
		description = "$actiondesc_penetrate_walls",
		sprite 		= "data/ui_gfx/gun_actions/penetrate_walls.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- PENETRATE_WALLS
		spawn_probability                        = "", -- PENETRATE_WALLS
		price = 100,
		action 		= function()
			penetration_power = penetration_power + 1
		end,
	},]]--
	{
		id          = "SINEWAVE",
		name 		= "$action_sinewave",
		description = "$actiondesc_sinewave",
		sprite 		= "data/ui_gfx/gun_actions/sinewave.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/sinewave.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- SINEWAVE
		spawn_probability                 = "0.4,0.4,0.4", -- SINEWAVE
		price = 10,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/sinewave.xml,"
			c.speed_multiplier = c.speed_multiplier * 2
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CHAOTIC_ARC",
		name 		= "$action_chaotic_arc",
		description = "$actiondesc_chaotic_arc",
		sprite 		= "data/ui_gfx/gun_actions/chaotic_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/chaotic_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- CHAOTIC_ARC
		spawn_probability                 = "0.4,0.4,0.4", -- CHAOTIC_ARC
		price = 10,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/chaotic_arc.xml,"
			c.speed_multiplier = c.speed_multiplier * 2
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PINGPONG_PATH",
		name 		= "$action_pingpong_path",
		description = "$actiondesc_pingpong_path",
		sprite 		= "data/ui_gfx/gun_actions/pingpong_path.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/pingpong_path.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- PINGPONG_PATH
		spawn_probability                 = "0.4,0.4,0.4", -- PINGPONG_PATH
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/pingpong_path.xml,"
			c.lifetime_add = c.lifetime_add + 25
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AVOIDING_ARC",
		name 		= "$action_avoiding_arc",
		description = "$actiondesc_avoiding_arc",
		sprite 		= "data/ui_gfx/gun_actions/avoiding_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/avoiding_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- AVOIDING_ARC
		spawn_probability                 = "0.4,0.4,0.4", -- AVOIDING_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/avoiding_arc.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FLOATING_ARC",
		name 		= "$action_floating_arc",
		description = "$actiondesc_floating_arc",
		sprite 		= "data/ui_gfx/gun_actions/floating_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/floating_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- FLOATING_ARC
		spawn_probability                 = "0.4,0.4,0.4", -- FLOATING_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/floating_arc.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FLY_DOWNWARDS",
		name 		= "$action_fly_downwards",
		description = "$actiondesc_fly_downwards",
		sprite 		= "data/ui_gfx/gun_actions/fly_downwards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fly_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- FLY_DOWNWARDS
		spawn_probability                 = "0.4,0.4,0.4", -- FLY_DOWNWARDS
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fly_downwards.xml,"
			draw_actions( 1, true )
			c.fire_rate_wait    = c.fire_rate_wait - 3
		end,
	},
	{
		id          = "FLY_UPWARDS",
		name 		= "$action_fly_upwards",
		description = "$actiondesc_fly_upwards",
		sprite 		= "data/ui_gfx/gun_actions/fly_upwards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fly_upwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6", -- FLY_UPWARDS
		spawn_probability                 = "0.4,0.4,0.4", -- FLY_UPWARDS
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fly_upwards.xml,"
			draw_actions( 1, true )
			c.fire_rate_wait    = c.fire_rate_wait - 3
		end,
	},
	{
		id          = "HORIZONTAL_ARC",
		name 		= "$action_horizontal_arc",
		description = "$actiondesc_horizontal_arc",
		sprite 		= "data/ui_gfx/gun_actions/horizontal_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/horizontal_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.4,0.4,0.4", -- HORIZONTAL_ARC
		price = 20,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/horizontal_arc.xml,"
			draw_actions( 1, true )
			c.damage_projectile_add = c.damage_projectile_add + 0.3
			c.fire_rate_wait    = c.fire_rate_wait - 6
		end,
	},
	{
		id          = "LINE_ARC",
		name 		= "$action_line_arc",
		description = "$actiondesc_line_arc",
		sprite 		= "data/ui_gfx/gun_actions/line_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/line_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.4,0.4,0.4", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/line_arc.xml,"
			draw_actions( 1, true )
			c.damage_projectile_add = c.damage_projectile_add + 0.2
			c.fire_rate_wait    = c.fire_rate_wait - 4
		end,
	},
	{
		id          = "ORBIT_SHOT",
		name 		= "$action_orbit_shot",
		description = "$actiondesc_orbit_shot",
		sprite 		= "data/ui_gfx/gun_actions/orbit_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/spiraling_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- HORIZONTAL_ARC
		spawn_probability                 = "0.2,0.3,0.4,0.1", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/spiraling_shot.xml,"
			draw_actions( 1, true )
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.fire_rate_wait    = c.fire_rate_wait - 6
			c.lifetime_add 		= c.lifetime_add + 25
		end,
	},
	{
		id          = "SPIRALING_SHOT",
		name 		= "$action_spiraling_shot",
		description = "$actiondesc_spiraling_shot",
		sprite 		= "data/ui_gfx/gun_actions/spiraling_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- HORIZONTAL_ARC
		spawn_probability                 = "0.2,0.3,0.4,0.1", -- HORIZONTAL_ARC
		price = 30,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_shot.xml,"
			draw_actions( 1, true )
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.fire_rate_wait    = c.fire_rate_wait - 6
			c.lifetime_add 		= c.lifetime_add + 50
		end,
	},
	{
		id          = "PHASING_ARC",
		name 		= "$action_phasing_arc",
		description = "$actiondesc_phasing_arc",
		sprite 		= "data/ui_gfx/gun_actions/phasing_arc.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/phasing_arc.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- HORIZONTAL_ARC
		spawn_probability                 = "0.2,0.3,0.6,0.1", -- HORIZONTAL_ARC
		price = 170,
		mana = 2,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/phasing_arc.xml,"
			draw_actions( 1, true )
			c.fire_rate_wait    = c.fire_rate_wait - 12
			c.lifetime_add 		= c.lifetime_add + 80
			c.speed_multiplier	= c.speed_multiplier * 0.33
			c.child_speed_multiplier	= c.child_speed_multiplier * 0.33
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
		end,
	},
	{
		id          = "BOUNCE",
		name 		= "$action_bounce",
		description = "$actiondesc_bounce",
		sprite 		= "data/ui_gfx/gun_actions/bounce.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bounce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- BOUNCE
		spawn_probability                 = "1,1,0.4,0.2,0.2", -- BOUNCE
		price = 50,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.bounces = c.bounces + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "REMOVE_BOUNCE",
		name 		= "$action_remove_bounce",
		description = "$actiondesc_remove_bounce",
		sprite 		= "data/ui_gfx/gun_actions/remove_bounce.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bounce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- BOUNCE
		spawn_probability                 = "0.2,0.2,1,1,1", -- BOUNCE
		price = 50,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/remove_bounce.xml,"
			c.bounces = 0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING",
		name 		= "$action_homing",
		description = "$actiondesc_homing",
		sprite 		= "data/ui_gfx/gun_actions/homing.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing.xml", "data/entities/particles/tinyspark_white.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- HOMING
		spawn_probability                 = "0.1,0.4,0.4,0.4,0.4,0.4", -- HOMING
		price = 220,
		mana = 70,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing.xml,data/entities/particles/tinyspark_white.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_SHORT",
		name 		= "$action_homing_short",
		description = "$actiondesc_homing_short",
		sprite 		= "data/ui_gfx/gun_actions/homing_short.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_short.xml", "data/entities/particles/tinyspark_white_weak.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- HOMING
		spawn_probability                 = "0.4,0.8,1,0.4,0.1,0.1", -- HOMING
		price = 160,
		mana = 40,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_short.xml,data/entities/particles/tinyspark_white_weak.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_ROTATE",
		name 		= "$action_homing_rotate",
		description = "$actiondesc_homing_rotate",
		sprite 		= "data/ui_gfx/gun_actions/homing_rotate.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_rotate.xml", "data/entities/particles/tinyspark_white.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_ROTATE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- HOMING_ROTATE
		price = 175,
		mana = 40,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_rotate.xml,data/entities/particles/tinyspark_white.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_SHOOTER",
		name 		= "$action_homing_shooter",
		description = "$actiondesc_homing_shooter",
		sprite 		= "data/ui_gfx/gun_actions/homing_shooter.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_shooter.xml", "data/entities/particles/tinyspark_white.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_SHOOTER
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2", -- HOMING_SHOOTER
		price = 100,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_shooter.xml,data/entities/particles/tinyspark_white.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AUTOAIM",
		name 		= "$action_autoaim",
		description = "$actiondesc_autoaim",
		sprite 		= "data/ui_gfx/gun_actions/autoaim.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/autoaim_unidentified.png",
		related_extra_entities = { "data/entities/misc/autoaim.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- AUTOAIM
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- AUTOAIM
		price = 150,
		mana = 25,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/autoaim.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_ACCELERATING",
		name 		= "$action_homing_accelerating",
		description = "$actiondesc_homing_accelerating",
		sprite 		= "data/ui_gfx/gun_actions/homing_accelerating.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_accelerating.xml", "data/entities/particles/tinyspark_white_small.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.3,0.3,0.5", -- HOMING
		price = 180,
		mana = 60,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_accelerating.xml,data/entities/particles/tinyspark_white_small.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_CURSOR",
		name 		= "$action_homing_cursor",
		description = "$actiondesc_homing_cursor",
		sprite 		= "data/ui_gfx/gun_actions/homing_cursor.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_cursor.xml", "data/entities/particles/tinyspark_white.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_ROTATE
		spawn_probability                 = "0.7,0.7,0.4,0.4,1.0", -- HOMING_ROTATE
		price = 175,
		mana = 30,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_cursor.xml,data/entities/particles/tinyspark_white.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_AREA",
		name 		= "$action_homing_area",
		description = "$actiondesc_homing_area",
		sprite 		= "data/ui_gfx/gun_actions/homing_area.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/homing_area.xml", "data/entities/particles/tinyspark_white.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_ROTATE
		spawn_probability                 = "0.2,0.4,0.6,0.7,0.4", -- HOMING_ROTATE
		price = 175,
		mana = 60,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_area.xml,data/entities/particles/tinyspark_white.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.spread_degrees = c.spread_degrees + 6
			c.speed_multiplier	= c.speed_multiplier * 0.75
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "HOMING_PROJECTILE",
		name 		= "$action_homing_projectile",
		description = "$actiondesc_homing_projectile",
		sprite 		= "data/ui_gfx/gun_actions/homing_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- HOMING_SHOOTER
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2", -- HOMING_SHOOTER
		price = 100,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing_projectile.xml,data/entities/particles/tinyspark_white.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "PIERCING_SHOT",
		name 		= "$action_piercing_shot",
		description = "$actiondesc_piercing_shot",
		sprite 		= "data/ui_gfx/gun_actions/piercing_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/piercing_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- PIERCING_SHOT
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- PIERCING_SHOT
		price = 190,
		mana = 140,
		--max_uses = 100,
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add - 0.6
			c.extra_entities = c.extra_entities .. "data/entities/misc/piercing_shot.xml,"
			c.friendly_fire		= true
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CLIPPING_SHOT",
		name 		= "$action_clipping_shot",
		description = "$actiondesc_clipping_shot",
		sprite 		= "data/ui_gfx/gun_actions/clipping_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/clipping_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- CLIPPING_SHOT
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- CLIPPING_SHOT
		price = 200,
		mana = 160,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/clipping_shot.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 50
			current_reload_time = current_reload_time + 40
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE",
		name 		= "$action_damage",
		description = "$actiondesc_damage",
		sprite 		= "data/ui_gfx/gun_actions/damage.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- DAMAGE
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- DAMAGE
		price = 140,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 0.4
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE_RANDOM",
		name 		= "$action_damage_random",
		description = "$actiondesc_damage_random",
		sprite 		= "data/ui_gfx/gun_actions/damage_random.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- DAMAGE
		spawn_probability                 = "0.6,0.6,0.6", -- DAMAGE
		price = 200,
		mana = 15,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_random.xml",
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 253 )
			local multiplier = 0
			multiplier = Random( -3, 4 ) * Random( 0, 2 )
			local result = 0
			result = c.damage_projectile_add + 0.4 * multiplier
			c.damage_projectile_add = result
			c.gore_particles    = c.gore_particles + 5 * multiplier
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0 * multiplier
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOODLUST",
		name 		= "$action_bloodlust",
		description = "$actiondesc_bloodlust",
		sprite 		= "data/ui_gfx/gun_actions/bloodlust.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5,6", -- PIERCING_SHOT
		spawn_probability                 = "0.2,0.3,0.6,0.6,0.3", -- PIERCING_SHOT
		price = 160,
		mana = 2,
		--max_uses = 100,
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 1.3
			c.gore_particles    = c.gore_particles + 15
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.friendly_fire		= true
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			c.spread_degrees = c.spread_degrees + 6
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE_FOREVER",
		name 		= "$action_damage_forever",
		description = "$actiondesc_damage_forever",
		sprite 		= "data/ui_gfx/gun_actions/damage_forever.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- DAMAGE
		spawn_probability                 = "0.2,0.4,0.6,0.4,0.2", -- DAMAGE
		price = 240,
		mana = 0,
		max_uses = 20,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/damage_forever.xml",
		action 		= function()
			if ( mana > 50 ) then
				local manaforspell = mana - 50
				c.damage_projectile_add = c.damage_projectile_add + 0.025 * manaforspell
				mana = 50
			end
			
			c.gore_particles    = c.gore_particles + 15
			c.fire_rate_wait    = c.fire_rate_wait + 15
			current_reload_time = current_reload_time + 10
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CRITICAL_HIT",
		name 		= "$action_critical_hit",
		description = "$actiondesc_critical_hit",
		sprite 		= "data/ui_gfx/gun_actions/critical_hit.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- CRITICAL_HIT
		spawn_probability                 = "0.6,0.6,0.6,0.6,0.6", -- CRITICAL_HIT
		price = 140,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/critical_hit.xml",
		action 		= function()
			c.damage_critical_chance = c.damage_critical_chance + 15
			draw_actions( 1, true )
		end,
	},
	{
		id          = "AREA_DAMAGE",
		name 		= "$action_area_damage",
		description = "$actiondesc_area_damage",
		sprite 		= "data/ui_gfx/gun_actions/area_damage.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/area_damage.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- AREA_DAMAGE
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5", -- AREA_DAMAGE
		price = 140,
		mana = 30,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/area_damage.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPELLS_TO_POWER",
		name 		= "$action_spells_to_power",
		description = "$actiondesc_spells_to_power",
		sprite 		= "data/ui_gfx/gun_actions/spells_to_power.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/spells_to_power.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,10", -- AREA_DAMAGE
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.1", -- AREA_DAMAGE
		price = 140,
		mana = 110,
		-- max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/spells_to_power.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 40
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ESSENCE_TO_POWER",
		name 		= "$action_enemies_to_power",
		description = "$actiondesc_enemies_to_power",
		sprite 		= "data/ui_gfx/gun_actions/essence_to_power.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/essence_to_power.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,10", -- AREA_DAMAGE
		spawn_probability                 = "0.2,0.5,0.5,0.1", -- AREA_DAMAGE
		price = 120,
		mana = 110,
		-- max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/essence_to_power.xml,"
			c.fire_rate_wait    = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		-- NOTE( Petri ): Why doesn't this work?
		id          = "DAMAGE_FRIENDLY",
		name 		= "$action_damage_friendly",
		description = "$actiondesc_damage_friendly",
		sprite 		= "data/ui_gfx/gun_actions/damage_friendly.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_friendly_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_FRIENDLY
		spawn_probability                 = "", -- DAMAGE_FRIENDLY
		price = 140,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_friendly.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.8
			c.friendly_fire		= true
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
		end,
	},
	{
		-- NOTE( Petri ): This doesn't work now!
		id          = "DAMAGE_X2",
		name 		= "$action_damage_x2",
		description = "$actiondesc_damage_x2",
		sprite 		= "data/ui_gfx/gun_actions/damage_x2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_x2_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_X2
		spawn_probability                 = "", -- DAMAGE_X2
		price = 200,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage_x2.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 2
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.gore_particles    = c.gore_particles + 10
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			draw_actions( 1, true )
		end,
	},
	{
		-- NOTE( Petri ): This doesn't work now!
		id          = "DAMAGE_X5",
		name 		= "$action_damage_x5",
		description = "$actiondesc_damage_x5",
		sprite 		= "data/ui_gfx/gun_actions/damage_x5.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_x2_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DAMAGE_X5
		spawn_probability                 = "", -- DAMAGE_X5
		price = 220,
		mana = 50,
		max_uses = 5,
		custom_xml_file = "data/entities/misc/custom_cards/damage_x2.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 5
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 30
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "HEAVY_SHOT",
		name 		= "$action_heavy_shot",
		description = "$actiondesc_heavy_shot",
		sprite 		= "data/ui_gfx/gun_actions/heavy_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/particles/heavy_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HEAVY_SHOT
		spawn_probability                 = "0.4,0.4,0.4", -- HEAVY_SHOT
		price = 150,
		mana = 7,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/heavy_shot.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 1.75
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 10
			c.speed_multiplier = c.speed_multiplier * 0.3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
			c.extra_entities = c.extra_entities .. "data/entities/particles/heavy_shot.xml,"
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHT_SHOT",
		name 		= "$action_light_shot",
		description = "$actiondesc_light_shot",
		sprite 		= "data/ui_gfx/gun_actions/light_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- LIGHT_SHOT
		spawn_probability                 = "0.4,0.4,0.4", -- LIGHT_SHOT
		price = 60,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/light_shot.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add - 1.0
			c.explosion_radius = c.explosion_radius - 10.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			c.fire_rate_wait    = c.fire_rate_wait - 3
			c.speed_multiplier = c.speed_multiplier * 7.5
			c.spread_degrees = c.spread_degrees - 6
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			c.extra_entities = c.extra_entities .. "data/entities/particles/light_shot.xml,"
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "SHORTLIVED_SHOT",
		name 		= "$action_shortlived_shot",
		description = "$actiondesc_shortlived_shot",
		sprite 		= "data/ui_gfx/gun_actions/shortlived_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- SHORTLIVED_SHOT
		spawn_probability                 = "", -- SHORTLIVED_SHOT
		price = 120,
		mana = 7,
		--max_uses = 50,
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 2.4
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.gore_particles    = c.gore_particles + 15
			c.lifetime_add 		= c.lifetime_add - 200
			draw_actions( 1, true )
		end,
	},
	]]--
	{
		id          = "KNOCKBACK",
		name 		= "$action_knockback",
		description = "$actiondesc_knockback",
		sprite 		= "data/ui_gfx/gun_actions/knockback.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/knockback_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,5", -- KNOCKBACK
		spawn_probability                 = "0.6,0.6", -- KNOCKBACK
		price = 100,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			c.knockback_force = c.knockback_force + 5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECOIL",
		name 		= "$action_recoil",
		description = "$actiondesc_recoil",
		sprite 		= "data/ui_gfx/gun_actions/recoil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/recoil_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4", -- RECOIL
		spawn_probability                 = "0.6,0.6", -- RECOIL
		price = 100,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RECOIL_DAMPER",
		name 		= "$action_recoil_damper",
		description = "$actiondesc_recoil_damper",
		sprite 		= "data/ui_gfx/gun_actions/recoil_damper.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/recoil_damper_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,6", -- RECOIL_DAMPER
		spawn_probability                 = "0.6,0.6", -- RECOIL_DAMPER
		price = 100,
		mana = 5,
		--max_uses = 150,
		action 		= function()
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 200
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPEED",
		name 		= "$action_speed",
		description = "$actiondesc_speed",
		sprite 		= "data/ui_gfx/gun_actions/speed.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/speed_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3", -- SPEED
		spawn_probability                 = "1,0.5,0.5", -- SPEED
		price = 100,
		mana = 3,
		--max_uses = 100,
		custom_xml_file = "data/entities/misc/custom_cards/speed.xml",
		action 		= function()
			c.speed_multiplier = c.speed_multiplier * 2.5
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACCELERATING_SHOT",
		name 		= "$action_accelerating_shot",
		description = "$actiondesc_accelerating_shot",
		sprite 		= "data/ui_gfx/gun_actions/accelerating_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/accelerating_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- ACCELERATING_SHOT
		spawn_probability                 = "0.5,0.5,1", -- ACCELERATING_SHOT
		price = 190,
		mana = 20,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/accelerating_shot.xml",
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait + 8
			c.speed_multiplier = c.speed_multiplier * 0.32
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			c.extra_entities = c.extra_entities .. "data/entities/misc/accelerating_shot.xml,"
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DECELERATING_SHOT",
		name 		= "$action_decelerating_shot",
		description = "$actiondesc_decelerating_shot",
		sprite 		= "data/ui_gfx/gun_actions/decelerating_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/heavy_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/decelerating_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- ACCELERATING_SHOT
		spawn_probability                 = "0.3,0.3,0.5", -- ACCELERATING_SHOT
		price = 80,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/decelerating_shot.xml",
		action 		= function()
			c.fire_rate_wait    = c.fire_rate_wait - 8
			c.speed_multiplier = c.speed_multiplier * 1.68
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			c.extra_entities = c.extra_entities .. "data/entities/misc/decelerating_shot.xml,"
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "GORE",
		name 		= "$action_gore",
		description = "$actiondesc_gore",
		sprite 		= "data/ui_gfx/gun_actions/gore.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GORE
		spawn_probability                        = "", -- GORE
		price = 100,
		mana = 0,
		action 		= function()
			c.ragdoll_fx = 3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 90.0
		end,
	},
	]]--
	{
		id          = "EXPLOSIVE_PROJECTILE",
		name 		= "$action_explosive_projectile",
		description = "$actiondesc_explosive_projectile",
		sprite 		= "data/ui_gfx/gun_actions/explosive_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- EXPLOSIVE_PROJECTILE
		spawn_probability                 = "1,1,1", -- EXPLOSIVE_PROJECTILE
		price = 120,
		mana = 30,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/explosive_projectile.xml",
		action 		= function()
			c.explosion_radius = c.explosion_radius + 15.0
			c.damage_explosion_add = c.damage_explosion_add + 0.2
			c.fire_rate_wait   = c.fire_rate_wait + 40
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "WATER_TO_POISON",
		name 		= "$action_water_to_poison",
		description = "$actiondesc_water_to_poison",
		sprite 		= "data/ui_gfx/gun_actions/water_to_poison.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/water_to_poison.xml", "data/entities/particles/tinyspark_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- WATER_TO_POISON
		spawn_probability                 = "0.3,0.3,0.3", -- WATER_TO_POISON
		price = 80,
		mana = 30,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/water_to_poison.xml,data/entities/particles/tinyspark_purple.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BLOOD_TO_ACID",
		name 		= "$action_blood_to_acid",
		description = "$actiondesc_blood_to_acid",
		sprite 		= "data/ui_gfx/gun_actions/blood_to_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/blood_to_acid.xml", "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BLOOD_TO_ACID
		spawn_probability                 = "0.3,0.3,0.3", -- BLOOD_TO_ACID
		price = 80,
		mana = 30,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/blood_to_acid.xml,data/entities/particles/tinyspark_red.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LAVA_TO_BLOOD",
		name 		= "$action_lava_to_blood",
		description = "$actiondesc_lava_to_blood",
		sprite 		= "data/ui_gfx/gun_actions/lava_to_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/lava_to_blood.xml", "data/entities/particles/tinyspark_orange.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- LAVA_TO_BLOOD
		spawn_probability                 = "0.3,0.3,0.3", -- LAVA_TO_BLOOD
		price = 80,
		mana = 30,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/lava_to_blood.xml,data/entities/particles/tinyspark_orange.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIQUID_TO_EXPLOSION",
		name 		= "$action_liquid_to_explosion",
		description = "$actiondesc_liquid_to_explosion",
		sprite 		= "data/ui_gfx/gun_actions/liquid_to_explosion.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/liquid_to_explosion.xml", "data/entities/particles/tinyspark_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- BLOOD_TO_ACID
		spawn_probability                 = "0.3,0.3,0.3", -- BLOOD_TO_ACID
		price = 120,
		mana = 40,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/liquid_to_explosion.xml,data/entities/particles/tinyspark_red.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TOXIC_TO_ACID",
		name 		= "$action_toxic_to_acid",
		description = "$actiondesc_toxic_to_acid",
		sprite 		= "data/ui_gfx/gun_actions/toxic_to_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/toxic_to_acid.xml", "data/entities/particles/tinyspark_green.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- TOXIC_TO_ACID
		spawn_probability                 = "0.3,0.3,0.3", -- TOXIC_TO_ACID
		price = 120,
		mana = 50,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/toxic_to_acid.xml,data/entities/particles/tinyspark_green.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "STATIC_TO_SAND",
		name 		= "$action_static_to_sand",
		description = "$actiondesc_static_to_sand",
		sprite 		= "data/ui_gfx/gun_actions/static_to_sand.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/static_to_sand.xml", "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- STATIC_TO_SAND
		spawn_probability                 = "0.3,0.3,0.3", -- STATIC_TO_SAND
		price = 140,
		mana = 70,
		max_uses = 8,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/static_to_sand.xml,data/entities/particles/tinyspark_yellow.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 60
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TRANSMUTATION",
		name 		= "$action_transmutation",
		description = "$actiondesc_transmutation",
		sprite 		= "data/ui_gfx/gun_actions/transmutation.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/transmutation.xml", "data/entities/particles/tinyspark_purple_bright.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,10", -- TRANSMUTATION
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3,0.2", -- TRANSMUTATION
		price = 180,
		mana = 80,
		max_uses = 8,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/transmutation.xml,data/entities/particles/tinyspark_purple_bright.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RANDOM_EXPLOSION",
		name 		= "$action_random_explosion",
		description = "$actiondesc_random_explosion",
		sprite 		= "data/ui_gfx/gun_actions/random_explosion.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/random_explosion.xml", "data/entities/particles/tinyspark_purple_bright.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,5,6", -- TRANSMUTATION
		spawn_probability                 = "0.3,0.6,1", -- TRANSMUTATION
		price = 240,
		mana = 120,
		max_uses = 30,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/random_explosion.xml,data/entities/particles/tinyspark_purple_bright.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 40
			draw_actions( 1, true )
		end,
	},
	{
		id          = "NECROMANCY",
		name 		= "$action_necromancy",
		description = "$actiondesc_necromancy",
		spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/necromancy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- NECROMANCY
		spawn_probability                 = "0.6,0.6,0.6,0.6", -- NECROMANCY
		price = 80,
		mana = 20,
		--max_uses = 50,
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_necromancy.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHT",
		name 		= "$action_light",
		description = "$actiondesc_light",
		sprite 		= "data/ui_gfx/gun_actions/light.png",
		related_extra_entities = { "data/entities/misc/light.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- LIGHT
		spawn_probability                 = "1,0.8,0.6,0.4,0.2", -- LIGHT
		price = 20,
		mana = 1,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/light.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "EXPLOSION",
		name 		= "$action_explosion",
		description = "$actiondesc_explosion",
		sprite 		= "data/ui_gfx/gun_actions/explosion.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosion_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/explosion.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,4,5", -- EXPLOSION
		spawn_probability                 = "0.5,1,1,1", -- EXPLOSION
		price = 160,
		mana = 80,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/explosion.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/explosion.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 2.5
		end,
	},
	{
		id          = "EXPLOSION_LIGHT",
		name 		= "$action_explosion_light",
		description = "$actiondesc_explosion_light",
		sprite 		= "data/ui_gfx/gun_actions/explosion_light.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosion_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/explosion_light.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- EXPLOSION
		spawn_probability                 = "0.5,1,1,1", -- EXPLOSION
		price = 160,
		mana = 80,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/explosion_light.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/explosion_light.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 2.5
		end,
	},
	{
		id          = "FIRE_BLAST",
		name 		= "$action_fire_blast",
		description = "$actiondesc_fire_blast",
		sprite 		= "data/ui_gfx/gun_actions/fire_blast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fire_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/fireblast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,3,5", -- FIRE_BLAST
		spawn_probability                 = "0.5,0.5,0.6,0.6", -- FIRE_BLAST
		price = 120,
		mana = 10,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/fire_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fireblast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "POISON_BLAST",
		name 		= "$action_poison_blast",
		description = "$actiondesc_poison_blast",
		sprite 		= "data/ui_gfx/gun_actions/poison_blast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/poison_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/poison_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- POISON_BLAST
		spawn_probability                 = "0.5,0.6,0.6,0.5", -- POISON_BLAST
		price = 140,
		mana = 30,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/poison_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/poison_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "ALCOHOL_BLAST",
		name 		= "$action_alcohol_blast",
		description = "$actiondesc_alcohol_blast",
		sprite 		= "data/ui_gfx/gun_actions/alcohol_blast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/poison_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/alcohol_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,4,6", -- ALCOHOL_BLAST
		spawn_probability                 = "0.5,0.6,0.6,0.5", -- ALCOHOL_BLAST
		price = 140,
		mana = 30,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/alcohol_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/alcohol_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "THUNDER_BLAST",
		name 		= "$action_thunder_blast",
		description = "$actiondesc_thunder_blast",
		sprite 		= "data/ui_gfx/gun_actions/thunder_blast.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/thunder_blast_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/thunder_blast.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6,10", -- THUNDER_BLAST
		spawn_probability                 = "0.5,0.6,0.6,0.5,0.1", -- THUNDER_BLAST
		price = 180,
		mana = 110,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/thunder_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thunder_blast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.screenshake = c.screenshake + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	--[[
	{
		id          = "CHARM_FIELD",
		name 		= "$action_charm_field",
		description = "$actiondesc_charm_field",
		sprite 		= "data/ui_gfx/gun_actions/charm_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- CHARM_FIELD
		spawn_probability                        = "", -- CHARM_FIELD
		price = 100,
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/charm_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	]]--
	{
		id          = "BERSERK_FIELD",
		name 		= "$action_berserk_field",
		description = "$actiondesc_berserk_field",
		sprite 		= "data/ui_gfx/gun_actions/berserk_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/berserk_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/berserk_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4", -- BERSERK_FIELD
		spawn_probability                 = "0.3,0.6,0.3", -- BERSERK_FIELD
		price = 200,
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/berserk_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "POLYMORPH_FIELD",
		name 		= "$action_polymorph_field",
		description = "$actiondesc_polymorph_field",
		sprite 		= "data/ui_gfx/gun_actions/polymorph_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/polymorph_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6", -- POLYMORPH_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.8,0.8,0.3,0.3", -- POLYMORPH_FIELD
		price = 200,
		mana = 50,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CHAOS_POLYMORPH_FIELD",
		name 		= "$action_chaos_polymorph_field",
		description = "$actiondesc_chaos_polymorph_field",
		sprite 		= "data/ui_gfx/gun_actions/chaos_polymorph_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/chaos_polymorph_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,6", -- CHAOS_POLYMORPH_FIELD
		spawn_probability                 = "0.3,0.3,0.5,0.6,0.3,0.3", -- CHAOS_POLYMORPH_FIELD
		price = 200,
		mana = 20,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chaos_polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "ELECTROCUTION_FIELD",
		name 		= "$action_electrocution_field",
		description = "$actiondesc_electrocution_field",
		sprite 		= "data/ui_gfx/gun_actions/electrocution_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electrocution_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/electrocution_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,3,5,6", -- ELECTROCUTION_FIELD
		spawn_probability                 = "0.3,0.6,0.8,0.3", -- ELECTROCUTION_FIELD
		price = 200,
		mana = 60,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/electrocution_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "FREEZE_FIELD",
		name 		= "$action_freeze_field",
		description = "$actiondesc_freeze_field",
		sprite 		= "data/ui_gfx/gun_actions/freeze_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/freeze_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,4,5", -- FREEZE_FIELD
		spawn_probability                 = "0.3,0.6,0.7,0.3", -- FREEZE_FIELD
		price = 200,
		mana = 50,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/freeze_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "REGENERATION_FIELD",
		name 		= "$action_regeneration_field",
		description = "$actiondesc_regeneration_field",
		sprite 		= "data/ui_gfx/gun_actions/regeneration_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/regeneration_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/regeneration_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- REGENERATION_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- REGENERATION_FIELD
		price = 250,
		mana = 80,
		max_uses = 2,
		never_unlimited = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/regeneration_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "TELEPORTATION_FIELD",
		name 		= "$action_teleportation_field",
		description = "$actiondesc_teleportation_field",
		sprite 		= "data/ui_gfx/gun_actions/teleportation_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleportation_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleportation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- TELEPORTATION_FIELD
		spawn_probability                 = "0.3,0.6,0.3,0.3,0.6,0.3", -- TELEPORTATION_FIELD
		price = 150,
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleportation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "LEVITATION_FIELD",
		name 		= "$action_levitation_field",
		description = "$actiondesc_levitation_field",
		sprite 		= "data/ui_gfx/gun_actions/levitation_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/levitation_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/levitation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- LEVITATION_FIELD
		spawn_probability                 = "0.3,0.6,0.6,0.3", -- LEVITATION_FIELD
		price = 120,
		mana = 10,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	--[[{
		id          = "TELEPATHY_FIELD",
		name 		= "$action_telepathy_field",
		description = "$actiondesc_telepathy_field",
		sprite 		= "data/ui_gfx/gun_actions/telepathy_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/telepathy_field_unidentified.png",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "", -- TELEPATHY_FIELD
		spawn_probability                 = "", -- TELEPATHY_FIELD
		price = 150,
		mana = 60,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/telepathy_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},]]--
	{
		id          = "SHIELD_FIELD",
		name 		= "$action_shield_field",
		description = "$actiondesc_shield_field",
		sprite 		= "data/ui_gfx/gun_actions/shield_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/shield_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/shield_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3", -- SHIELD_FIELD
		price = 160,
		mana = 20,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/shield_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_TRANSMUTATION_FIELD",
		name 		= "$action_projectile_transmutation_field",
		description = "$actiondesc_projectile_transmutation_field",
		sprite 		= "data/ui_gfx/gun_actions/projectile_transmutation_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_transmutation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- PROJECTILE_TRANSMUTATION_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3", -- PROJECTILE_TRANSMUTATION_FIELD
		price = 250,
		mana = 120,
		max_uses = 6,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_transmutation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_THUNDER_FIELD",
		name 		= "$action_projectile_thunder_field",
		description = "$actiondesc_projectile_thunder_field",
		sprite 		= "data/ui_gfx/gun_actions/projectile_thunder_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_thunder_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "3,4,5,6", -- PROJECTILE_THUNDER_FIELD
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- PROJECTILE_THUNDER_FIELD
		price = 300,
		mana = 140,
		max_uses = 6,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_thunder_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "PROJECTILE_GRAVITY_FIELD",
		name 		= "$action_projectile_gravity_field",
		description = "$actiondesc_projectile_gravity_field",
		sprite 		= "data/ui_gfx/gun_actions/projectile_gravity_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_gravity_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,0.3,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 250,
		mana = 120,
		max_uses = 6,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_gravity_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "VACUUM_POWDER",
		name 		= "$action_vacuum_powder",
		description = "$actiondesc_vacuum_powder",
		sprite 		= "data/ui_gfx/gun_actions/vacuum_powder.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_powder.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,1,0.3,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 150,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_powder.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "VACUUM_LIQUID",
		name 		= "$action_vacuum_liquid",
		description = "$actiondesc_vacuum_liquid",
		sprite 		= "data/ui_gfx/gun_actions/vacuum_liquid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_liquid.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,1,0.3,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 150,
		mana = 40,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_liquid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "VACUUM_ENTITIES",
		name 		= "$action_vacuum_entities",
		description = "$actiondesc_vacuum_entities",
		sprite 		= "data/ui_gfx/gun_actions/vacuum_entities.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chaos_polymorph_field_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/vacuum_liquid.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,3,5,6", -- PROJECTILE_GRAVITY_FIELD
		spawn_probability                 = "0.3,1,0.3,0.3", -- PROJECTILE_GRAVITY_FIELD
		price = 200,
		mana = 50,
		max_uses = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/vacuum_entities.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "SEA_LAVA",
		name 		= "$action_sea_lava",
		description = "$actiondesc_sea_lava",
		spawn_requires_flag = "card_unlocked_sea_lava",
		sprite 		= "data/ui_gfx/gun_actions/sea_lava.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_lava_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_lava.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_LAVA
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- SEA_LAVA
		price = 350,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_lava.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ALCOHOL",
		name 		= "$action_sea_alcohol",
		description = "$actiondesc_sea_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/sea_alcohol.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_lava_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_alcohol.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ALCOHOL
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- SEA_ALCOHOL
		price = 350,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_alcohol.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_OIL",
		name 		= "$action_sea_oil",
		description = "$actiondesc_sea_oil",
		sprite 		= "data/ui_gfx/gun_actions/sea_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_oil_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_oil.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_OIL
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- SEA_OIL
		price = 350,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_WATER",
		name 		= "$action_sea_water",
		description = "$actiondesc_sea_water",
		sprite 		= "data/ui_gfx/gun_actions/sea_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_water.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4", -- SEA_WATER
		price = 350,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ACID",
		name 		= "$action_sea_acid",
		description = "$actiondesc_sea_acid",
		sprite 		= "data/ui_gfx/gun_actions/sea_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_acid.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ACID
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- SEA_ACID
		price = 350,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "SEA_ACID_GAS",
		name 		= "$action_sea_acid_gas",
		description = "$actiondesc_sea_acid_gas",
		sprite 		= "data/ui_gfx/gun_actions/sea_acid_gas.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sea_acid_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/sea_acid_gas.xml"},
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,4,5,6", -- SEA_ACID_GAS
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- SEA_ACID_GAS
		price = 200,
		mana = 140,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sea_acid_gas.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CLOUD_WATER",
		name 		= "$action_cloud_water",
		description = "$actiondesc_cloud_water",
		sprite 		= "data/ui_gfx/gun_actions/cloud_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/cloud_water.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- CLOUD_WATER
		price = 140,
		mana = 30,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/cloud_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CLOUD_OIL",
		name 		= "$action_cloud_oil",
		description = "$actiondesc_cloud_oil",
		sprite 		= "data/ui_gfx/gun_actions/cloud_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/cloud_oil.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_WATER
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4", -- CLOUD_WATER
		price = 100,
		mana = 20,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/cloud_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CLOUD_BLOOD",
		name 		= "$action_cloud_blood",
		description = "$actiondesc_cloud_blood",
		sprite 		= "data/ui_gfx/gun_actions/cloud_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/cloud_blood.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_BLOOD
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3,0.3", -- CLOUD_BLOOD
		price = 200,
		mana = 60,
		max_uses = 3,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/cloud_blood.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "CLOUD_ACID",
		name 		= "$action_cloud_acid",
		description = "$actiondesc_cloud_acid",
		sprite 		= "data/ui_gfx/gun_actions/cloud_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/cloud_acid.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_ACID
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2,0.2", -- CLOUD_ACID
		price = 180,
		mana = 90,
		max_uses = 8,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/cloud_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "CLOUD_THUNDER",
		name 		= "$action_cloud_thunder",
		description = "$actiondesc_cloud_thunder",
		sprite 		= "data/ui_gfx/gun_actions/cloud_thunder.png",
		spawn_requires_flag = "card_unlocked_cloud_thunder",
		sprite_unidentified = "data/ui_gfx/gun_actions/cloud_water_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/cloud_thunder.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- CLOUD_THUNDER
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3,0.3", -- CLOUD_THUNDER
		price = 190,
		mana = 90,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/cloud_thunder.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},
	{
		id          = "ELECTRIC_CHARGE",
		name 		= "$action_electric_charge",
		description = "$actiondesc_electric_charge",
		sprite 		= "data/ui_gfx/gun_actions/electric_charge.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/particles/electricity.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- ELECTRIC_CHARGE
		spawn_probability                 = "1,1,1,1", -- ELECTRIC_CHARGE
		price = 150,
		mana = 8,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.lightning_count = c.lightning_count + 1
			c.damage_electricity_add = c.damage_electricity_add + 0.1
			c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "MATTER_EATER",
		name 		= "$action_matter_eater",
		description = "$actiondesc_matter_eater",
		sprite 		= "data/ui_gfx/gun_actions/matter_eater.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/matter_eater.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,10", -- MATTER_EATER
		spawn_probability                 = "0.1,1,0.1,0.1,0.2", -- MATTER_EATER
		price = 280,
		mana = 120,
		max_uses = 10,
		never_unlimited = true,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/matter_eater.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FREEZE",
		name 		= "$action_freeze",
		description = "$actiondesc_freeze",
		sprite 		= "data/ui_gfx/gun_actions/freeze.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/particles/freeze_charge.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- FREEZE
		spawn_probability                 = "1,1,1,1", -- FREEZE
		price = 140,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.damage_ice_add = c.damage_ice_add + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_frozen.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_BURNING_CRITICAL_HIT",
		name 		= "$action_hitfx_burning_critical_hit",
		description = "$actiondesc_hitfx_burning_critical_hit",
		sprite 		= "data/ui_gfx/gun_actions/burning_critical.png",
		sprite_unidentified = "data/entities/misc/hitfx_burning_critical_hit.xml",
		related_extra_entities = { "data/entities/particles/freeze_charge.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_BURNING_CRITICAL_HIT
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_BURNING_CRITICAL_HIT
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_burning_critical_hit.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_WATER",
		name 		= "$action_hitfx_critical_water",
		description = "$actiondesc_hitfx_critical_water",
		sprite 		= "data/ui_gfx/gun_actions/critical_water.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_water.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_WATER
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_CRITICAL_WATER
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_water.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_OIL",
		name 		= "$action_hitfx_critical_oil",
		description = "$actiondesc_hitfx_critical_oil",
		sprite 		= "data/ui_gfx/gun_actions/critical_oil.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_oil.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_OIL
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_CRITICAL_OIL
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_oil.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_CRITICAL_BLOOD",
		name 		= "$action_hitfx_critical_blood",
		description = "$actiondesc_hitfx_critical_blood",
		sprite 		= "data/ui_gfx/gun_actions/critical_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_critical_blood.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_CRITICAL_BLOOD
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_CRITICAL_BLOOD
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_blood.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_TOXIC_CHARM",
		name 		= "$action_hitfx_toxic_charm",
		description = "$actiondesc_hitfx_toxic_charm",
		sprite 		= "data/ui_gfx/gun_actions/charm_on_toxic.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_toxic_charm.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_TOXIC_CHARM
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_TOXIC_CHARM
		price = 150,
		mana = 70,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_toxic_charm.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_SLIME",
		name 		= "$action_hitfx_explosion_slime",
		description = "$actiondesc_hitfx_explosion_slime",
		sprite 		= "data/ui_gfx/gun_actions/explode_on_slime.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_slime.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_SLIME
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_EXPLOSION_SLIME
		price = 140,
		mana = 20,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_explode_slime.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_SLIME_GIGA",
		name 		= "$action_hitfx_explosion_slime_giga",
		description = "$actiondesc_hitfx_explosion_slime_giga",
		sprite 		= "data/ui_gfx/gun_actions/explode_on_slime_giga.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_slime_giga.xml", "data/entities/particles/tinyspark_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_SLIME_GIGA
		spawn_probability                 = "0.1,0.1,0.1,0.1", -- HITFX_EXPLOSION_SLIME_GIGA
		price = 300,
		mana = 200,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_explode_slime_giga.xml,data/entities/particles/tinyspark_purple.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_ALCOHOL",
		name 		= "$action_hitfx_explosion_alcohol",
		description = "$actiondesc_hitfx_explosion_alcohol",
		sprite 		= "data/ui_gfx/gun_actions/explode_on_alcohol.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_alcohol.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_ALCOHOL
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- HITFX_EXPLOSION_ALCOHOL
		price = 140,
		mana = 20,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_explode_alcohol.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_EXPLOSION_ALCOHOL_GIGA",
		name 		= "$action_hitfx_explosion_alcohol_giga",
		description = "$actiondesc_hitfx_explosion_alcohol_giga",
		sprite 		= "data/ui_gfx/gun_actions/explode_on_alcohol_giga.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_explode_alcohol_giga.xml", "data/entities/particles/tinyspark_orange.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,4,5", -- HITFX_EXPLOSION_ALCOHOL_GIGA
		spawn_probability                 = "0.1,0.1,0.1,0.1", -- HITFX_EXPLOSION_ALCOHOL_GIGA
		price = 300,
		mana = 200,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_explode_alcohol_giga.xml,data/entities/particles/tinyspark_orange.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HITFX_PETRIFY",
		name 		= "$action_petrify",
		description = "$actiondesc_petrify_a",
		sprite 		= "data/ui_gfx/gun_actions/petrify.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,5,6", -- PETRIFY
		spawn_probability                 = "0.2,0.2,0.2,0.2", -- PETRIFY
		price = 140,
		mana = 10,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_petrify.xml,"
			draw_actions( 1, true )
		end,
	},
	--[[ { WIP
		id          = "HITFX_POLTERGEIST",
		name 		= "$action_hitfx_poltergeist",
		description = "$actiondesc_hitfx_poltergeist",
		sprite 		= "data/ui_gfx/gun_actions/critical_blood.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/critical_blood.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HITFX_POLTERGEIST
		spawn_probability                 = "", -- HITFX_POLTERGEIST
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_poltergeist.xml,"
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "ROCKET_DOWNWARDS",
		name 		= "$action_rocket_downwards",
		description = "$actiondesc_rocket_downwards",
		sprite 		= "data/ui_gfx/gun_actions/rocket_downwards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/rocket_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- ROCKET_DOWNWARDS
		spawn_probability                 = "0.2,1,1,1", -- ROCKET_DOWNWARDS
		price = 200,
		mana = 90,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/rocket_downwards.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 25
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ROCKET_OCTAGON",
		name 		= "$action_rocket_octagon",
		description = "$actiondesc_rocket_octagon",
		sprite 		= "data/ui_gfx/gun_actions/rocket_octagon.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/rocket_octagon.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- ROCKET_DOWNWARDS
		spawn_probability                 = "0.5,0.5,0.5", -- ROCKET_DOWNWARDS
		price = 200,
		mana = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/rocket_octagon.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIZZLE",
		name 		= "$action_fizzle",
		description = "$actiondesc_fizzle",
		sprite 		= "data/ui_gfx/gun_actions/fizzle.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/fizzle.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- CHAOTIC_ARC
		spawn_probability                 = "0.1,0.1,0.1", -- CHAOTIC_ARC
		price = 0,
		mana = 0,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fizzle.xml,"
			c.speed_multiplier = c.speed_multiplier * 1.2
			c.fire_rate_wait = c.fire_rate_wait - 10
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_EXPLOSION",
		name 		= "$action_bounce_explosion",
		description = "$actiondesc_bounce_explosion",
		sprite 		= "data/ui_gfx/gun_actions/bounce_explosion.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_explosion.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- BOUNCE_EXPLOSION
		spawn_probability                 = "0.2,0.6,0.8,0.8", -- BOUNCE_EXPLOSION
		price = 180,
		mana = 20,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_explosion.xml,"
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 25
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_SPARK",
		name 		= "$action_bounce_spark",
		description = "$actiondesc_bounce_spark",
		sprite 		= "data/ui_gfx/gun_actions/bounce_spark.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_spark.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- BOUNCE_SPARK
		spawn_probability                 = "0.2,0.6,0.6,0.6", -- BOUNCE_SPARK
		price = 120,
		mana = 20,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_spark.xml,"
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 8
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LASER",
		name 		= "$action_bounce_laser",
		description = "$actiondesc_bounce_laser",
		sprite 		= "data/ui_gfx/gun_actions/bounce_laser.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_laser.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- BOUNCE_SPARK
		spawn_probability                 = "0.4,0.8,0.4", -- BOUNCE_SPARK
		price = 180,
		mana = 30,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_laser.xml,"
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 12
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LASER_EMITTER",
		name 		= "$action_bounce_laser_emitter",
		description = "$actiondesc_bounce_laser_emitter",
		sprite 		= "data/ui_gfx/gun_actions/bounce_laser_emitter.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_laser_emitter.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5", -- BOUNCE_SPARK
		spawn_probability                 = "0.4,0.8,0.4", -- BOUNCE_SPARK
		price = 180,
		mana = 40,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_laser_emitter.xml,"
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 12
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 5.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BOUNCE_LARPA",
		name 		= "$action_bounce_larpa",
		description = "$actiondesc_bounce_larpa",
		sprite 		= "data/ui_gfx/gun_actions/bounce_larpa.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/bounce_larpa.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6", -- BOUNCE_SPARK
		spawn_probability                 = "0.4,0.6,0.4", -- BOUNCE_SPARK
		price = 250,
		mana = 80,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/bounce_larpa.xml,"
			c.bounces = c.bounces + 1
			c.fire_rate_wait = c.fire_rate_wait + 32
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY",
		name 		= "$action_fireball_ray",
		description = "$actiondesc_fireball_ray",
		sprite 		= "data/ui_gfx/gun_actions/fireball_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/fireball_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- FIREBALL_RAY
		spawn_probability                 = "0.6,0.6,0.4,0.4", -- FIREBALL_RAY
		price = 150,
		mana = 110,
		max_uses = 16,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fireball_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHTNING_RAY",
		name 		= "$action_lightning_ray",
		description = "$actiondesc_lightning_ray",
		sprite 		= "data/ui_gfx/gun_actions/lightning_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/lightning_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- LIGHTNING_RAY
		spawn_probability                 = "0,0,0.4,0.4,0.4", -- LIGHTNING_RAY
		price = 180,
		mana = 110,
		max_uses = 16,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/lightning_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TENTACLE_RAY",
		name 		= "$action_tentacle_ray",
		description = "$actiondesc_tentacle_ray",
		sprite 		= "data/ui_gfx/gun_actions/tentacle_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/tentacle_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- TENTACLE_RAY
		spawn_probability                 = "0,0,0.4,0.4,0.4", -- TENTACLE_RAY
		price = 150,
		mana = 110,
		max_uses = 16,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/tentacle_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LASER_EMITTER_RAY",
		name 		= "$action_laser_emitter_ray",
		description = "$actiondesc_laser_emitter_ray",
		sprite 		= "data/ui_gfx/gun_actions/laser_emitter_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/laser_emitter_ray.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- TENTACLE_RAY
		spawn_probability                 = "0,0,0.4,0.4,0.4", -- TENTACLE_RAY
		price = 150,
		mana = 110,
		max_uses = 16,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/laser_emitter_ray.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY_LINE",
		name 		= "$action_fireball_ray_line",
		description = "$actiondesc_fireball_ray_line",
		sprite 		= "data/ui_gfx/gun_actions/fireball_ray_line.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/fireball_ray_line.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- FIREBALL_RAY_LINE
		spawn_probability                 = "0.6,0.4,0.4,0.4,1", -- FIREBALL_RAY_LINE
		price = 120,
		mana = 130,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/fireball_ray_line.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIREBALL_RAY_ENEMY",
		name 		= "$action_fireball_ray_enemy",
		description = "$actiondesc_fireball_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/fireball_ray_enemy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_fireball_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.6,0.6,0.4,0.4", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 90,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_fireball_ray_enemy.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LIGHTNING_RAY_ENEMY",
		name 		= "$action_lightning_ray_enemy",
		description = "$actiondesc_lightning_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/lightning_ray_enemy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_lightning_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- LIGHTNING_RAY_ENEMY
		spawn_probability                 = "0,0,0.4,0.4,0.4", -- LIGHTNING_RAY_ENEMY
		price = 150,
		mana = 90,
		max_uses = 20,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_lightning_ray_enemy.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TENTACLE_RAY_ENEMY",
		name 		= "$action_tentacle_ray_enemy",
		description = "$actiondesc_tentacle_ray_enemy",
		sprite 		= "data/ui_gfx/gun_actions/tentacle_ray_enemy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_tentacle_ray_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- TENTACLE_RAY_ENEMY
		spawn_probability                 = "0,0,0.4,0.4,0.4", -- TENTACLE_RAY_ENEMY
		price = 150,
		mana = 90,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_tentacle_ray_enemy.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "GRAVITY_FIELD_ENEMY",
		name 		= "$action_gravity_field_enemy",
		description = "$actiondesc_gravity_field_enemy",
		sprite 		= "data/ui_gfx/gun_actions/gravity_field_enemy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_gravity_field_enemy.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.6,0.6,0.4,0.4", -- GRAVITY_FIELD_ENEMY
		price = 250,
		mana = 110,
		max_uses = 20,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_gravity_field_enemy.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE",
		name 		= "$action_curse",
		description = "$actiondesc_curse",
		sprite 		= "data/ui_gfx/gun_actions/curse.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,5", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.6,0.8,0.4", -- FIREBALL_RAY_ENEMY
		price = 140,
		mana = 30,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_curse.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_PROJECTILE",
		name 		= "$action_curse_wither_projectile",
		description = "$actiondesc_curse_wither_projectile",
		sprite 		= "data/ui_gfx/gun_actions/curse_wither_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_projectile.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.2,0.4,0.9,0.9", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_curse_wither_projectile.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_EXPLOSION",
		name 		= "$action_curse_wither_explosion",
		description = "$actiondesc_curse_wither_explosion",
		sprite 		= "data/ui_gfx/gun_actions/curse_wither_explosion.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_explosion.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.2,0.4,0.9,0.9", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_curse_wither_explosion.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_MELEE",
		name 		= "$action_curse_wither_melee",
		description = "$actiondesc_curse_wither_melee",
		sprite 		= "data/ui_gfx/gun_actions/curse_wither_melee.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_melee.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,5,6", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.2,0.4,0.9,0.9", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_curse_wither_melee.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CURSE_WITHER_ELECTRICITY",
		name 		= "$action_curse_wither_electricity",
		description = "$actiondesc_curse_wither_electricity",
		sprite 		= "data/ui_gfx/gun_actions/curse_wither_electricity.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_curse_wither_electricity.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,4,5,6", -- FIREBALL_RAY_ENEMY
		spawn_probability                 = "0.2,0.4,0.9,0.9", -- FIREBALL_RAY_ENEMY
		price = 100,
		mana = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_curse_wither_electricity.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_DISCS",
		name 		= "$action_orbit_discs",
		description = "$actiondesc_orbit_discs",
		sprite 		= "data/ui_gfx/gun_actions/orbit_discs.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_discs.xml" },
		spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.2,0.8,0.4,0.2", -- GRAVITY_FIELD_ENEMY
		price = 200,
		mana = 70,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_discs.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_FIREBALLS",
		name 		= "$action_orbit_fireballs",
		description = "$actiondesc_orbit_fireballs",
		sprite 		= "data/ui_gfx/gun_actions/orbit_fireballs.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_fireballs.xml" },
		spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,4,5", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.5,0.2,0.8,0.4,0.2", -- GRAVITY_FIELD_ENEMY
		price = 140,
		mana = 40,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_fireballs.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_NUKES",
		name 		= "$action_orbit_nukes",
		description = "$actiondesc_orbit_nukes",
		sprite 		= "data/ui_gfx/gun_actions/orbit_nukes.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_nukes.xml" },
		spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		ai_never_uses = true,
		spawn_level                       = "2,4,5,6,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.1,0.1,0.1,0.2,1", -- GRAVITY_FIELD_ENEMY
		price = 400,
		mana = 250,
		max_uses = 3,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_nukes.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_LASERS",
		name 		= "$action_orbit_lasers",
		description = "$actiondesc_orbit_lasers",
		sprite 		= "data/ui_gfx/gun_actions/orbit_lasers.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_lasers.xml" },
		spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,4,5,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.2,0.8,0.4,0.2,0.2", -- GRAVITY_FIELD_ENEMY
		price = 200,
		mana = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_lasers.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ORBIT_LARPA",
		name 		= "$action_orbit_larpa",
		description = "$actiondesc_orbit_larpa",
		sprite 		= "data/ui_gfx/gun_actions/orbit_larpa.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/orbit_larpa.xml" },
		spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,4,6,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "0.2,0.2,0.8,0.1", -- GRAVITY_FIELD_ENEMY
		price = 240,
		mana = 90,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/orbit_larpa.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CHAIN_SHOT",
		name 		= "$action_chain_shot",
		description = "$actiondesc_chain_shot",
		sprite 		= "data/ui_gfx/gun_actions/chain_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/chain_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,5", -- AREA_DAMAGE
		spawn_probability                 = "0.4,0.6,0.8", -- AREA_DAMAGE
		price = 240,
		mana = 70,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/chain_shot.xml,"
			c.lifetime_add = c.lifetime_add - 30
			c.damage_projectile_add = c.damage_projectile_add - 0.2
			c.explosion_radius = c.explosion_radius - 5.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			c.spread_degrees = c.spread_degrees + 10.0
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "HITFX_OILED_FREEZE",
		name 		= "$action_hitfx_oiled_freeze",
		description = "$actiondesc_hitfx_oiled_freeze",
		sprite 		= "data/ui_gfx/gun_actions/oiled_freeze.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HITFX_OILED_FREEZE
		spawn_probability                 = "", -- HITFX_OILED_FREEZE
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_oiled_freeze.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	--[[
	{
		id          = "ALCOHOL_SHOT",
		name 		= "$action_alcohol_shot",
		description = "$actiondesc_alcohol_shot",
		sprite 		= "data/ui_gfx/gun_actions/inebriation.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- ALCOHOL_SHOT
		spawn_probability                 = "", -- ALCOHOL_SHOT
		price = 70,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_drunk.xml,"
			draw_actions( 1, true )
		end,
	},
	]]--
	--[[
	{
		id          = "FREEZE_IF_WET_SHOOTER",
		name 		= "$action_freeze_if_wet_shooter",
		description = "$actiondesc_freeze_if_wet_shooter",
		sprite 		= "data/ui_gfx/gun_actions/freeze.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- FREEZE_IF_WET_SHOOTER
		spawn_probability                 = "", -- FREEZE_IF_WET_SHOOTER
		price = 140,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/freeze_if_wet_shooter.xml", -- shoteffectcomponent in this effect applies the effect
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	--]]
	--[[
	{
		id          = "BLINDNESS",
		name 		= "$action_blindness",
		description = "$actiondesc_blindness",
		sprite 		= "data/ui_gfx/gun_actions/blindness.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BLINDNESS
		spawn_probability                        = "", -- BLINDNESS
		price = 100,
		mana = 10,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/blindness.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_blindness.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/blindness.xml,"
		end,
	},
	{
		id          = "TELEPORTATION",
		name 		= "$action_teleportation",
		description = "$actiondesc_teleportation",
		sprite 		= "data/ui_gfx/gun_actions/teleportation.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- TELEPORTATION
		spawn_probability                        = "", -- TELEPORTATION
		price = 100,
		mana = 10,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/teleportation.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_teleportation.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/teleportation.xml,"
		end,
	},
	{
		id          = "TELEPATHY",
		name 		= "$action_telepathy",
		description = "$actiondesc_telepathy",
		sprite 		= "data/ui_gfx/gun_actions/telepathy.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "", -- TELEPATHY
		spawn_probability                        = "", -- TELEPATHY
		price = 100,
		mana = 10,
		max_uses = 50,
		--custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_telepathy.xml,"
		end,
	},
	]]--
	{
		id          = "ARC_ELECTRIC",
		name 		= "$action_arc_electric",
		description = "$actiondesc_arc_electric",
		sprite 		= "data/ui_gfx/gun_actions/arc_electric.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_electric_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_electric.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- ARC_ELECTRIC
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.8", -- ARC_ELECTRIC
		price = 170,
		--max_uses 	= 15,
		mana = 15,
		custom_xml_file = "data/entities/misc/custom_cards/arc_electric.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_electric.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_FIRE",
		name 		= "$action_arc_fire",
		description = "$actiondesc_arc_fire",
		sprite 		= "data/ui_gfx/gun_actions/arc_fire.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_fire.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_FIRE
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- ARC_FIRE
		price = 160,
		--max_uses 	= 15,
		mana = 15,
		custom_xml_file = "data/entities/misc/custom_cards/arc_fire.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_fire.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_GUNPOWDER",
		name 		= "$action_arc_gunpowder",
		description = "$actiondesc_arc_gunpowder",
		sprite 		= "data/ui_gfx/gun_actions/arc_gunpowder.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_gunpowder.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_GUNPOWDER
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- ARC_GUNPOWDER
		price = 160,
		--max_uses 	= 15,
		mana = 15,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_gunpowder.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_gunpowder.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ARC_POISON",
		name 		= "$action_arc_poison",
		description = "$actiondesc_arc_poison",
		sprite 		= "data/ui_gfx/gun_actions/arc_poison.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/arc_poison.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_POISON
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- ARC_POISON
		price = 160,
		--max_uses 	= 15,
		mana = 15,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_poison.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_poison.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "CRUMBLING_EARTH_PROJECTILE",
		name 		= "$action_crumbling_earth_projectile",
		description = "$actiondesc_crumbling_earth_projectile",
		sprite 		= "data/ui_gfx/gun_actions/crumbling_earth_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		related_extra_entities = { "data/entities/misc/crumbling_earth_projectile.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ARC_POISON
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4", -- ARC_POISON
		price = 200,
		max_uses 	= 15,
		mana = 45,
		-- custom_xml_file = "data/entities/misc/custom_cards/arc_poison.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/crumbling_earth_projectile.xml,"
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "POLYMORPH",
		name 		= "$action_polymorph",
		description = "$actiondesc_polymorph",
		sprite 		= "data/ui_gfx/gun_actions/polymorph.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- POLYMORPH
		spawn_probability                        = "", -- POLYMORPH
		price = 100,
		max_uses 	= 7,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/polymorph.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile - 0.003
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_polymorph.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/polymorph.xml,"
			-- c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
		end,
	},
	{
		id          = "BERSERK",
		name 		= "$action_berserk",
		description = "$actiondesc_berserk",
		sprite 		= "data/ui_gfx/gun_actions/berserk.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BERSERK
		spawn_probability                        = "", -- BERSERK
		price = 100,
		max_uses    = 12,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/berserk.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_berserk.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/berserk.xml,"
		end,
	},
	{
		id          = "CHARM",
		name 		= "$action_charm",
		description = "$actiondesc_charm",
		sprite 		= "data/ui_gfx/gun_actions/charm.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level       = "", -- CHARM
		spawn_probability = "", -- CHARM
		price = 100,
		max_uses    = 12,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/charm.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_charm.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/charm.xml,"
		end,
	},
	]]--
	{
		id          = "X_RAY",
		name 		= "$action_x_ray",
		description = "$actiondesc_x_ray",
		sprite 		= "data/ui_gfx/gun_actions/x_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/x_ray_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/xray.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6", -- X_RAY
		spawn_probability = "0.8,1,1,0.8,0.6,0.4,0.2", -- X_RAY
		price = 230,
		max_uses    = 10,
		mana = 100,
		custom_xml_file = "data/entities/misc/custom_cards/xray.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/xray.xml")
		end,
	},
	--[[
	{
		id          = "X_RAY_MODIFIER",
		name 		= "$action_x_ray_modifier",
		description = "$actiondesc_x_ray_modifier",
		sprite 		= "data/ui_gfx/gun_actions/x_ray.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/x_ray_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- X_RAY_MODIFIER
		spawn_probability                 = "", -- X_RAY_MODIFIER
		price = 150,
		mana = 8,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/fogofwar_radius.xml",
		action 		= function()
			c.lightning_count = c.lightning_count + 1
			c.damage_electricity_add = c.damage_electricity_add + 0.1
			c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACID",
		name 		= "$action_acid",
		description = "$actiondesc_acid",
		sprite 		= "data/ui_gfx/gun_actions/acid.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- ACID
		spawn_probability                        = "", -- ACID
		price = 100,
		action 		= function()
			material = "acid"
			material_amount = material_amount + 20
		end,
	},]]--
	{
		id          = "UNSTABLE_GUNPOWDER",
		name 		= "$action_unstable_gunpowder",
		description = "$actiondesc_unstable_gunpowder",
		sprite 		= "data/ui_gfx/gun_actions/unstable_gunpowder.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/unstable_gunpowder_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                      = "2,3,4", -- UNSTABLE_GUNPOWDER
		spawn_probability                = "0.3,0.3,0.3", -- UNSTABLE_GUNPOWDER
		price = 140,
		mana = 15,
		--max_uses    = 20, 
		custom_xml_file = "data/entities/misc/custom_cards/unstable_gunpowder.xml",
		action 		= function()
			c.material = "gunpowder_unstable"
			c.material_amount = c.material_amount + 10
			--shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ACID_TRAIL",
		name 		= "$action_acid_trail",
		description = "$actiondesc_acid_trail",
		sprite 		= "data/ui_gfx/gun_actions/acid_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/acid_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- ACID_TRAIL
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3", -- ACID_TRAIL
		price = 160,
		mana = 15,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/acid_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "acid,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions( 1, true )
		end,
	},
	{
		id          = "POISON_TRAIL",
		name 		= "$action_poison_trail",
		description = "$actiondesc_poison_trail",
		sprite 		= "data/ui_gfx/gun_actions/poison_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/poison_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- POISON_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- POISON_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/poison_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_poison.xml,"
			c.trail_material = c.trail_material .. "poison,"
			c.trail_material_amount = c.trail_material_amount + 9
			draw_actions( 1, true )
		end,
	},
	{
		id          = "OIL_TRAIL",
		name 		= "$action_oil_trail",
		description = "$actiondesc_oil_trail",
		sprite 		= "data/ui_gfx/gun_actions/oil_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- OIL_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- OIL_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/oil_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_oiled.xml,"
			c.trail_material = c.trail_material .. "oil,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "WATER_TRAIL",
		name 		= "$action_water_trail",
		description = "$actiondesc_water_trail",
		sprite 		= "data/ui_gfx/gun_actions/water_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- WATER_TRAIL
		spawn_probability                 = "0.3,0.3,0.3,0.3", -- WATER_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/water_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_wet.xml,"
			c.trail_material = c.trail_material .. "water,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,
	},
	-- trail ideas for fun:
	-- * alcohol
	-- * soil
	-- * cement
	-- * grass 
	--[[
	{
		id          = "BLOOD_TRAIL",
		name 		= "$action_blood_trail",
		description = "$actiondesc_blood_trail",
		sprite 		= "data/ui_gfx/gun_actions/blood_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BLOOD_TRAIL
		spawn_probability                 = "", -- BLOOD_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/blood_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "blood,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,
	},]]--
	{
		id          = "GUNPOWDER_TRAIL",
		name 		= "$action_gunpowder_trail",
		description = "$actiondesc_gunpowder_trail",
		sprite 		= "data/ui_gfx/gun_actions/gunpowder_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- GUNPOWDER_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- GUNPOWDER_TRAIL
		price = 160,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/gunpowder_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "gunpowder,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "FIRE_TRAIL",
		name 		= "$action_fire_trail",
		description = "$actiondesc_fire_trail",
		sprite 		= "data/ui_gfx/gun_actions/fire_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fire_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4", -- FIRE_TRAIL
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3", -- FIRE_TRAIL
		price = 130,
		mana = 10,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/fire_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_on_fire.xml,"
			c.trail_material = c.trail_material .. "fire,"
			c.trail_material_amount = c.trail_material_amount + 10
			draw_actions( 1, true )
		end,
	},
	{
		id          = "BURN_TRAIL",
		name 		= "$action_burn_trail",
		description = "$actiondesc_burn_trail",
		sprite 		= "data/ui_gfx/gun_actions/burn_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/burn_trail_unidentified.png",
		related_extra_entities = { "data/entities/misc/burn.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2", -- BURN_TRAIL
		spawn_probability                 = "0.3,0.3,0.3", -- BURN_TRAIL
		price = 100,
		mana = 5,
		--max_uses = 120,
		custom_xml_file = "data/entities/misc/custom_cards/burn_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_on_fire.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/misc/burn.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TORCH",
		name 		= "$action_torch",
		description = "$actiondesc_torch",
		sprite 		= "data/ui_gfx/gun_actions/torch.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2", -- TORCH
		spawn_probability                 = "1,1,1", -- TORCH
		price = 100,
		mana = 0,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/torch.xml",
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TORCH_ELECTRIC",
		name 		= "$action_torch_electric",
		description = "$actiondesc_torch_electric",
		sprite 		= "data/ui_gfx/gun_actions/torch_electric.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2", -- TORCH_ELECTRIC
		spawn_probability                 = "1,1,1", -- TORCH_ELECTRIC
		price = 150,
		mana = 0,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/torch_electric.xml",
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ENERGY_SHIELD",
		name 		= "$action_energy_shield",
		description = "$actiondesc_energy_shield",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6", -- ENERGY_SHIELD
		spawn_probability                 = "0.05,0.6,0.6,0.6,0.6,0.6", -- ENERGY_SHIELD
		price = 220,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ENERGY_SHIELD_SECTOR",
		name 		= "$action_energy_shield_sector",
		description = "$actiondesc_energy_shield_sector",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_sector.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_sector_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5", -- ENERGY_SHIELD_SECTOR
		spawn_probability                 = "0.05,0.6,0.6,0.6,0.6,0.6", -- ENERGY_SHIELD_SECTOR
		price = 160,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_sector.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ENERGY_SHIELD_SHOT",
		name 		= "$action_energy_shield_shot",
		description = "$actiondesc_energy_shield_shot",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_shot_unidentified.png",
		related_extra_entities = { "data/entities/misc/energy_shield_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6", -- ENERGY_SHIELD_SHOT
		spawn_probability                 = "0.3,0.3,0.3,0.3,0.3", -- ENERGY_SHIELD_SHOT
		price = 180,
		mana = 5,
		action 		= function()
			c.speed_multiplier = c.speed_multiplier * 0.4
			c.extra_entities = c.extra_entities .. "data/entities/misc/energy_shield_shot.xml,"
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "TINY_GHOST",
		name 		= "$action_tiny_ghost",
		description = "$actiondesc_tiny_ghost",
		sprite 		= "data/ui_gfx/gun_actions/tiny_ghost.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/torch_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6", -- TINY_GHOST
		spawn_probability                 = "0.1,0.5,1,1,1,1", -- TINY_GHOST
		price = 160,
		mana = 0,
		custom_xml_file = "data/entities/misc/custom_cards/tiny_ghost.xml",
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	--[[
	{
		id          = "DUCK",
		name 		= "$action_duck",
		description = "$actiondesc_duck",
		sprite 		= "data/ui_gfx/gun_actions/duck.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUCK
		spawn_probability                        = "", -- DUCK
		price = 100,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/duck.xml")
			c.damage_critical_chance = c.damage_critical_chance + 5
		end,
	},
	]]--

	--[[
	{
		id          = "DUPLICATE_ON_DEATH",
		name 		= "$action_duplicate_on_death",
		description = "$actiondesc_duplicate_on_death",
		sprite 		= "data/ui_gfx/gun_actions/duplicate_on_death.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUPLICATE_ON_DEATH
		spawn_probability                        = "", -- DUPLICATE_ON_DEATH
		price = 100,
		action 		= function()
			duplicates = duplicates + 1
		end,
	},
	]]--
	--[[
	{
		id          = "BEE",
		name 		= "$action_bee",
		description = "$actiondesc_bee",
		sprite 		= "data/ui_gfx/gun_actions/bee.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BEE
		spawn_probability                        = "", -- BEE
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/fly_all.xml"
		end,
	},
	{
		id          = "DUCK",
		name 		= "$action_duck",
		description = "$actiondesc_duck",
		sprite 		= "data/ui_gfx/gun_actions/duck.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUCK
		spawn_probability                        = "", -- DUCK
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/duck_all.xml"
		end,
	},
	{
		id          = "SHEEP",
		name 		= "$action_sheep",
		description = "$actiondesc_sheep",
		sprite 		= "data/ui_gfx/gun_actions/sheep.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- SHEEP
		spawn_probability                        = "", -- SHEEP
		price = 100,
		action 		= function()
			sprite = "data/enemies_gfx/sheep_all.xml"
		end,
	},
	]]--
	-- other --
	--[[
	{
		id          = "MISFIRE",
		name 		= "$action_misfire",
		description = "$actiondesc_misfire",
		sprite 		= "data/ui_gfx/gun_actions/misfire.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE
		spawn_probability                        = "", -- MISFIRE
		price = 100,
		action 		= function()
			discard_random_action()
		end,
	},
	{
		id          = "MISFIRE_CRITICAL",
		name 		= "$action_misfire_critical",
		description = "$actiondesc_misfire_critical",
		sprite 		= "data/ui_gfx/gun_actions/misfire_critical.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE_CRITICAL
		spawn_probability                        = "", -- MISFIRE_CRITICAL
		price = 100,
		action 		= function()
			destroy_random_action()
		end,
	},
	{
		id          = "GENERATE_RANDOM_DECK_5",
		name 		= "$action_generate_random_deck_5",
		description = "$actiondesc_generate_random_deck_5",
		sprite 		= "data/ui_gfx/gun_actions/generate_random_deck_5.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GENERATE_RANDOM_DECK_5
		spawn_probability                        = "", -- GENERATE_RANDOM_DECK_5
		price = 100,
		action 		= function()
			generate_random_deck(5)
		end,
	},]]--	
	{
		id          = "OCARINA_A",
		name 		= "$action_ocarina_a",
		description = "$actiondesc_ocarina_a",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_a.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_a.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A
		spawn_probability                 = "0", -- OCARINA_A
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_a.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_B",
		name 		= "$action_ocarina_b",
		description = "$actiondesc_ocarina_b",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_b.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_b.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_B
		spawn_probability                 = "0", -- OCARINA_B
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_b.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_C",
		name 		= "$action_ocarina_c",
		description = "$actiondesc_ocarina_c",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_c.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_c.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_C
		spawn_probability                 = "0", -- OCARINA_C
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_c.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_D",
		name 		= "$action_ocarina_d",
		description = "$actiondesc_ocarina_d",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_d.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_d.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_d.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_E",
		name 		= "$action_ocarina_e",
		description = "$actiondesc_ocarina_e",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_e.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_e.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_E
		spawn_probability                 = "0", -- OCARINA_E
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_e.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_F",
		name 		= "$action_ocarina_f",
		description = "$actiondesc_ocarina_f",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_f.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_f.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_F
		spawn_probability                 = "0", -- OCARINA_F
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_f.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_GSHARP",
		name 		= "$action_ocarina_gsharp",
		description = "$actiondesc_ocarina_gsharp",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_gsharp.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_gsharp.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_GSHARP
		spawn_probability                 = "0", -- OCARINA_GSHARP
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_gsharp.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "OCARINA_A2",
		name 		= "$action_ocarina_a2",
		description = "$actiondesc_ocarina_a2",
		spawn_requires_flag = "card_unlocked_ocarina",
		sprite 		= "data/ui_gfx/gun_actions/ocarina_a2.png",
		related_projectiles	= {"data/entities/projectiles/deck/ocarina/ocarina_a2.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A2
		spawn_probability                 = "0", -- OCARINA_A2
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ocarina/ocarina_a2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_A",
		name 		= "$action_kantele_a",
		description = "$actiondesc_kantele_a",
		spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/kantele_a.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_a.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_A
		spawn_probability                 = "0", -- OCARINA_A
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_a.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_D",
		name 		= "$action_kantele_d",
		description = "$actiondesc_kantele_d",
		spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/kantele_d.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_d.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_d.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_DIS",
		name 		= "$action_kantele_dis",
		description = "$actiondesc_kantele_dis",
		spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/kantele_dis.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_dis.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_D
		spawn_probability                 = "0", -- OCARINA_D
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_dis.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_E",
		name 		= "$action_kantele_e",
		description = "$actiondesc_kantele_e",
		spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/kantele_e.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_e.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_E
		spawn_probability                 = "0", -- OCARINA_E
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_e.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "KANTELE_G",
		name 		= "$action_kantele_g",
		description = "$actiondesc_kantele_g",
		spawn_requires_flag = "card_unlocked_kantele",
		sprite 		= "data/ui_gfx/gun_actions/kantele_g.png",
		related_projectiles	= {"data/entities/projectiles/deck/kantele/kantele_g.xml"},
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- OCARINA_GSHARP
		spawn_probability                 = "0", -- OCARINA_GSHARP
		price = 10,
		mana = 1,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/kantele/kantele_g.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "RANDOM_SPELL",
		name 		= "$action_random_spell",
		description = "$actiondesc_random_spell",
		sprite 		= "data/ui_gfx/gun_actions/random_spell.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "3,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.3,0.1,0.1,0.5", -- MANA_REDUCE
		price = 100,
		mana = 5,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 263 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( safety < 100 ) and ( rec == -1 ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_PROJECTILE",
		name 		= "$action_random_projectile",
		description = "$actiondesc_random_projectile",
		sprite 		= "data/ui_gfx/gun_actions/random_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_PROJECTILE,
		recursive	= true,
		spawn_level                       = "2,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.4,0.1,0.1,0.5", -- MANA_REDUCE
		price = 150,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 203 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( safety < 100 ) and ( ( data.type ~= 0 ) or ( rec == -1 ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_MODIFIER",
		name 		= "$action_random_modifier",
		description = "$actiondesc_random_modifier",
		sprite 		= "data/ui_gfx/gun_actions/random_modifier.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_MODIFIER,
		recursive	= true,
		spawn_level                       = "4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.3,0.1,0.1,0.5", -- MANA_REDUCE
		price = 120,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 133 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( safety < 100 ) and ( ( data.type ~= 2 ) or ( rec == -1 ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "RANDOM_STATIC_PROJECTILE",
		name 		= "$action_random_static_projectile",
		description = "$actiondesc_random_static_projectile",
		sprite 		= "data/ui_gfx/gun_actions/random_static_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		recursive	= true,
		spawn_level                       = "3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.1,0.1,0.5", -- MANA_REDUCE
		price = 160,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() + 253 )
			local rnd = Random( 1, #actions )
			local data = actions[rnd]
			
			local safety = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( safety < 100 ) and ( ( data.type ~= 1 ) or ( rec == -1 ) ) do
				rnd = Random( 1, #actions )
				data = actions[rnd]
				rec = check_recursion( data, recursion_level )
				
				safety = safety + 1
			end
			
			data.action( rec )
		end,
	},
	{
		id          = "DRAW_RANDOM",
		name 		= "$action_draw_random",
		description = "$actiondesc_draw_random",
		sprite 		= "data/ui_gfx/gun_actions/draw_random.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "2,3,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.3,0.2,0.2,0.1,0.1,1", -- MANA_REDUCE
		price = 150,
		mana = 20,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			local rnd = Random( 1, datasize )
			
			local data = {}
				
			if ( rnd <= #deck ) then
				data = deck[rnd]
			else
				data = discarded[rnd - #deck]
			end
			
			local checks = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
				rnd = ( rnd % datasize ) + 1
				checks = checks + 1
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				rec = check_recursion( data, recursion_level )
			end
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				data.action( rec )
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
			end
		end,
	},
	{
		id          = "DRAW_RANDOM_X3",
		name 		= "$action_draw_random_x3",
		description = "$actiondesc_draw_random_x3",
		sprite 		= "data/ui_gfx/gun_actions/draw_random_x3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "3,4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.3,0.1,0.1,1", -- MANA_REDUCE
		price = 250,
		mana = 50,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			local rnd = Random( 1, datasize )
			
			local data = {}
				
			if ( rnd <= #deck ) then
				data = deck[rnd]
			else
				data = discarded[rnd - #deck]
			end
			
			local checks = 0
			local rec = check_recursion( data, recursion_level )
			
			while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
				rnd = ( rnd % datasize ) + 1
				checks = checks + 1
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				rec = check_recursion( data, recursion_level )
			end
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				for i=1,3 do
					data.action( rec )
				end
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
			end
		end,
	},
	{
		id          = "DRAW_3_RANDOM",
		name 		= "$action_draw_3_random",
		description = "$actiondesc_draw_3_random",
		sprite 		= "data/ui_gfx/gun_actions/draw_3_random.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_pyramid",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "2,3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,0.1,0.1,1", -- MANA_REDUCE
		price = 200,
		mana = 40,
		action 		= function( recursion_level, iteration )
			SetRandomSeed( GameGetFrameNum() + #deck, GameGetFrameNum() - 325 + #discarded )
			local datasize = #deck + #discarded
			
			for i=1,3 do
				local rnd = Random( 1, datasize )
				
				local data = {}
				
				if ( rnd <= #deck ) then
					data = deck[rnd]
				else
					data = discarded[rnd - #deck]
				end
				
				local checks = 0
				local rec = check_recursion( data, recursion_level )
				
				while ( data ~= nil ) and ( ( rec == -1 ) or ( ( data.uses_remaining ~= nil ) and ( data.uses_remaining == 0 ) ) ) and ( checks < datasize ) do
					rnd = ( rnd % datasize ) + 1
					checks = checks + 1
					
					if ( rnd <= #deck ) then
						data = deck[rnd]
					else
						data = discarded[rnd - #deck]
					end
					
					rec = check_recursion( data, recursion_level )
				end
				
				if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					data.action( rec )
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
				end
			end
		end,
	},
	{
		id          = "ALL_NUKES",
		name 		= "$action_all_nukes",
		description = "$actiondesc_all_nukes",
		sprite 		= "data/ui_gfx/gun_actions/all_nukes.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,1", -- DESTRUCTION
		price = 600,
		mana = 600,
		ai_never_uses = true,
		max_uses    = 2,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_nukes.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_DISCS",
		name 		= "$action_all_discs",
		description = "$actiondesc_all_discs",
		sprite 		= "data/ui_gfx/gun_actions/all_discs.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "0,6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.05,1", -- DESTRUCTION
		price = 400,
		mana = 100,
		--max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_discs.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			current_reload_time = current_reload_time + 50
		end,
	},
	{
		id          = "ALL_ROCKETS",
		name 		= "$action_all_rockets",
		description = "$actiondesc_all_rockets",
		sprite 		= "data/ui_gfx/gun_actions/all_rockets.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.05,1", -- DESTRUCTION
		price = 400,
		mana = 100,
		max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_rockets.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			current_reload_time = current_reload_time + 50
		end,
	},
	{
		id          = "ALL_DEATHCROSSES",
		name 		= "$action_all_deathcrosses",
		description = "$actiondesc_all_deathcrosses",
		sprite 		= "data/ui_gfx/gun_actions/all_deathcrosses.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "2,6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.05,1", -- DESTRUCTION
		price = 350,
		mana = 80,
		max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_deathcrosses.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			current_reload_time = current_reload_time + 40
		end,
	},
	{
		id          = "ALL_BLACKHOLES",
		name 		= "$action_all_blackholes",
		description = "$actiondesc_all_blackholes",
		sprite 		= "data/ui_gfx/gun_actions/all_blackholes.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		never_unlimited		= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "3,6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.05,1", -- DESTRUCTION
		price = 500,
		mana = 200,
		max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_blackholes.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_ACID",
		name 		= "$action_all_acid",
		description = "$actiondesc_all_acid",
		sprite 		= "data/ui_gfx/gun_actions/all_acid.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "4,6,10", -- DESTRUCTION
		spawn_probability                 = "0.1,0.05,1", -- DESTRUCTION
		price = 600,
		mana = 200,
		--max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/all_acid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "ALL_SPELLS",
		name 		= "$action_all_spells",
		description = "$actiondesc_all_spells",
		sprite 		= "data/ui_gfx/gun_actions/all_spells.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_everything",
		spawn_manual_unlock = true,
		never_unlimited		= true,
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		ai_never_uses = true,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 1000,
		mana = 600,
		max_uses    = 1,
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )
			for i,v in ipairs( players ) do
				local x,y = EntityGetTransform( v )
				local eid = EntityLoad("data/entities/projectiles/deck/all_spells_loader.xml", x, y)
			end
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "SUMMON_PORTAL",
		name 		= "$action_summon_portal",
		description = "$actiondesc_summon_portal",
		sprite 		= "data/ui_gfx/gun_actions/summon_portal.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "0", -- MANA_REDUCE
		price = 100,
		mana = 50,
		max_uses = 7,
		custom_xml_file = "data/entities/misc/custom_cards/summon_portal.xml",
		action = function()
			add_projectile("data/entities/projectiles/deck/summon_portal.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
		end,
	},
	{
		id          = "ADD_TRIGGER",
		name 		= "$action_add_trigger",
		description = "$actiondesc_add_trigger",
		sprite 		= "data/ui_gfx/gun_actions/trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,1", -- CRITICAL_HIT
		price = 100,
		mana = 10,
		--max_uses = 50,
		action 		= function()
			local data = {}
			
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							dont_draw_actions = false
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_hit_world(target, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						dont_draw_actions = false
					end
				end
			end
		end,
	},
	{
		id          = "ADD_TIMER",
		name 		= "$action_add_timer",
		description = "$actiondesc_add_timer",
		sprite 		= "data/ui_gfx/gun_actions/timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,1", -- CRITICAL_HIT
		price = 150,
		mana = 20,
		--max_uses = 50,
		action 		= function()
			local data = {}
			
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							dont_draw_actions = false
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_timer(target, 20, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						dont_draw_actions = false
					end
				end
			end
		end,
	},
	{
		id          = "ADD_DEATH_TRIGGER",
		name 		= "$action_add_death_trigger",
		description = "$actiondesc_add_death_trigger",
		sprite 		= "data/ui_gfx/gun_actions/death_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,4,5,10", -- CRITICAL_HIT
		spawn_probability                 = "0.3,0.6,0.6,1", -- CRITICAL_HIT
		price = 150,
		mana = 20,
		--max_uses = 50,
		action 		= function()
			local data = {}
			
			local how_many = 1
			
			if ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			if ( data ~= nil ) then
				while ( #deck >= how_many ) and ( ( data.type == ACTION_TYPE_MODIFIER ) or ( data.type == ACTION_TYPE_PASSIVE ) or ( data.type == ACTION_TYPE_OTHER ) or ( data.type == ACTION_TYPE_DRAW_MANY ) ) do
					if ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) and ( data.id ~= "ADD_TRIGGER" ) and ( data.id ~= "ADD_TIMER" ) and ( data.id ~= "ADD_DEATH_TRIGGER" ) then
						if ( data.type == ACTION_TYPE_MODIFIER ) then
							dont_draw_actions = true
							data.action()
							dont_draw_actions = false
						end
					end
					how_many = how_many + 1
					data = deck[how_many]
				end
				
				if ( data ~= nil ) and ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
					local target = data.related_projectiles[1]
					local count = data.related_projectiles[2] or 1
					
					for i=1,how_many do
						data = deck[1]
						table.insert( discarded, data )
						table.remove( deck, 1 )
					end
					
					local valid = false
					
					for i=1,#deck do
						local check = deck[i]
						
						if ( check ~= nil ) and ( ( check.type == ACTION_TYPE_PROJECTILE ) or ( check.type == ACTION_TYPE_STATIC_PROJECTILE ) or ( check.type == ACTION_TYPE_MATERIAL ) or ( check.type == ACTION_TYPE_UTILITY ) ) then
							valid = true
							break
						end
					end
					
					if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
						data.uses_remaining = data.uses_remaining - 1
						
						local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
						if not reduce_uses then
							data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
						end
					end
					
					if valid then
						for i=1,count do
							add_projectile_trigger_death(target, 1)
						end
					else
						dont_draw_actions = true
						data.action()
						dont_draw_actions = false
					end
				end
			end
		end,
	},
	{
		id          = "LARPA_CHAOS",
		name 		= "$action_larpa_chaos",
		description = "$actiondesc_larpa_chaos",
		sprite 		= "data/ui_gfx/gun_actions/larpa_chaos.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_chaos.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.2,0.3,0.4,0.2", -- FIREBALL_RAY
		price = 260,
		mana = 100,
		--max_uses = 20,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.extra_entities = c.extra_entities .. "data/entities/misc/larpa_chaos.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_DOWNWARDS",
		name 		= "$action_larpa_downwards",
		description = "$actiondesc_larpa_downwards",
		sprite 		= "data/ui_gfx/gun_actions/larpa_downwards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_downwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.3,0.2,0.2,0.2", -- FIREBALL_RAY
		price = 290,
		mana = 120,
		--max_uses = 20,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.extra_entities = c.extra_entities .. "data/entities/misc/larpa_downwards.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_UPWARDS",
		name 		= "$action_larpa_upwards",
		description = "$actiondesc_larpa_upwards",
		sprite 		= "data/ui_gfx/gun_actions/larpa_upwards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_upwards.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.1,0.2,0.4,0.2", -- FIREBALL_RAY
		price = 290,
		mana = 120,
		--max_uses = 20,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.extra_entities = c.extra_entities .. "data/entities/misc/larpa_upwards.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_CHAOS_2",
		name 		= "$action_larpa_chaos_2",
		description = "$actiondesc_larpa_chaos_2",
		sprite 		= "data/ui_gfx/gun_actions/larpa_chaos_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		related_extra_entities = { "data/entities/misc/larpa_chaos_2.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "3,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.4,0.1", -- FIREBALL_RAY
		price = 300,
		mana = 150,
		--max_uses = 20,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.extra_entities = c.extra_entities .. "data/entities/misc/larpa_chaos_2.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "LARPA_DEATH",
		name 		= "$action_larpa_death",
		description = "$actiondesc_larpa_death",
		sprite 		= "data/ui_gfx/gun_actions/larpa_death.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/larpa_death.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- FIREBALL_RAY
		spawn_probability                 = "0.1,0.1,0.3,0.2,0.2", -- FIREBALL_RAY
		price = 150,
		mana = 90,
		max_uses = 30,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.extra_entities = c.extra_entities .. "data/entities/misc/larpa_death.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ALPHA",
		name 		= "$action_alpha",
		description = "$actiondesc_alpha",
		sprite 		= "data/ui_gfx/gun_actions/alpha.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 200,
		mana = 30,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 15
			
			local data = {}
			
			if ( #discarded > 0 ) then
				data = discarded[1]
			elseif ( #hand > 0 ) then
				data = hand[1]
			elseif ( #deck > 0 ) then
				data = deck[1]
			else
				data = nil
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) then
				data.action( rec )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "GAMMA",
		name 		= "$action_gamma",
		description = "$actiondesc_gamma",
		sprite 		= "data/ui_gfx/gun_actions/gamma.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 200,
		mana = 30,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 15
			
			local data = {}
			
			if ( #deck > 0 ) then
				data = deck[#deck]
			elseif ( #hand > 0 ) then
				data = hand[#hand]
			else
				data = nil
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) then
				data.action( rec )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "TAU",
		name 		= "$action_tau",
		description = "$actiondesc_tau",
		sprite 		= "data/ui_gfx/gun_actions/tau.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 200,
		mana = 80,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 35
			
			local data1 = {}
			local data2 = {}
			
			local s1 = ""
			local s2 = ""
			
			if ( #deck > 0 ) then
				s1 = "deck"
				data1 = deck[1]
			else
				data1 = nil
			end
			
			if ( #deck > 0 ) then
				s2 = "deck 2"
				data2 = deck[2]
			else
				data2 = nil
			end
			
			local rec1 = check_recursion( data1, recursion_level )
			local rec2 = check_recursion( data2, recursion_level )
			
			if ( data1 ~= nil ) and ( rec1 > -1 ) then
				-- print("1: " .. tostring(data1.id) .. ", " .. s1)
				data1.action( rec1 )
			end
			
			if ( data2 ~= nil ) and ( rec2 > -1 ) then
				-- print("2: " .. tostring(data2.id) .. ", " .. s2)
				data2.action( rec2 )
			end
			
			--draw_actions( 1, true )
		end,
	},
	{
		id          = "OMEGA",
		name 		= "$action_omega",
		description = "$actiondesc_omega",
		sprite 		= "data/ui_gfx/gun_actions/omega.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 600,
		mana = 300,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 50
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( rec > -1 ) and ( data.id ~= "RESET" ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( ( data.recursive == nil ) or ( data.recursive == false ) ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( rec > -1 ) and ( data.id ~= "RESET" ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
		end,
	},
	{
		id          = "MU",
		name 		= "$action_mu",
		description = "$actiondesc_mu",
		sprite 		= "data/ui_gfx/gun_actions/mu.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 500,
		mana = 120,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 50
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "PHI",
		name 		= "$action_phi",
		description = "$actiondesc_phi",
		sprite 		= "data/ui_gfx/gun_actions/phi.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 500,
		mana = 120,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 50
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 0 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
		end,
	},
	{
		id          = "SIGMA",
		name 		= "$action_sigma",
		description = "$actiondesc_sigma",
		sprite 		= "data/ui_gfx/gun_actions/sigma.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "4,5,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 500,
		mana = 120,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 30
			
			local firerate = c.fire_rate_wait
			local reload = current_reload_time
			local mana_ = mana
			
			if ( discarded ~= nil ) then
				for i,data in ipairs( discarded ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( hand ~= nil ) then
				for i,data in ipairs( hand ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			if ( deck ~= nil ) then
				for i,data in ipairs( deck ) do
					local rec = check_recursion( data, recursion_level )
					if ( data ~= nil ) and ( data.type == 1 ) and ( rec > -1 ) then
						dont_draw_actions = true
						data.action( rec )
						dont_draw_actions = false
					end
				end
			end
			
			c.fire_rate_wait = firerate
			current_reload_time = reload
			mana = mana_
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "ZETA",
		name 		= "$action_zeta",
		description = "$actiondesc_zeta",
		sprite 		= "data/ui_gfx/gun_actions/zeta.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_duplicate",
		type 		= ACTION_TYPE_OTHER,
		spawn_manual_unlock = true,
		recursive	= true,
		spawn_level                       = "1,2,3,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.8,0.6,0.1", -- MANA_REDUCE
		price = 200,
		mana = 10,
		action 		= function( recursion_level, iteration )
			local entity_id = GetUpdatedEntityID()
			local x, y = EntityGetTransform( entity_id )
			local options = {}
			
			local children = EntityGetAllChildren( entity_id )
			local inventory = EntityGetFirstComponent( entity_id, "Inventory2Component" )
			
			if ( children ~= nil ) and ( inventory ~= nil ) then
				local active_wand = ComponentGetValue2( inventory, "mActiveItem" )
				
				for i,child_id in ipairs( children ) do
					if ( EntityGetName( child_id ) == "inventory_quick" ) then
						local wands = EntityGetAllChildren( child_id )
						
						if ( wands ~= nil ) then
							for k,wand_id in ipairs( wands ) do
								if ( wand_id ~= active_wand ) and EntityHasTag( wand_id, "wand" ) then
									local spells = EntityGetAllChildren( wand_id )
									
									if ( spells ~= nil ) then
										for j,spell_id in ipairs( spells ) do
											local comp = EntityGetFirstComponentIncludingDisabled( spell_id, "ItemActionComponent" )
											
											if ( comp ~= nil ) then
												local action_id = ComponentGetValue2( comp, "action_id" )
												
												table.insert( options, action_id )
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			if ( #options > 0 ) then
				SetRandomSeed( x + GameGetFrameNum(), y + 251 )
				
				local rnd = Random( 1, #options )
				local action_id = options[rnd]
				
				for i,data in ipairs( actions ) do
					if ( data.id == action_id ) then
						local rec = check_recursion( data, recursion_level )
						if ( rec > -1 ) then
							dont_draw_actions = true
							data.action( rec )
							dont_draw_actions = false
						end
						break
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DIVIDE_2",
		name 		= "$action_divide_2",
		description = "$actiondesc_divide_2",
		sprite 		= "data/ui_gfx/gun_actions/divide_2.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.2,0.3,0.2,1", -- MANA_REDUCE
		price = 200,
		mana = 35,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 20
			
			local data = {}
			
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 2
			if ( iter >= 5 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if ( i == 1 ) then
						dont_draw_actions = true
					end
					local imax = data.action( rec, iter + 1 )
					dont_draw_actions = false
					if (imax ~= nil) then
						iter_max = imax
					end
				end
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.2
			c.explosion_radius = c.explosion_radius - 5.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			
			c.pattern_degrees = 5
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_3",
		name 		= "$action_divide_3",
		description = "$actiondesc_divide_3",
		sprite 		= "data/ui_gfx/gun_actions/divide_3.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "4,5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,0.2,1", -- MANA_REDUCE
		price = 250,
		mana = 50,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 35
			
			local data = {}
			
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 3
			if ( iter >= 4 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if ( i == 1 ) then
						dont_draw_actions = true
					end
					local imax = data.action( rec, iter + 1 )
					dont_draw_actions = false
					if (imax ~= nil) then
						iter_max = imax
					end
				end
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.4
			c.explosion_radius = c.explosion_radius - 10.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			
			c.pattern_degrees = 5
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_4",
		name 		= "$action_divide_4",
		description = "$actiondesc_divide_4",
		sprite 		= "data/ui_gfx/gun_actions/divide_4.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "5,6,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.1,1", -- MANA_REDUCE
		price = 300,
		mana = 70,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 50
			
			local data = {}
			
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 4
			if ( iter >= 4 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if ( i == 1 ) then
						dont_draw_actions = true
					end
					local imax = data.action( rec, iter + 1 )
					dont_draw_actions = false
					if (imax ~= nil) then
						iter_max = imax
					end
				end
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 0.6
			c.explosion_radius = c.explosion_radius - 20.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			
			c.pattern_degrees = 5
			
			return iter_max
		end,
	},
	{
		id          = "DIVIDE_10",
		name 		= "$action_divide_10",
		description = "$actiondesc_divide_10",
		sprite 		= "data/ui_gfx/gun_actions/divide_10.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_divide",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 400,
		mana = 200,
		max_uses = 5,
		action 		= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 80
			current_reload_time = current_reload_time + 20
			
			local data = {}
			
			local iter = iteration or 1
			local iter_max = iteration or 1
			
			if ( #deck > 0 ) then
				data = deck[iter] or nil
			else
				data = nil
			end
			
			local count = 10
			if ( iter >= 3 ) then
				count = 1
			end
			
			local rec = check_recursion( data, recursion_level )
			
			if ( data ~= nil ) and ( rec > -1 ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
				local firerate = c.fire_rate_wait
				local reload = current_reload_time
				
				for i=1,count do
					if ( i == 1 ) then
						dont_draw_actions = true
					end
					local imax = data.action( rec, iter + 1 )
					dont_draw_actions = false
					if (imax ~= nil) then
						iter_max = imax
					end
				end
				
				if ( data.uses_remaining ~= nil ) and ( data.uses_remaining > 0 ) then
					data.uses_remaining = data.uses_remaining - 1
					
					local reduce_uses = ActionUsesRemainingChanged( data.inventoryitem_id, data.uses_remaining )
					if not reduce_uses then
						data.uses_remaining = data.uses_remaining + 1 -- cancel the reduction
					end
				end
				
				if (iter == 1) then
					c.fire_rate_wait = firerate
					current_reload_time = reload
					
					for i=1,iter_max do
						if (#deck > 0) then
							local d = deck[1]
							table.insert( discarded, d )
							table.remove( deck, 1 )
						end
					end
				end
			end
			
			c.damage_projectile_add = c.damage_projectile_add - 1.5
			c.explosion_radius = c.explosion_radius - 40.0
			if (c.explosion_radius < 0) then
				c.explosion_radius = 0
			end
			
			c.pattern_degrees = 5
			
			return iter_max
		end,
	},
	{
		id          = "METEOR_RAIN",
		name 		= "$action_meteor_rain",
		description = "$actiondesc_meteor_rain",
		sprite 		= "data/ui_gfx/gun_actions/meteor_rain.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= { "data/entities/projectiles/deck/meteor_rain_meteor.xml" },
		related_extra_entities = { "data/entities/misc/effect_meteor_rain.xml" },
		spawn_requires_flag = "card_unlocked_rain",
		never_unlimited		= true,
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,10", -- BOMB
		spawn_probability                 = "0.1,1", -- BOMB
		price = 300,
		mana = 225, 
		max_uses    = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/meteor_rain.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/meteor_rain.xml")
			c.extra_entities = c.extra_entities .. "data/entities/misc/effect_meteor_rain.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 60
		end,
	},
	{
		id          = "WORM_RAIN",
		name 		= "$action_worm_rain",
		description = "$actiondesc_worm_rain",
		sprite 		= "data/ui_gfx/gun_actions/worm_rain.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/animals/worm_big.xml"},
		spawn_requires_flag = "card_unlocked_rain",
		never_unlimited		= true,
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,10", -- BOMB
		spawn_probability                 = "0.1,1", -- BOMB
		price = 300,
		mana = 225, 
		max_uses    = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/worm_rain.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/worm_rain.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 60
		end,
	},
	{
		id          = "RESET",
		name 		= "$action_reset",
		description = "$actiondesc_reset",
		sprite 		= "data/ui_gfx/gun_actions/reset.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		spawn_requires_flag = "card_unlocked_mestari",
		type 		= ACTION_TYPE_UTILITY,
		recursive	= true,
		spawn_level                       = "10", -- BOMB
		spawn_probability                 = "1", -- BOMB
		price = 120,
		mana = 20, 
		action 		= function()
			current_reload_time = current_reload_time - 25
			
			for i,v in ipairs( hand ) do
				-- print( "removed " .. v.id .. " from hand" )
				table.insert( discarded, v )
			end
			
			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			hand = {}
			deck = {}
			
			if ( force_stop_draws == false ) then
				force_stop_draws = true
				move_discarded_to_deck()
				order_deck()
			end
		end,
	},
	{
		id          = "IF_ENEMY",
		name 		= "$action_if_enemy",
		description = "$actiondesc_if_enemy",
		sprite 		= "data/ui_gfx/gun_actions/if_enemy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local x,y = EntityGetTransform( GetUpdatedEntityID() )
			local enemies = EntityGetInRadiusWithTag( x, y, 240, "homing_target" )
			
			local doskip = false
			if ( #enemies < 15 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_PROJECTILE",
		name 		= "$action_if_projectile",
		description = "$actiondesc_if_projectile",
		sprite 		= "data/ui_gfx/gun_actions/if_projectile.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local x,y = EntityGetTransform( GetUpdatedEntityID() )
			local enemies = EntityGetInRadiusWithTag( x, y, 160, "projectile" )
			
			local doskip = false
			if ( #enemies < 20 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_HP",
		name 		= "$action_if_hp",
		description = "$actiondesc_if_hp",
		sprite 		= "data/ui_gfx/gun_actions/if_hp.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local entity_id = GetUpdatedEntityID()
			local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			local hpdiff = 1.0
			
			if ( comp ~= nil ) then
				local hp = ComponentGetValue2( comp, "hp" )
				local max_hp = ComponentGetValue2( comp, "max_hp" )
				
				hpdiff = hp / max_hp
			end
			
			local doskip = false
			if ( hpdiff > 0.25 ) then
				doskip = true
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
					
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
						
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_HALF",
		name 		= "$action_if_half",
		description = "$actiondesc_if_half",
		sprite 		= "data/ui_gfx/gun_actions/if_half.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 100,
		mana = 0,
		action 		= function( recursion_level, iteration )
			local endpoint = -1
			local elsepoint = -1
			local doskip = false
			
			if ( reflecting == false ) then
				local status = tonumber( GlobalsGetValue( "GUN_ACTION_IF_HALF_STATUS", "0" ) ) or 0
				
				if ( status == 1 ) then
					doskip = true
				end
				
				status = 1 - status
				GlobalsSetValue( "GUN_ACTION_IF_HALF_STATUS", tostring( status ) )
			end
			
			if ( #deck > 0 ) then
				for i,v in ipairs( deck ) do
					if ( v ~= nil ) then
						if ( string.sub( v.id, 1, 3 ) == "IF_" ) and ( v.id ~= "IF_END" ) and ( v.id ~= "IF_ELSE" ) then
							endpoint = -1
							break
						end
						
						if ( v.id == "IF_ELSE" ) then
							endpoint = i
							elsepoint = i
						end
						
						if ( v.id == "IF_END" ) then
							endpoint = i
							break
						end
					end
				end
				
				local envelope_min = 1
				local envelope_max = 1
				
				if doskip then
					if ( elsepoint > 0 ) then
						envelope_max = elsepoint
					elseif ( endpoint > 0 ) then
						envelope_max = endpoint
					end
					
					for i=envelope_min,envelope_max do
						local v = deck[envelope_min]
					
						if ( v ~= nil ) then
							table.insert( discarded, v )
							table.remove( deck, envelope_min )
						end
					end
				else
					if ( elsepoint > 0 ) then
						envelope_min = elsepoint
						
						if ( endpoint > 0 ) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end
						
						for i=envelope_min,envelope_max do
							local v = deck[envelope_min]
							
							if ( v ~= nil ) then
								table.insert( discarded, v )
								table.remove( deck, envelope_min )
							end
						end
					end
				end
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_END",
		name 		= "$action_if_end",
		description = "$actiondesc_if_end",
		sprite 		= "data/ui_gfx/gun_actions/if_end.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 10,
		mana = 0,
		action 		= function( recursion_level, iteration )			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "IF_ELSE",
		name 		= "$action_if_else",
		description = "$actiondesc_if_else",
		sprite 		= "data/ui_gfx/gun_actions/if_else.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- MANA_REDUCE
		spawn_probability                 = "1", -- MANA_REDUCE
		price = 10,
		mana = 0,
		action 		= function( recursion_level, iteration )			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_RED",
		name 		= "$action_colour_red",
		description = "$actiondesc_colour_red",
		sprite 		= "data/ui_gfx/gun_actions/colour_red.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_red.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- HOMING
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.2,0.2", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_red.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_ORANGE",
		name 		= "$action_colour_orange",
		description = "$actiondesc_colour_orange",
		sprite 		= "data/ui_gfx/gun_actions/colour_orange.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_orange.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_orange.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_GREEN",
		name 		= "$action_colour_green",
		description = "$actiondesc_colour_green",
		sprite 		= "data/ui_gfx/gun_actions/colour_green.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_green.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_green.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_YELLOW",
		name 		= "$action_colour_yellow",
		description = "$actiondesc_colour_yellow",
		sprite 		= "data/ui_gfx/gun_actions/colour_yellow.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_yellow.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_PURPLE",
		name 		= "$action_colour_purple",
		description = "$actiondesc_colour_purple",
		sprite 		= "data/ui_gfx/gun_actions/colour_purple.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_purple.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_purple.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_BLUE",
		name 		= "$action_colour_blue",
		description = "$actiondesc_colour_blue",
		sprite 		= "data/ui_gfx/gun_actions/colour_blue.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_blue.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_blue.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_RAINBOW",
		name 		= "$action_colour_rainbow",
		description = "$actiondesc_colour_rainbow",
		sprite 		= "data/ui_gfx/gun_actions/colour_rainbow.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_red.xml", "data/entities/misc/colour_rainbow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,data/entities/misc/colour_rainbow.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "COLOUR_INVIS",
		name 		= "$action_colour_invis",
		description = "$actiondesc_colour_invis",
		sprite 		= "data/ui_gfx/gun_actions/colour_invis.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/homing_unidentified.png",
		related_extra_entities = { "data/entities/misc/colour_invis.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4", -- HOMING
		spawn_probability                 = "0.1,0.1,0.1", -- HOMING
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/colour_invis.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if ( c.screenshake < 0 ) then
				c.screenshake = 0
			end
			draw_actions( 1, true )
		end,
	},
	{
		id          = "RAINBOW_TRAIL",
		name 		= "$action_rainbow_trail",
		description = "$actiondesc_rainbow_trail",
		sprite 		= "data/ui_gfx/gun_actions/rainbow_trail.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/oil_trail_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "10", -- rainbow_trail
		spawn_probability                 = "0", -- rainbow_trail
		spawn_requires_flag = "card_unlocked_rainbow_trail",
		price = 100,
		mana = 0,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/rainbow_trail.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_rainbow_farts.xml,"
			c.trail_material = c.trail_material .. "material_rainbow,"
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions( 1, true )
		end,

	},
}

