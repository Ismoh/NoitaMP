dofile_once("data/scripts/lib/utilities.lua")

function stop_mouse_joint()
	print( "stop_mouse_joint")
	local entity_id = GetUpdatedEntityID()

	edit_all_components( entity_id, "PhysicsJointComponent", function(comp,vars)
		vars.delta_x = 0
		vars.delta_y = 0
	end)
end

stop_mouse_joint()