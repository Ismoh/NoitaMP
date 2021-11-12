-- actions (cards)

actions =
{
	-- modifiers
	{
		id          = "BURST_2",
		name 		= "Burst (2)",
		description = "Draw 2 more actions",
		sprite 		= "data/ui_gfx/gun_actions/burst_2.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BURST_2
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- BURST_2
		mana = 0,
		action 		= function()
			draw_actions( 2, true )
		end,
	},
	{
		id          = "BURST_3",
		name 		= "Burst (3)",
		description = "Draw 3 more actions",
		sprite 		= "data/ui_gfx/gun_actions/burst_3.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BURST_3
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- BURST_3
		mana = 2,
		action 		= function()
			draw_actions( 3, true )
		end,
	},
	{
		id          = "BURST_4",
		name 		= "Burst (4)",
		description = "Draw 4 more actions",
		sprite 		= "data/ui_gfx/gun_actions/burst_4.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BURST_4
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BURST_4
		mana = 5,
		action 		= function()
			draw_actions( 4, true )
		end,
	},
	{

		id          = "SCATTER_2",
		name 		= "Draw 2 and scattershot",
		description = "Draw 2 and projectiles spread heavily",
		sprite 		= "data/ui_gfx/gun_actions/scatter_2.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SCATTER_2
		spawn_probability                        = "1,7,1,1,1,1,1,1,1,1,1,1", -- SCATTER_2
		mana = 0,
		action 		= function()
			draw_actions( 2, true )
			c.spread_degrees = c.spread_degrees + 5.0
		end,
	},
	{
		id          = "SCATTER_3",
		name 		= "Draw 3 and scattershot",
		description = "Draw 3 and projectiles spread heavily",
		sprite 		= "data/ui_gfx/gun_actions/scatter_3.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                      = "0,1,2,3,4,5,6,7,8,9,10,11", -- SCATTER_3
		spawn_probability                       = "1,10,1,1,1,1,1,1,1,1,1,1", -- SCATTER_3
		mana = 5,
		action 		= function()
			draw_actions( 3, true )
			c.spread_degrees = c.spread_degrees + 10.0
		end,
	},
	{
		id          = "SCATTER_4",
		name 		= "Draw 4 and scattershot",
		description = "Draw 4 and projectiles spread heavily",
		sprite 		= "data/ui_gfx/gun_actions/scatter_4.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SCATTER_4
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- SCATTER_4
		mana = 10,
		action 		= function()
			draw_actions( 4, true )
			c.spread_degrees = c.spread_degrees + 20.0
		end,
	},
	{
		id          = "I_SHAPE",
		name 		= "I shape, draws 2",
		description = "Draw 2 and does an I shape",
		sprite 		= "data/ui_gfx/gun_actions/i_shape.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- I_SHAPE
		spawn_probability                        = "1,2,1,1,1,1,1,1,1,1,1,1", -- I_SHAPE
		mana = 5,
		action 		= function()
			draw_actions(2, true)
			c.pattern_degrees = 180
		end,
	},
	{
		id          = "Y_SHAPE",
		name 		= "Y shape, draws 2",
		description = "Draw 2 and does a Y shape",
		sprite 		= "data/ui_gfx/gun_actions/y_shape.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- Y_SHAPE
		spawn_probability                        = "1,2,1,1,1,1,1,1,1,1,1,1", -- Y_SHAPE
		mana = 5,
		action 		= function()
			draw_actions(2, true)
			c.pattern_degrees = 45
		end,
	},
	{
		id          = "T_SHAPE",
		name 		= "T shape, draws 3",
		description = "Draw 3 and does a T shape",
		sprite 		= "data/ui_gfx/gun_actions/t_shape.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- T_SHAPE
		spawn_probability                        = "1,2,1,1,1,1,1,1,1,1,1,1", -- T_SHAPE
		mana = 10,
		action 		= function()
			draw_actions(3, true)
			c.pattern_degrees = 90
		end,
	},
	{
		id          = "CIRCLE_SHAPE",
		name 		= "Circle shape, draws 6",
		description = "Draw 6 and does a circle shape",
		sprite 		= "data/ui_gfx/gun_actions/circle_shape.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CIRCLE_SHAPE
		spawn_probability                        = "1,2,1,1,1,1,1,1,1,1,1,1", -- CIRCLE_SHAPE
		mana = 20,
		action 		= function()
			draw_actions(6, true)
			c.pattern_degrees = 180
		end,
	},
	{
		id          = "PENTAGRAM_SHAPE",
		name 		= "Pentagram shape",
		description = "Draw 5 and do a pentagon shape",
		sprite 		= "data/ui_gfx/gun_actions/pentagram_shape.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- PENTAGRAM_SHAPE
		spawn_probability                        = "1,2,1,1,1,1,1,1,1,1,1,1", -- PENTAGRAM_SHAPE
		mana = 20,
		action 		= function()
			draw_actions(5, true)
			c.pattern_degrees = 180
			--c.rad_pattern_degrees_offset = 150 // TODO: implement this
			--c.pattern_pos_offset = 30
		end,
	},
	{
		id          = "SPREAD_REDUCE",
		name 		= "Reduce spread",
		description = "Reduces spread",
		sprite 		= "data/ui_gfx/gun_actions/spread_reduce.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SPREAD_REDUCE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SPREAD_REDUCE
		mana = 1,
		action 		= function()
			c.spread_degrees = c.spread_degrees - 30.0
		end,
	},

	--[[
	{
		id          = "PENETRATE_WALLS",
		name 		= "Penetrate walls",
		description = "Penetration +1",
		sprite 		= "data/ui_gfx/gun_actions/penetrate_walls.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- PENETRATE_WALLS
		spawn_probability                        = "", -- PENETRATE_WALLS
		action 		= function()
			penetration_power = penetration_power + 1
		end,
	},]]--
	{
		id          = "SINEWAVE",
		name 		= "Sinewave",
		description = "Sinewave pattern",
		sprite 		= "data/ui_gfx/gun_actions/sinewave.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SINEWAVE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SINEWAVE
		mana = 0,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/sinewave.xml,"
		end,
	},
	{
		id          = "BOUNCE",
		name 		= "Bounce",
		description = "Ricochet",
		sprite 		= "data/ui_gfx/gun_actions/bounce.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BOUNCE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BOUNCE
		mana = 0,
		action 		= function()
			c.bounces = c.bounces + 10
		end,
	},
	{
		id          = "HOMING",
		name 		= "Homing",
		description = "Targets nearest enemy",
		sprite 		= "data/ui_gfx/gun_actions/homing.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- HOMING
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- HOMING
		mana = 50,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/homing.xml,"
		end,
	},
	{
		id          = "DAMAGE",
		name 		= "Damage",
		description = "Extra projectile damage and gore",
		sprite 		= "data/ui_gfx/gun_actions/damage.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DAMAGE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DAMAGE
		mana = 5,
		custom_xml_file = "data/entities/misc/custom_cards/damage.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.4
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
		end,
	},
	{
		id          = "DAMAGE_FRIENDLY",
		name 		= "Damage Friendly",
		description = "Extra projectile damage, but friendly fire is on",
		sprite 		= "data/ui_gfx/gun_actions/damage_friendly.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DAMAGE_FRIENDLY
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DAMAGE_FRIENDLY
		mana = 5,
		custom_xml_file = "data/entities/misc/custom_cards/damage_friendly.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.4
			c.friendly_fire		= true
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
		end,
	},
	{
		id          = "DAMAGE_X2",
		name 		= "Damage x2",
		description = "Doubles the damage",
		sprite 		= "data/ui_gfx/gun_actions/damage_x2.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DAMAGE_X2
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DAMAGE_X2
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/damage_x2.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile * 2
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "HEAVY_SHOT",
		name 		= "Heavy shot",
		description = "Extremely powerful but very slow bullets",
		sprite 		= "data/ui_gfx/gun_actions/heavy_shot.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- HEAVY_SHOT
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- HEAVY_SHOT
		mana = 7,
		custom_xml_file = "data/entities/misc/custom_cards/heavy_shot.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile * 3.5
			c.fire_rate_wait    = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier * 0.3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
			c.extra_entities = c.extra_entities .. "data/entities/particles/heavy_shot.xml,"
		end,
	},
	{
		id          = "KNOCKBACK",
		name 		= "Knockback",
		description = "Projectile has high knockback",
		sprite 		= "data/ui_gfx/gun_actions/knockback.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- KNOCKBACK
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- KNOCKBACK
		mana = 5,
		action 		= function()
			c.knockback_force = c.knockback_force + 500
		end,
	},
	{
		id          = "RECOIL",
		name 		= "Recoil",
		description = "Adds recoil to player",
		sprite 		= "data/ui_gfx/gun_actions/recoil.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- RECOIL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- RECOIL
		mana = 5,
		action 		= function()
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
		end,
	},
	{
		id          = "RECOIL_DAMPER",
		name 		= "Recoil damper",
		description = "Reduces the recoil",
		sprite 		= "data/ui_gfx/gun_actions/recoil_damper.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- RECOIL_DAMPER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- RECOIL_DAMPER
		mana = 5,
		action 		= function()
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 200
		end,
	},
	{
		id          = "SPEED",
		name 		= "Speed+",
		description = "The projectiles move faster.",
		sprite 		= "data/ui_gfx/gun_actions/speed.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SPEED
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SPEED
		mana = 40,
		custom_xml_file = "data/entities/misc/custom_cards/speed.xml",
		action 		= function()
			c.speed_multiplier = c.speed_multiplier * 1.5
		end,
	},
	--[[
	{
		id          = "GORE",
		name 		= "Gore",
		description = "Extra blood",
		sprite 		= "data/ui_gfx/gun_actions/gore.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GORE
		spawn_probability                        = "", -- GORE
		mana = 0,
		action 		= function()
			c.ragdoll_fx = 3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 90.0
		end,
	},
	]]--
	{
		id          = "EXPLOSIVE_PROJECTILE",
		name 		= "Explosive projectile",
		description = "The projectile explodes",
		sprite 		= "data/ui_gfx/gun_actions/explosive_projectile.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- EXPLOSIVE_PROJECTILE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- EXPLOSIVE_PROJECTILE
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/explosive_projectile.xml",
		action 		= function()
			c.explosion_radius = c.explosion_radius + 8.0
			c.damage_explosion = c.damage_explosion + 0.2
			c.fire_rate_wait   = c.fire_rate_wait + 20
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "EXPLOSION",
		name 		= "Explosion",
		description = "A powerful explosion erupts.",
		sprite 		= "data/ui_gfx/gun_actions/explosion.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- EXPLOSION
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- EXPLOSION
		mana = 40,
		custom_xml_file = "data/entities/misc/custom_cards/explosion.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/explosion.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 2.5
		end,
	},
	{
		id          = "FIRE_BLAST",
		name 		= "Fire blast",
		description = "Flames burst suddenly!",
		sprite 		= "data/ui_gfx/gun_actions/fireburst.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FIRE_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FIRE_BLAST
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/fireburst.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/fireburst.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "POISON_BLAST",
		name 		= "Poison blast",
		description = "A dangerous chemical appears!",
		sprite 		= "data/ui_gfx/gun_actions/poisonburst.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POISON_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- POISON_BLAST
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/poison_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/poisonburst.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
		end,
	},
	{
		id          = "THUNDER_BLAST",
		name 		= "Thunder blast",
		description = "Lightning strikes!",
		sprite 		= "data/ui_gfx/gun_actions/thunderburst.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- THUNDER_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- THUNDER_BLAST
		mana = 70,
		custom_xml_file = "data/entities/misc/custom_cards/thunder_blast.xml",
		is_dangerous_blast = true,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thunderburst.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.screenshake = c.screenshake + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "CHARM_FIELD",
		name 		= "Charm field",
		description = "Charms everyone!",
		sprite 		= "data/ui_gfx/gun_actions/charm_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CHARM_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- CHARM_BLAST
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/charm_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "BERSERK_FIELD",
		name 		= "Berserk field",
		description = "Berserks everyone!",
		sprite 		= "data/ui_gfx/gun_actions/berserk_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BERSERK_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BERSERK_BLAST
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/berserk_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "POLYMORPH_FIELD",
		name 		= "Polymorph field",
		description = "Polymorphs everyone!",
		sprite 		= "data/ui_gfx/gun_actions/polymorph_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POLYMORPH_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- POLYMORPH_BLAST
		mana = 50,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "CHAOS_POLYMORPH_FIELD",
		name 		= "Chaos Polymorph field",
		description = "Polymorphs everyone to random enemies!",
		sprite 		= "data/ui_gfx/gun_actions/chaos_polymorph_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POLYMORPH_RANDOM_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- POLYMORPH_RANDOM_BLAST
		mana = 20,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chaos_polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "ELECTROCUTION_FIELD",
		name 		= "Electrocution field",
		description = "Electrocutes everyone!",
		sprite 		= "data/ui_gfx/gun_actions/electrocution_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ELECTROCUTION_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ELECTROCUTION_BLAST
		mana = 60,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/electrocution_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "FREEZE_FIELD",
		name 		= "Freeze field",
		description = "Freezes everyone!",
		sprite 		= "data/ui_gfx/gun_actions/freeze_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FROZEN_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FROZEN_BLAST
		mana = 50,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/freeze_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "REGENERATION_FIELD",
		name 		= "Regeneration field",
		description = "Regenerates everyone!",
		sprite 		= "data/ui_gfx/gun_actions/regeneration_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- REGENERATION_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- REGENERATION_BLAST
		mana = 80,
		max_uses = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/regeneration_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "TELEPORTATION_FIELD",
		name 		= "Teleportation field",
		description = "Teleport things around!",
		sprite 		= "data/ui_gfx/gun_actions/teleportation_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TELEPORTATION_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TELEPORTATION_BLAST
		mana = 30,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleportation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "LEVITATION_FIELD",
		name 		= "Levitation field",
		description = "Levitates everyone!",
		sprite 		= "data/ui_gfx/gun_actions/levitation_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- LEVITATION_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- LEVITATION_BLAST
		mana = 10,
		max_uses = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "TELEPATHY_FIELD",
		name 		= "Telepathy field",
		description = "See things, woop",
		sprite 		= "data/ui_gfx/gun_actions/telepathy_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TELEPATHY_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TELEPATHY_BLAST
		mana = 60,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/telepathy_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "SHIELD_FIELD",
		name 		= "Shield field",
		description = "Shields from things",
		sprite 		= "data/ui_gfx/gun_actions/shield_field.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SHIELD_BLAST
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SHIELD_BLAST
		mana = 20,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/shield_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
			-- c.screenshake = c.screenshake + 3.0
			-- shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	--[[
	{
		id          = "GRAVITY",
		name 		= "Gravity",
		description = "Projectile has a more curved trajectory",
		sprite 		= "data/ui_gfx/gun_actions/gravity.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GRAVITY
		spawn_probability                        = "", -- GRAVITY
		action 		= function()
			gravity = gravity + 2000.0
		end,
	},
	]]--
	{
		id          = "ELECTRIC_CHARGE",
		name 		= "Electric charge",
		description = "Projectile releases an electric charge on impact",
		sprite 		= "data/ui_gfx/gun_actions/electric_charge.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ELECTRIC_CHARGE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ELECTRIC_CHARGE
		mana = 8,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			c.lightning_count = c.lightning_count + 1
			c.damage_electricity = c.damage_electricity + 0.1
			c.extra_entities = c.extra_entities .. "data/entities/particles/electricity.xml,"
		end,
	},
	{
		id          = "FREEZE",
		name 		= "Freeze charge",
		description = "Projectile releases an frozen charge on impact",
		sprite 		= "data/ui_gfx/gun_actions/freeze.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FREEZE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FREEZE
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_frozen.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
		end,
	},
	{
		id          = "BLINDNESS",
		name 		= "Blindness",
		description = "I can't see!",
		sprite 		= "data/ui_gfx/gun_actions/blindness.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BLINDNESS
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BLINDNESS
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/blindness.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_blindness.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/blindness.xml,"
		end,
	},
	{
		id          = "TELEPORTATION",
		name 		= "Teleportation",
		description = "Spatial instability ensues!",
		sprite 		= "data/ui_gfx/gun_actions/teleportation.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TELEPORTATION
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TELEPORTATION
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/teleportation.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_teleportation.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/teleportation.xml,"
		end,
	},
	{
		id          = "TELEPATHY",
		name 		= "Telepathy",
		description = "Sense other beings through walls.",
		sprite 		= "data/ui_gfx/gun_actions/telepathy.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TELEPATHY
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TELEPATHY
		mana = 10,
		--custom_xml_file = "data/entities/misc/custom_cards/freeze.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_telepathy.xml,"
		end,
	},
	{
		id          = "ARC_ELECTRIC",
		name 		= "Electric Arc",
		description = "Electric arcs",
		sprite 		= "data/ui_gfx/gun_actions/arc_electric.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ARC_ELECTRIC
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- ARC_ELECTRIC
		max_uses 	= 15,
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/arc_electric.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_electric.xml,"
		end,
	},
	{
		id          = "ARC_FIRE",
		name 		= "Fire Arc",
		description = "Fire arcs",
		sprite 		= "data/ui_gfx/gun_actions/arc_fire.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ARC_FIRE
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- ARC_FIRE
		max_uses 	= 15,
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/arc_fire.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/arc_fire.xml,"
		end,
	},
	{
		id          = "POLYMORPH",
		name 		= "Polymorph charge",
		description = "Baaaaa",
		sprite 		= "data/ui_gfx/gun_actions/polymorph.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POLYMORPH
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- POLYMORPH
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
		name 		= "Berserk",
		description = "Target enters a state of wild fury, attacking anyone nearby. Attacks get a 2x damage boost.",
		sprite 		= "data/ui_gfx/gun_actions/berserk.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BERSERK
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BERSERK
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
		name 		= "Charm",
		description = "Target becomes friendly to the caster.",
		sprite 		= "data/ui_gfx/gun_actions/charm.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CHARM
		spawn_probability = "1,1,1,1,1,1,1,1,1,1,1,1", -- CHARM
		max_uses    = 12,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/charm.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.2
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_charm.xml,"
			c.extra_entities = c.extra_entities .. "data/entities/particles/charm.xml,"
		end,
	},
	{
		id          = "X_RAY",
		name 		= "All-seeing eye",
		description = "See through walls",
		sprite 		= "data/ui_gfx/gun_actions/xray.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level       = "0,1,2,3,4,5,6,7,8,9,10,11", -- X_RAY
		spawn_probability = "1,1,1,1,1,1,1,1,1,1,1,1", -- X_RAY
		max_uses    = 10,
		mana = 100,
		custom_xml_file = "data/entities/misc/custom_cards/xray.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/xray.xml")
		end,
	},
	--[[
	{
		id          = "ACID",
		name 		= "Acid",
		description = "Projectiles turn into acid on collision",
		sprite 		= "data/ui_gfx/gun_actions/acid.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- ACID
		spawn_probability                        = "", -- ACID
		action 		= function()
			material = "acid"
			material_amount = material_amount + 20
		end,
	},]]--
	{
		id          = "UNSTABLE_GUNPOWDER",
		name 		= "Firecrackers",
		description = "Projectiles explode multiple times on impact",
		sprite 		= "data/ui_gfx/gun_actions/unstable_gunpowder.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                      = "0,1,2,3,4,5,6,7,8,9,10,11", -- UNSTABLE_GUNPOWDER
		spawn_probability                = "1,1,1,1,1,1,1,1,1,1,1,1", -- UNSTABLE_GUNPOWDER
		mana = 15,
		max_uses    = 20, 
		custom_xml_file = "data/entities/misc/custom_cards/unstable_gunpowder.xml",
		action 		= function()
			c.material = "gunpowder_unstable"
			c.material_amount = c.material_amount + 10
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},
	{
		id          = "ACID_TRAIL",
		name 		= "Acid trail",
		description = "Projectiles leave a trail of acid",
		sprite 		= "data/ui_gfx/gun_actions/acid_trail.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ACID_TRAIL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ACID_TRAIL
		mana = 15,
		custom_xml_file = "data/entities/misc/custom_cards/acid_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "acid,"
			c.trail_material_amount = c.trail_material_amount + 5
		end,
	},
	{
		id          = "POISON_TRAIL",
		name 		= "Poison trail",
		description = "Projectiles leave a trail of poison",
		sprite 		= "data/ui_gfx/gun_actions/poison_trail.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POISON_TRAIL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- POISON_TRAIL
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/poison_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "poison,"
			c.trail_material_amount = c.trail_material_amount + 9
		end,
	},
	{
		id          = "FIRE_TRAIL",
		name 		= "Fire trail",
		description = "Projectiles leave a trail of fire",
		sprite 		= "data/ui_gfx/gun_actions/fire_trail.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FIRE_TRAIL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FIRE_TRAIL
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/fire_trail.xml",
		action 		= function()
			c.trail_material = c.trail_material .. "fire,"
			c.trail_material_amount = c.trail_material_amount + 10
		end,
	},
	{
		id          = "FIRE_TRAIL_ALT",
		name 		= "Fire trail alt",
		description = "Projectile starts fires",
		sprite 		= "data/ui_gfx/gun_actions/burn.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FIRE_TRAIL_ALT
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FIRE_TRAIL_ALT
		mana = 5,
		custom_xml_file = "data/entities/misc/custom_cards/burning_projectile.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/burn.xml,"
		end,
	},
	--[[
	{
		id          = "LIGHT",
		name 		= "Light",
		description = "Projectiles illuminate their surroundings",
		sprite 		= "data/ui_gfx/gun_actions/light.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- LIGHT
		spawn_probability                        = "", -- LIGHT
		mana = 0,
		custom_xml_file = "data/entities/misc/custom_cards/action_light.xml",
		action 		= function()
			c.light = c.light + 70.0
		end,
	},
	]]--
	{
		id          = "ENERGY_SHIELD",
		name 		= "Energy shield",
		description = "Deflects incoming projectiles",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ENERGY_SHIELD
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- ENERGY_SHIELD
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield.xml",
		action 		= function()
			-- does nothing to the projectiles
		end,
	},
	{
		id          = "ENERGY_SHIELD_SECTOR",
		name 		= "Energy shield sector",
		description = "Deflects incoming projectiles",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_sector.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ENERGY_SHIELD_SECTOR
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- ENERGY_SHIELD_SECTOR
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_sector.xml",
		action 		= function()
			-- does nothing to the projectiles
		end,
	},
	--[[
	{
		id          = "DUPLICATE_ON_DEATH",
		name 		= "Duplicate",
		description = "Projectile clones itself x2 on collision",
		sprite 		= "data/ui_gfx/gun_actions/duplicate_on_death.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUPLICATE_ON_DEATH
		spawn_probability                        = "", -- DUPLICATE_ON_DEATH
		action 		= function()
			duplicates = duplicates + 1
		end,
	},
	]]--
	--[[
	{
		id          = "BEE",
		name 		= "Bee",
		description = "Bee",
		sprite 		= "data/ui_gfx/gun_actions/bee.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- BEE
		spawn_probability                        = "", -- BEE
		action 		= function()
			sprite = "data/enemies_gfx/fly_all.xml"
		end,
	},
	{
		id          = "DUCK",
		name 		= "Duck",
		description = "Duck!",
		sprite 		= "data/ui_gfx/gun_actions/duck.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- DUCK
		spawn_probability                        = "", -- DUCK
		action 		= function()
			sprite = "data/enemies_gfx/duck_all.xml"
		end,
	},
	{
		id          = "SHEEP",
		name 		= "Sheep",
		description = "Sheep!",
		sprite 		= "data/ui_gfx/gun_actions/sheep.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- SHEEP
		spawn_probability                        = "", -- SHEEP
		action 		= function()
			sprite = "data/enemies_gfx/sheep_all.xml"
		end,
	},
	]]--
	-- other --
	--[[
	{
		id          = "MISFIRE",
		name 		= "Misfire",
		description = "Discard 1 action",
		sprite 		= "data/ui_gfx/gun_actions/misfire.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE
		spawn_probability                        = "", -- MISFIRE
		action 		= function()
			discard_random_action()
		end,
	},
	{
		id          = "MISFIRE_CRITICAL",
		name 		= "Misfire (critical)",
		description = "Permanently destroy 1 action",
		sprite 		= "data/ui_gfx/gun_actions/misfire_critical.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- MISFIRE_CRITICAL
		spawn_probability                        = "", -- MISFIRE_CRITICAL
		action 		= function()
			destroy_random_action()
		end,
	},
	{
		id          = "GENERATE_RANDOM_DECK_5",
		name 		= "Generate random deck (5)",
		description = "Current deck is replaced with a random deck of 5 cards",
		sprite 		= "data/ui_gfx/gun_actions/generate_random_deck_5.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- GENERATE_RANDOM_DECK_5
		spawn_probability                        = "", -- GENERATE_RANDOM_DECK_5
		action 		= function()
			generate_random_deck(5)
		end,
	},
	]]--
	-- projectiles --
	{
		id          = "LIGHT_BULLET",
		name 		= "Spark bolt",
		description = "A weak but enhchanting sparkling projectile.",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- LIGHT_BULLET
		spawn_probability                        = "1,0,1,1,1,1,1,1,1,1,1,1", -- LIGHT_BULLET
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/light_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},
	{
		id          = "AIR_BULLET",
		name 		= "Burst of air",
		description = "Passing of the wind.",
		sprite 		= "data/ui_gfx/gun_actions/air_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- AIR_BULLET
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- AIR_BULLET
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/light_bullet_air.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.1
			c.spread_degrees = c.spread_degrees - 1.0
			c.knockback_force = c.knockback_force + 2
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER",
		name 		= "Spark bolt with trigger",
		description = "A spark bolt that triggers when it hits the world",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- LIGHT_BULLET_TRIGGER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- LIGHT_BULLET_TRIGGER
		mana = 15,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet.xml", 1)
		end,
	},
	{
		id          = "LIGHT_BULLET_TRIGGER_2",
		name 		= "Spark bolt with double trigger",
		description = "A spark bolt that triggers twice when it hits the world",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_trigger_2.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- LIGHT_BULLET_TRIGGER_2
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- LIGHT_BULLET_TRIGGER_2
		mana = 30,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 1
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet.xml", 2)
		end,
	},
	{
		id          = "LIGHT_BULLET_TIMER",
		name 		= "Spark bolt with a timer",
		description = "A spark bolt that triggers things when a short timer runs out",
		sprite 		= "data/ui_gfx/gun_actions/light_bullet_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- LIGHT_BULLET_TIMER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- LIGHT_BULLET_TIMER
		mana = 15,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			add_projectile_trigger_timer("data/entities/projectiles/deck/light_bullet.xml", 10, 1)
		end,
	},
	{
		id          = "BULLET",
		name 		= "Magic arrow",
		description = "A handy magical arrow.",
		sprite 		= "data/ui_gfx/gun_actions/bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BULLET
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- BULLET
		mana = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 1.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "BULLET_TRIGGER",
		name 		= "Magic arrow with trigger",
		description = "A magical arrow that triggers things when it hits the world",
		sprite 		= "data/ui_gfx/gun_actions/bullet_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- BULLET_TRIGGER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- BULLET_TRIGGER
		mana = 35,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 1.0
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "BULLET_TIMER",
		name 		= "Magic arrow with a timer",
		description = "A magical arrow that triggers things when a short timer runs out.",
		sprite 		= "data/ui_gfx/gun_actions/bullet_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- BULLET_TIMER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- BULLET_TIMER
		mana = 35,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 1.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 23.0
		end,
	},
	{
		id          = "HEAVY_BULLET",
		name 		= "Energy bolt",
		description = "A powerful magical projectile.",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- HEAVY_BULLET
		spawn_probability                        = "1,10,1,1,1,1,1,1,1,1,1,1", -- HEAVY_BULLET
		mana = 30,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_heavy.xml")
			c.damage_projectile = c.damage_projectile + 0.1
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 2.5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TRIGGER",
		name 		= "Energy bolt with trigger",
		description = "An energy bolt that triggers when it hits the world",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- HEAVY_BULLET_TRIGGER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- HEAVY_BULLET_TRIGGER
		mana = 40,
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.1
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 2.5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_heavy.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "HEAVY_BULLET_TIMER",
		name 		= "Energy bolt with a timer",
		description = "An energy bolt that triggers when a short timer runs out",
		sprite 		= "data/ui_gfx/gun_actions/heavy_bullet_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- HEAVY_BULLET_TIMER
		spawn_probability                   = "1,4,1,1,1,1,1,1,1,1,1,1", -- HEAVY_BULLET_TIMER
		mana = 40,
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.1
			c.fire_rate_wait = c.fire_rate_wait + 7
			c.screenshake = c.screenshake + 2.5
			c.spread_degrees = c.spread_degrees + 2.5
			-- c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_heavy.xml", 10, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
		end,
	},
	{
		id          = "SLOW_BULLET",
		name 		= "Energy orb",
		description = "A slow but powerful orb of energy.",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SLOW_BULLET
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SLOW_BULLET
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bullet_slow.xml")
			c.damage_projectile = c.damage_projectile + 0.05
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 1.8
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "SLOW_BULLET_TRIGGER",
		name 		= "Energy orb with a trigger",
		description = "A slow but powerful orb of energy with a trigger.",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SLOW_BULLET_TRIGGER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SLOW_BULLET_TRIGGER
		mana = 50,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.05
			c.fire_rate_wait = c.fire_rate_wait + 25
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 5
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bullet_slow.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "SLOW_BULLET_TIMER",
		name 		= "Energy orb with a timer",
		description = "A slow but powerful orb of energy with a timer.",
		sprite 		= "data/ui_gfx/gun_actions/slow_bullet_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SLOW_BULLET_TIMER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SLOW_BULLET_TIMER
		mana = 50,
		custom_xml_file = "data/entities/misc/custom_cards/bullet_slow.xml",
		action 		= function()
			c.damage_projectile = c.damage_projectile + 0.05
			c.fire_rate_wait = c.fire_rate_wait + 6
			c.screenshake = c.screenshake + 2
			c.spread_degrees = c.spread_degrees + 1.8
			add_projectile_trigger_timer("data/entities/projectiles/deck/bullet_slow.xml", 100, 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "BLACK_HOLE",
		name 		= "Black hole",
		description = "Black hole!!!",
		sprite 		= "data/ui_gfx/gun_actions/black_hole.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BLACK_HOLE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BLACK_HOLE
		mana = 60,
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/black_hole.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/black_hole.xml")
			c.fire_rate_wait = c.fire_rate_wait + 80
			c.screenshake = c.screenshake + 10
		end,
	},
	{
		id          = "DECOY",
		name 		= "Decoy",
		description = "Creates a decoy for distracting enemies.",
		sprite 		= "data/ui_gfx/gun_actions/decoy.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DECOY
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DECOY
		mana = 60,
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/decoy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/decoy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "DECOY_TRIGGER",
		name 		= "Decoy with trigger",
		description = "Creates a decoy for distracting enemies; triggers after a duration!",
		sprite 		= "data/ui_gfx/gun_actions/decoy_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DECOY_TRIGGER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DECOY_TRIGGER
		mana = 80,
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/decoy_trigger.xml",
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/decoy_trigger.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "SPITTER",
		name 		= "Spitter bolt",
		description = "A shortlived magical bolt.",
		sprite 		= "data/ui_gfx/gun_actions/spitter.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SPITTER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SPITTER
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/spitter.xml")
			-- damage = 0.1
			c.fire_rate_wait = math.max(c.fire_rate_wait - 1, 0)
			c.screenshake = c.screenshake + 0.1
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 8.0
		end,
	},
	{
		id          = "SPITTER_TIMER",
		name 		= "Spitter bolt with timer",
		description = "A shortlived magical bolt with a timer.",
		sprite 		= "data/ui_gfx/gun_actions/spitter_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SPITTER_TIMER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SPITTER_TIMER
		mana = 10,
		action 		= function()
			-- damage = 0.1
			c.fire_rate_wait = math.max(c.fire_rate_wait - 1, 0)
			c.screenshake = c.screenshake + 0.1
			c.dampening = 0.1
			c.spread_degrees = c.spread_degrees + 8.0
			add_projectile_trigger_timer("data/entities/projectiles/deck/spitter.xml", 40, 1)
		end,
	},
	{
		id          = "BUBBLESHOT",
		name 		= "Bubble spark",
		description = "A bouncy but inaccurate bubble.",
		sprite 		= "data/ui_gfx/gun_actions/bubbleshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BUBBLESHOT
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BUBBLESHOT
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/bubbleshot.xml")
			-- damage = 0.1
			c.fire_rate_wait = math.max(c.fire_rate_wait - 1, 0)
			c.dampening = 0.1
		end,
	},
	{
		id          = "BUBBLESHOT_TRIGGER",
		name 		= "Bubble spark with trigger",
		description = "A bouncy but inaccurate bubble with a trigger.",
		sprite 		= "data/ui_gfx/gun_actions/bubbleshot_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BUBBLESHOT_TRIGGER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BUBBLESHOT_TRIGGER
		mana = 16,
		action 		= function()
			-- damage = 0.1
			c.fire_rate_wait = math.max(c.fire_rate_wait - 1, 0)
			c.dampening = 0.1
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/bubbleshot.xml", 1)
		end,
	},
	{
		id          = "DISC_BULLET",
		name 		= "Disc projectile",
		description = "Summons a sharp disc projectile",
		sprite 		= "data/ui_gfx/gun_actions/disc_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DISC_BULLET
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DISC_BULLET
		mana = 20,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/disc_bullet.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees + 1.0
			c.bounces = c.bounces + 2
			shot_effects.recoil_knockback = 20.0
		end,
	},
	{
		id          = "RUBBER_BALL",
		name 		= "Rubber ball",
		description = "Summons a very bouncy projectile",
		sprite 		= "data/ui_gfx/gun_actions/rubber_ball.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- RUBBER_BALL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- RUBBER_BALL
		mana = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rubber_ball.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.spread_degrees = c.spread_degrees - 0.5
			c.bounces = c.bounces + 2
		end,
	},
	{
		id          = "ARROW",
		name 		= "Arrow",
		description = "Summons an arrow.",
		sprite 		= "data/ui_gfx/gun_actions/arrow.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ARROW
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ARROW
		mana = 15,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/arrow.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.spread_degrees = c.spread_degrees - 10
			c.bounces = c.bounces + 1
			shot_effects.recoil_knockback = 30.0
		end,
	},
	{
		id          = "LANCE",
		name 		= "Lance",
		description = "A magical lance.",
		sprite 		= "data/ui_gfx/gun_actions/lance.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- LANCE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- LANCE
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/lance.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lance.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.spread_degrees = c.spread_degrees - 10
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id          = "ROCKET",
		name 		= "Magic missile",
		description = "A fiery, explosive projectile.",
		sprite 		= "data/ui_gfx/gun_actions/rocket.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ROCKET
		spawn_probability                        = "1,7,1,1,1,1,1,1,1,1,1,1", -- ROCKET
		mana = 70,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/rocket.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			current_reload_time = current_reload_time + 40
			c.ragdoll_fx = 2
			shot_effects.recoil_knockback = 120.0
		end,
	},
	{
		id          = "GRENADE",
		name 		= "Firebolt",
		description = "A bouncy, explosive bolt.",
		sprite 		= "data/ui_gfx/gun_actions/grenade.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- GRENADE
		spawn_probability                        = "1,7,1,1,1,1,1,1,1,1,1,1", -- GRENADE
		mana = 50,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.screenshake = c.screenshake + 4.0
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			current_reload_time = current_reload_time + 40
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id          = "GRENADE_TRIGGER",
		name 		= "Firebolt with trigger",
		description = "A firebolt that triggers things when it hits the world",
		sprite 		= "data/ui_gfx/gun_actions/grenade_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "0,1,2,3,4,5,6,7,8,9,10,11", -- GRENADE_TRIGGER
		spawn_probability                   = "1,1,1,1,1,1,1,1,1,1,1,1", -- GRENADE_TRIGGER
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/grenade_trigger.xml",
		mana = 50,
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.screenshake = c.screenshake + 4.0
			current_reload_time = current_reload_time + 60
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/grenade.xml", 1)
			shot_effects.recoil_knockback = 80.0
		end,
	},
	{
		id 			= "MINE",
		name 		= "Explosive crystal",
		description = "An explosive crystal that detonates when collided with.",
		sprite 		= "data/ui_gfx/gun_actions/mine.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "0,1,2,3,4,5,6,7,8,9,10,11", -- MINE
		spawn_probability	           = "1,1,1,1,1,1,1,1,1,1,1,1", -- MINE
		mana = 20,
		max_uses	= 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mine.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id 			= "MINE_DEATH_TRIGGER",
		name 		= "Explosive crystal with trigger",
		description = "An explosive crystal that detonates and triggers when collided with.",
		sprite 		= "data/ui_gfx/gun_actions/mine_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "0,1,2,3,4,5,6,7,8,9,10,11", -- MINE_DEATH_TRIGGER
		spawn_probability	           = "1,1,1,1,1,1,1,1,1,1,1,1", -- MINE_DEATH_TRIGGER
		mana = 20,
		max_uses	= 10, 
		action 		= function()
			add_projectile_trigger_death("data/entities/projectiles/deck/mine.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			shot_effects.recoil_knockback = 60.0
		end,
	},
	{
		id 			= "PIPE_BOMB",
		name 		= "Explosive crystal",
		description = "An explosive crystal that detonates when triggered.",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level	           = "0,1,2,3,4,5,6,7,8,9,10,11", -- PIPE_BOMB
		spawn_probability	           = "1,1,1,1,1,1,1,1,1,1,1,1", -- PIPE_BOMB
		mana = 20,
		max_uses	= 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pipe_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
		end,
	},
	{
		id          = "PIPE_BOMB_DEATH_TRIGGER",
		name 		= "Explosive crystal with trigger",
		description = "An explosive crystal with a trigger.",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb_death_trigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- PIPE_BOMB_DEATH_TRIGGER
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- PIPE_BOMB_DEATH_TRIGGER
		mana = 20,
		max_uses    = 20, 
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.child_speed_multiplier = c.child_speed_multiplier * 0.75
			c.speed_multiplier = c.speed_multiplier * 0.75
			add_projectile_trigger_death("data/entities/projectiles/deck/pipe_bomb.xml", 1)
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end,
	},
	{
		id          = "EXPLODING_DEER",
		name 		= "Exploding deer",
		description = "Throws an exploding deer.",
		sprite 		= "data/ui_gfx/gun_actions/exploding_deer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- EXPLODING_DEER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- EXPLODING_DEER
		mana = 120,
		max_uses    = 10, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/exploding_deer.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "PIPE_BOMB_DETONATOR",
		name 		= "Detonate explosive crystals",
		description = "Detonates all explosive crystals.",
		sprite 		= "data/ui_gfx/gun_actions/pipe_bomb_detonator.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- PIPE_BOMB_DETONATOR
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- PIPE_BOMB_DETONATOR
		mana = 50,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pipe_bomb_detonator.xml")
			c.fire_rate_wait = c.fire_rate_wait + 5
			current_reload_time = current_reload_time + 5
		end,
	},
	{
		id          = "LASER",
		name 		= "Beam",
		description = "A high-energy beam of light",
		sprite 		= "data/ui_gfx/gun_actions/laser.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- LASER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- LASER
		mana = 30,
		custom_xml_file = "data/entities/misc/custom_cards/laser.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/laser.xml")
			current_reload_time = current_reload_time - 22
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "LIGHTNING",
		name 		= "Lightning",
		description = "A bolt of 120 million volts!",
		sprite 		= "data/ui_gfx/gun_actions/lightning.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- LIGHTNING
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- LIGHTNING
		mana = 70,
		custom_xml_file = "data/entities/misc/custom_cards/electric_charge.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lightning.xml")
			c.fire_rate_wait = c.fire_rate_wait + 50
			shot_effects.recoil_knockback = 180.0
		end,
	},
	{
		id          = "DIGGER",
		name 		= "Digging bolt",
		description = "Ideal for mining operations.",
		sprite 		= "data/ui_gfx/gun_actions/digger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DIGGER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DIGGER
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/digger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "POWERDIGGER",
		name 		= "Digging blast",
		description = "More powerful digging.",
		sprite 		= "data/ui_gfx/gun_actions/powerdigger.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- POWERDIGGER
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- POWERDIGGER
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/powerdigger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 1
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "CHAINSAW",
		name 		= "Chainsaw",
		description = "Good for digging meat.",
		sprite 		= "data/ui_gfx/gun_actions/chainsaw.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CHAINSAW
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- CHAINSAW
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/chainsaw.xml")
			c.fire_rate_wait = 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end,
	},
	{
		id          = "TENTACLE",
		name 		= "Tentacle",
		description = "Terror from another dimension!",
		sprite 		= "data/ui_gfx/gun_actions/tentacle.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TENTACLE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TENTACLE
		mana = 20,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/tentacle.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "TENTACLE_TIMER",
		name 		= "Tentacle with timer",
		description = "Terror from another dimension! Comes with a timer.",
		sprite 		= "data/ui_gfx/gun_actions/tentacle_timer.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TENTACLE_TIMER
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TENTACLE_TIMER
		mana = 20,
		custom_xml_file = "data/entities/misc/custom_cards/tentacle_timer.xml",
		action 		= function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/tentacle.xml",20,1)
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},
	{
		id          = "HEAL BULLET",
		name 		= "Heal bullet",
		description = "Heals what ever it hits.",
		sprite 		= "data/ui_gfx/gun_actions/heal_bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- HEAL BULLET
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- HEAL BULLET
		mana = 15,
		custom_xml_file = "data/entities/misc/custom_cards/heal_bullet.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/heal_bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.spread_degrees = c.spread_degrees + 1.0
		end,
	},
	{
		id          = "FIREBALL",
		name 		= "Fireball",
		description = "A powerful fiery projectile.",
		sprite 		= "data/ui_gfx/gun_actions/fireball.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FIREBALL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FIREBALL
		mana = 70,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/fireball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/fireball.xml")
			c.spread_degrees = c.spread_degrees + 2.0
			current_reload_time = current_reload_time + 50
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 20.0
		end,
	},
	{
		id          = "METEOR",
		name 		= "Meteor",
		description = "Destructive projectile from the skies.",
		sprite 		= "data/ui_gfx/gun_actions/meteor.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- METEOR
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- METEOR
		mana = 150,
		action 		= function()
			add_projectile("data/entities/projectiles/meteor.xml")
		end,
	},
	{
		id          = "SLIMEBALL",
		name 		= "Slimeball",
		description = "A ball of slime that drips danger!",
		sprite 		= "data/ui_gfx/gun_actions/slimeburst.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- SLIMEBALL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- SLIMEBALL
		mana = 20,
		max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/slimeball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/slime.xml")
			c.spread_degrees = c.spread_degrees + 2.0
			c.fire_rate_wait = c.fire_rate_wait + 10
			c.speed_multiplier = c.speed_multiplier * 1.1
		end,
	},
	{
		id          = "DARKFLAME",
		name 		= "Dark flame",
		description = "A trail of dark, deadly flames appears",
		sprite 		= "data/ui_gfx/gun_actions/darkflame.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DARKFLAME
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DARKFLAME
		mana = 90,
		custom_xml_file = "data/entities/misc/custom_cards/darkflame.xml",
		max_uses    = 30, 
		action 		= function()
			add_projectile("data/entities/projectiles/darkflame.xml")
			current_reload_time = current_reload_time + 30
		end,
	},
	{
		id          = "MISSILE",
		name 		= "Missile",
		description = "A missile!!!",
		sprite 		= "data/ui_gfx/gun_actions/missile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MISSILE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- MISSILE
		mana = 60,
		max_uses    = 15, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/rocket_player.xml")
			current_reload_time = current_reload_time + 60
			c.spread_degrees = c.spread_degrees + 2.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end,
	},
	{
		id          = "PEBBLE",
		name 		= "Pebble",
		description = "Throw an autonomous rock ally.",
		sprite 		= "data/ui_gfx/gun_actions/pebble.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- PEBBLE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- PEBBLE
		mana = 120,
		max_uses    = 20, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/pebble_player.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "DYNAMITE",
		name 		= "Dynamite",
		description = "An explosive stick.",
		sprite 		= "data/ui_gfx/gun_actions/dynamite.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- DYNAMITE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- DYNAMITE
		mana = 50, 
		max_uses    = 25, 
		action 		= function()
			add_projectile("data/entities/projectiles/tnt_small.xml")
			current_reload_time = current_reload_time + 80
			c.spread_degrees = c.spread_degrees + 6.0
		end,
	},
	{
		id          = "CIRCLESHOT_A",
		name 		= "Circle shot",
		description = "Projectiles fly out in a circular pattern!",
		sprite 		= "data/ui_gfx/gun_actions/phantomshot_a.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CIRCLESHOT_A
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- CIRCLESHOT_A
		mana = 80,
		max_uses    = 15,
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_a.xml",
		max_uses    = 40, 
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner_green.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "CIRCLESHOT_B",
		name 		= "Spiral shot",
		description = "Projectiles fly out in a spiral pattern!",
		sprite 		= "data/ui_gfx/gun_actions/phantomshot_b.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- CIRCLESHOT_B
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- CIRCLESHOT_B
		mana = 80,
		max_uses    = 40, 
		custom_xml_file = "data/entities/misc/custom_cards/circleshot_b.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/orbspawner.xml")
			current_reload_time = current_reload_time + 80
		end,
	},
	{
		id          = "ACIDSHOT",
		name 		= "Acid ball",
		description = "A terrifying acidic projectile.",
		sprite 		= "data/ui_gfx/gun_actions/acidshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ACIDSHOT
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ACIDSHOT
		mana = 20,
		max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/acidshot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/acidshot.xml")
			current_reload_time = current_reload_time + 10
		end,
	},
	{
		id          = "THUNDERBALL",
		name 		= "Thunder charge",
		description = "A projectile with immense stored electricity.",
		sprite 		= "data/ui_gfx/gun_actions/thunderball.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- THUNDERBALL
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- THUNDERBALL
		mana = 120,
		max_uses    = 10, 
		custom_xml_file = "data/entities/misc/custom_cards/thunderball.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/thunderball.xml")
			current_reload_time = current_reload_time + 120
		end,
	},
	{
		id          = "BLOOMSHOT",
		name 		= "Slime arc",
		description = "Shoots multiple slimy projectiles in an arc.",
		sprite 		= "data/ui_gfx/gun_actions/bloomshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- BLOOMSHOT
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- BLOOMSHOT
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
		name 		= "Ice circle",
		description = "Shoots icy projectiles in a circle.",
		sprite 		= "data/ui_gfx/gun_actions/icecircle.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- ICECIRCLE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- ICECIRCLE
		mana = 100,
		max_uses    = 30, 
		custom_xml_file = "data/entities/misc/custom_cards/icecircle.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/iceskull_explosion.xml")
			current_reload_time = current_reload_time + 60
		end,
	},
	{
		id          = "FIREBOMB",
		name 		= "Firebomb",
		description = "Slow, fiery bolt that explodes.",
		sprite 		= "data/ui_gfx/gun_actions/firebug.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- FIREBOMB
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- FIREBOMB
		mana = 10,
		max_uses    = 100, 
		custom_xml_file = "data/entities/misc/custom_cards/firebomb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/fireball_firebug.xml")
		end,
	},
	{
		id          = "PINK_ORB",
		name 		= "Homing orb",
		description = "A dangerous, homing orb.",
		sprite 		= "data/ui_gfx/gun_actions/orb_pink_big.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- PINK_ORB
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- PINK_ORB
		mana = 60,
		max_uses    = 25, 
		custom_xml_file = "data/entities/misc/custom_cards/pink_orb.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/orb_pink_big_slow_player.xml")
			current_reload_time = current_reload_time + 40
		end,
	},
	{
		id          = "KEYSHOT",
		name 		= "Key shot",
		description = "A powerful projectile. Nothing out of ordinary.",
		sprite 		= "data/ui_gfx/gun_actions/keyshot.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0", -- KEYSHOT
		spawn_probability                        = "0", -- KEYSHOT
		mana = 300,
		max_uses    = 3, 
		action 		= function()
			add_projectile("data/entities/projectiles/deck/keyshot.xml")
			current_reload_time = current_reload_time + 100
		end,
	},
	{
		id          = "MANA",
		name 		= "Mana",
		description = "Extra mana.",
		sprite 		= "data/ui_gfx/gun_actions/mana.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MANA
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- MANA
		mana = -200,
		max_uses    = 5, 
		custom_xml_file = "data/entities/misc/custom_cards/mana.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/mana.xml")
		end,
	},
	-- DEBUG REMOVE ME --
	{
		id          = "MATERIAL_DEBUG",
		name 		= "shoots debug material",
		description = "ONLY TO BE USED IN DEBUG MODE!",
		sprite 		= "data/ui_gfx/gun_actions/material_debug.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_DEBUG
		spawn_probability                 = "", -- MATERIAL_DEBUG
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_debug.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_LIQUID",
		name 		= "shoots liquid",
		description = "Drop it in liquid and shoot it!",
		sprite 		= "data/ui_gfx/gun_actions/material_liquid.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- MATERIAL_LIQUID
		spawn_probability                 = "", -- MATERIAL_LIQUID
		mana = 0,
		custom_xml_file = "data/entities/misc/custom_cards/material_liquid.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_liquid.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_WATER",
		name 		= "Water",
		description = "Housing bubble",
		sprite 		= "data/ui_gfx/gun_actions/material_water.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_WATER
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_WATER
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_water.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_OIL",
		name 		= "Oil",
		description = "Global warming",
		sprite 		= "data/ui_gfx/gun_actions/material_oil.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_OIL
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_OIL
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_oil.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_BLOOD",
		name 		= "Blood",
		description = "Medkit",
		sprite 		= "data/ui_gfx/gun_actions/material_blood.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_BLOOD
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_BLOOD
		max_uses = 250,
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_blood.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	-- Materials --
	{
		id          = "MATERIAL_CEMENT",
		name 		= "Cement",
		description = "Housing bubble",
		sprite 		= "data/ui_gfx/gun_actions/material_cement.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_CEMENT
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_CEMENT
		mana = 1,
		mana        = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_cement.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},

	{
		id          = "MATERIAL_LAVA",
		name 		= "Lava",
		description = "Globaler warming",
		sprite 		= "data/ui_gfx/gun_actions/material_lava.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_LAVA
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_LAVA
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_lava.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_GUNPOWDER_EXPLOSIVE",
		name 		= "Explosive gunpowder",
		description = "Housing bubble",
		sprite 		= "data/ui_gfx/gun_actions/material_gunpowder_explosive.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_gunpowder_explosive.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	{
		id          = "MATERIAL_DIRT",
		name 		= "Dirt",
		description = "Will Olli notice this",
		sprite 		= "data/ui_gfx/gun_actions/material_dirt.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- MATERIAL_DIRT
		spawn_probability                 = "1,1,1,1,1,1,1,1,1,1,1,1", -- MATERIAL_DIRT
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/material_dirt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end,
	},
	--[[
	{
		id          = "BUILDING_BOARD_WOOD",
		name 		= "Wooden mold",
		description = "Useful for cement construction. REQUIRES SOLAR POWER TO RECHARGE.",
		sprite 		= "data/ui_gfx/gun_actions/building_board_wood.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_BOARD_WOOD
		spawn_probability                 = "", -- BUILDING_BOARD_WOOD
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
		name 		= "Back wall (rock)",
		description = "Provides structural support. REQUIRES SOLAR POWER TO RECHARGE.",
		sprite 		= "data/ui_gfx/gun_actions/building_back_wall_rock.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_BACK_WALL_ROCK
		spawn_probability                 = "", -- BUILDING_BACK_WALL_ROCK
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
		name 		= "Pressure plate",
		description = "TODO",
		sprite 		= "data/ui_gfx/gun_actions/building_pressure_plate.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_PRESSURE_PLATE
		spawn_probability                 = "", -- BUILDING_PRESSURE_PLATE
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
		name 		= "Temple door",
		description = "TODO",
		sprite 		= "data/ui_gfx/gun_actions/building_physics_templedoor.png",
		type 		= ACTION_TYPE_MATERIAL,
		spawn_level                       = "", -- BUILDING_PHYSICS_TEMPLEDOOR
		spawn_probability                 = "", -- BUILDING_PHYSICS_TEMPLEDOOR
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
		name 		= "Teleport projectile",
		description = "Teleports to where the projectile hits",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- TELEPORT_PROJECTILE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- TELEPORT_PROJECTILE
		mana = 40,
		custom_xml_file = "data/entities/misc/custom_cards/teleport_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},
	--[[
	{
		id          = "TELEPORT_HOME",
		name 		= "Teleport home",
		description = "Creates a portal to the surface that can be used once per each direction",
		sprite 		= "data/ui_gfx/gun_actions/teleport_home.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- TELEPORT_HOME
		spawn_probability                 = "", -- TELEPORT_HOME
		mana = 70,
		max_uses    = 5,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_home.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.screenshake = c.screenshake + 5.0
		end,
	},
	]]--
	--[[{
		id          = "LEVITATION_PROJECTILE",
		name 		= "LEVITATION projectile",
		description = "Levitation stuff",
		sprite 		= "data/ui_gfx/gun_actions/levitation_projectile.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- LEVITATION_PROJECTILE
		spawn_probability                        = "", -- LEVITATION_PROJECTILE
		mana = 80,
		custom_xml_file = "data/entities/misc/custom_cards/levitation_projectile.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/levitation_projectile.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.spread_degrees = c.spread_degrees - 1.0
		end,
	},]]--
	-- one shot actions -------------------------
	{
		id          = "NUKE",
		name 		= "Nuke",
		description = "Take cover",
		sprite 		= "data/ui_gfx/gun_actions/nuke.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7,8,9,10,11", -- NUKE
		spawn_probability                        = "1,1,1,1,1,1,1,1,1,1,1,1", -- NUKE
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
		end,
	},
	--[[
	{
		id          = "HIGH_EXPLOSIVE",
		name 		= "TNT",
		description = "Extremely powerful explosive projectile",
		sprite 		= "data/ui_gfx/gun_actions/high_explosive.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "", -- HIGH_EXPLOSIVE
		spawn_probability                        = "", -- HIGH_EXPLOSIVE
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
		name 		= "Drone",
		description = "More powerful digging",
		sprite 		= "data/ui_gfx/gun_actions/drone.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "", -- DRONE
		spawn_probability                        = "", -- DRONE
		mana = 60,
		max_uses    = 5,
		custom_xml_file = "data/entities/misc/custom_cards/action_drone.xml",
		action 		= function()
			add_projectile("data/entities/misc/player_drone.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
		end,
	},
	]]--
}

























