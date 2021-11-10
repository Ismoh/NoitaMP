dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	EntityLoadToEntity( "data/entities/misc/matter_eater.xml", projectile_id )
end