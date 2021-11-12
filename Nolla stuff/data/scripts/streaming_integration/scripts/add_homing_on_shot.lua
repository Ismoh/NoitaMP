dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	EntityAddComponent( projectile_id, "HomingComponent", 
	{ 
		target_tag="prey",
		homing_targeting_coeff="36",
		detect_distance="100",
		homing_velocity_multiplier="0.95",
	})
end