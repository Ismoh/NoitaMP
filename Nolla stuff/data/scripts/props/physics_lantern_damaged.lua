dofile_once("data/scripts/lib/utilities.lua")

function physics_body_modified( is_destroyed )
	-- print("damage")
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	EntityLoad( "data/entities/misc/fire.xml", pos_x, pos_y )

end