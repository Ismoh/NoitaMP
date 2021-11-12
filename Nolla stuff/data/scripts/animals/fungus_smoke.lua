dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	GameEntityPlaySound(entity_id, "death_buildup" )

	EntityAddComponent2( entity_id, "ParticleEmitterComponent", 
	{ 
		emitted_material_name="plasma_fading_pink",
		x_pos_offset_min=-4,
		y_pos_offset_min=-4,
		x_pos_offset_max=4,
		y_pos_offset_max=4,
		x_vel_min=-60,
		x_vel_max=60,
		y_vel_min=-120,
		y_vel_max=-40,
		count_min=9,
		count_max=15,
		lifetime_min=0.6,
		lifetime_max=3.8,
		create_real_particles=false,
		emit_cosmetic_particles=true,
		emission_interval_min_frames=1,
		emission_interval_max_frames=2,
		airflow_force=6,
		airflow_scale=1.0,
	} )
end