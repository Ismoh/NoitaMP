dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local radius = 1

edit_component( entity_id, "BlackHoleComponent", function(comp,vars)
		radius = tonumber(ComponentGetValue( comp, "radius"))
		radius = math.min(64, radius + 1)
		vars.radius = radius
		vars.particle_attractor_force = radius * 0.25
	end)
	
edit_component( entity_id, "LooseGroundComponent", function(comp,vars)
		vars.max_distance = radius + 20
	end)

edit_component( entity_id, "ParticleEmitterComponent", function(comp,vars)
		ComponentSetValue(comp, "x_pos_offset_min", 0-radius)
		ComponentSetValue(comp, "x_pos_offset_max", radius)
		ComponentSetValue(comp, "y_pos_offset_min", 0-radius)
		ComponentSetValue(comp, "y_pos_offset_max", radius)
	end)