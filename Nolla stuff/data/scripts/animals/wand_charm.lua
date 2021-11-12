dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	print("wand charm")
	EntityLoad( "data/entities/animals/wand_ghost_charmed.xml", pos_x, pos_y )
end
