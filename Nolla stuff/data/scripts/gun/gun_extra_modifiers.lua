extra_modifiers = 
{
	critical_hit_boost = function()
		c.damage_critical_chance = c.damage_critical_chance + 5
	end,
	
	critical_plus_small = function()
		c.damage_critical_chance = c.damage_critical_chance + 40
	end,
	
	powerful_shot = function()
		c.damage_explosion_add = c.damage_explosion_add + 0.1
		c.damage_projectile_add = c.damage_projectile_add + 0.6
		c.speed_multiplier = c.speed_multiplier * 2.5
		c.lifetime_add = c.lifetime_add + 20
	end,
	
	food_clock = function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/perks/food_clock.xml,"
	end,
	
	damage_plus_small = function()
		c.damage_projectile_add = c.damage_projectile_add + 0.3
		c.damage_projectile_add = c.damage_projectile_add * 1.25
		c.damage_healing_add = c.damage_healing_add * 1.25
	end,

	damage_projectile_boost = function()
		c.damage_projectile_mul = c.damage_projectile_mul + 0.5
	end,

	game_effect_freeze = function()
		c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_frozen.xml,"
	end,
	
	extra_knockback = function()
		c.knockback_force = c.knockback_force + 6
	end,
	
	lower_spread = function()
		c.spread_degrees = c.spread_degrees - 25
		c.damage_explosion_add = c.damage_explosion_add + 0.2
		c.damage_projectile_add = c.damage_projectile_add + 0.5
		c.fire_rate_wait   = c.fire_rate_wait + 2
		shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
	end,
	
	laser_aim = function()
		c.spread_degrees = c.spread_degrees - 20
		c.speed_multiplier = c.speed_multiplier * 1.4
	end,
	
	low_recoil = function()
		c.speed_multiplier = c.speed_multiplier * 0.8
		shot_effects.recoil_knockback = shot_effects.recoil_knockback * 0.5 - 16.0
	end,
	
	bounce = function()
		c.bounces = c.bounces + 3
		c.lifetime_add = c.lifetime_add + 60
	end,
	
	projectile_homing_shooter = function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/perks/projectile_homing_shooter.xml,"
	end,
	
	projectile_homing_shooter_wizard = function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/perks/projectile_homing_shooter.xml,"
	end,
	
	projectile_alcohol_trail = function()
		c.trail_material = c.trail_material .. "alcohol,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	fizzle = function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/fizzle.xml,"
	end,
	
	explosive_projectile = function()
		c.explosion_radius = c.explosion_radius + 15.0
		c.damage_explosion_add = c.damage_explosion_add + 0.4
		c.damage_projectile_add = c.damage_projectile_add + 0.2
		c.fire_rate_wait   = c.fire_rate_wait + 40
		c.speed_multiplier = c.speed_multiplier * 0.75
		shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
	end,
	
	projectile_fire_trail = function()
		c.trail_material = c.trail_material .. "fire,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_acid_trail = function()
		c.trail_material = c.trail_material .. "acid,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_oil_trail = function()
		c.trail_material = c.trail_material .. "oil,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_water_trail = function()
		c.trail_material = c.trail_material .. "water,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_gunpowder_trail = function()
		c.trail_material = c.trail_material .. "gunpowder_unstable,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_poison_trail = function()
		c.trail_material = c.trail_material .. "poison,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	projectile_lava_trail = function()
		c.trail_material = c.trail_material .. "lava,"
		c.trail_material_amount = c.trail_material_amount + 5
	end,
	
	gravity = function()
		c.gravity = c.gravity + 600.0
	end,
	
	antigravity = function()
		c.gravity = c.gravity - 600.0
	end,
	
	duplicate_projectile = function()
		local data = hand[#hand]
		
		SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() - 523 )
		
		if ( data ~= nil ) and ( Random( 1, 2 ) == 1 ) then
			data.action()
		end
	end,
	
	high_spread = function()
		c.spread_degrees = c.spread_degrees + 30
	end,
	
	extreme_spread = function()
		c.spread_degrees = c.spread_degrees + 80
	end,
	
	fast_projectiles = function()
		c.speed_multiplier = c.speed_multiplier * 1.75
	end,
	
	slow_firing = function()
		c.fire_rate_wait   = c.fire_rate_wait + 5
		current_reload_time = current_reload_time + 5
	end,
}
