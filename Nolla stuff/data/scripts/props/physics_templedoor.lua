function do_mouse_joint()
	local entity_id = GetUpdatedEntityID()

	local pos_x  = 0
	local pos_y  = -13
	PhysicsAddJoint( entity_id, 1, -1, pos_x, pos_y, "MOUSE_JOINT" )
	
	--[[
	local comp_ids  = EntityGetComponent( entity_id, "PhysicsJointComponent" )

	if( comp_ids ~= nil ) then
		for index,joint in ipairs(comp_ids) do
			ComponentSetValue( joint, "delta_y",  -1 )
		end
	end

	Component_SetTimeOut( 5*60, "data/scripts/props/physics_stopmousejoint.lua" )
	-- SetTimeOut( 3, "data/scripts/props/physics_stopmousejoint.lua", "stop_mouse_joint" )
	]]--
end

do_mouse_joint()