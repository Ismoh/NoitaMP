dofile_once("data/scripts/lib/utilities.lua")

function spawn_ghost()
	-- print( "spawning ghost" )
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	local entity_ghost = EntityLoad( "data/entities/animals/darkghost.xml", pos_x, pos_y )
	
	edit_all_components( entity_ghost, "GhostComponent", function(comp,vars)
		vars.mEntityHome = entity_id
	end)

end

spawn_ghost()
