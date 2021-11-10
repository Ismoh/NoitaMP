dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		EntityAddComponent( entity_id, "HomingComponent", 
		{ 
			homing_targeting_coeff = "130.0",
			homing_velocity_multiplier = "0.86",
		} )
	end
end