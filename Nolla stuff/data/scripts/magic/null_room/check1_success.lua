dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	local entity_id = GetUpdatedEntityID()
	
	if ( EntityHasTag( entity_id, "null_room_check" ) == false ) then
		EntityAddTag( entity_id, "null_room_check" )
	end
end
