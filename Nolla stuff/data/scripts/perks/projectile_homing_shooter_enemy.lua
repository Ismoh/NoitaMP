dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		EntityAddComponent( entity_id, "HomingComponent", 
		{
			target_who_shot = "1",
			homing_targeting_coeff = "30.0",
			homing_velocity_multiplier = "0.99",
			detect_distance = "300",
		} )
	end
end