dofile_once("data/scripts/lib/utilities.lua")


function material_area_checker_failed( pos_x, pos_y )
	EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", false)
end

function material_area_checker_success( pos_x, pos_y )
	EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", true)
end
