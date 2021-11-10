function raytrace( x0, y0, x_direction, max_length )

	local min_x = x0
	local max_x = x0
	
	for i=1,3 do
		--print("max_x: " .. tostring(max_x))
		local hit_something, hit_x, hit_y = Raytrace( x0, y0 - 3 + i * 3, x0 + (x_direction * max_length), y0 )
		if( hit_something ) then
			if( min_x == x0 ) then min_x = hit_x end
			if( max_x == x0 ) then max_x = hit_x end
			if( hit_x > min_x ) then min_x = hit_x end
			if( hit_x < max_x ) then max_x = hit_x end
		end
	end

	if( min_x == x0 ) then min_x = x0 - max_length end
	if( max_x == x0 ) then max_x = x0 + max_length end

	if( x_direction < 0 ) then 
		return min_x 
	else 
		return max_x 
	end
end

function do_suspension_bridge()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local min_x = raytrace( x, y, -1, 300 )
	local max_x = raytrace( x, y, 1, 300 )
	min_x = x - min_x
	max_x = max_x - x

	local pos_x0 = -(min_x) + 3
	local pos_x1 = max_x - 5

	local bridge_width = pos_x1 - pos_x0
	local segments = 6
	local overlap = 7
	local width = (bridge_width / segments)
	local height = 5

	local pos_x = pos_x0 + (overlap/2)
	local pos_y = 0
	local prev_body = 0

	local joint_pos_x = pos_x + (overlap/2)
	local joint_pos_y = pos_y + (height/2)

	-- print(segments)
	
	--print(tostring(x) .. ", " .. tostring(min_x) .. ", " .. tostring(max_x) .. ", " .. tostring(pos_x0) .. ", " .. tostring(pos_x1))

	for i=1,segments do
		--print( pos_x - (overlap/2) )
		--print( pos_y )
		local body = PhysicsAddBodyCreateBox( entity_id, "wood_prop", pos_x - (overlap/2), pos_y, width + overlap, height )
		if( prev_body == 0 ) then
			PhysicsAddJoint( entity_id, -1, body, joint_pos_x, joint_pos_y, "REVOLUTE_JOINT", false )			
		else
			PhysicsAddJoint( entity_id, prev_body, body, joint_pos_x, joint_pos_y, "REVOLUTE_JOINT", false )			
		end

		pos_x = pos_x + width
		joint_pos_x = joint_pos_x + width

		prev_body = body
	end

	-- print( "last joint" )
	PhysicsAddJoint( entity_id, prev_body, -1, joint_pos_x, joint_pos_y, "REVOLUTE_JOINT", false )			

	-- const char* func_name = "Lua_PhysicsAddJoint( entity_id, body_id0, body_id1, offset_x, offset_y, string joint_type )";

	-- print(x)
	-- print(y)
	-- PhysicsAddBodyImage( entity_id, "data/props_gfx/physics_bridge/plank_white.png", "wood_prop", 0, 0 )
	-- PhysicsAddBodyCreateBox( entity_id, "wood_prop", 0, 0, 120, 9 )

	--[[
	--local t0 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y + 2 )
	local t1 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y + offset*0.4 )
	local t2 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y + offset*1.4 )
	local t3 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y + offset*2.4 )

	--PhysicsAddJoint( entity_id, t0, 1, 0, 0 )
	PhysicsAddJoint( entity_id, t1, 1, 0, -8 )	
	PhysicsAddJoint( entity_id, t1, t2 )	
	PhysicsAddJoint( entity_id, t2, t3 )	
	PhysicsAddJoint( entity_id, t3, -1, 0, pos_y + offset*2.75 )	
	]]--

end

do_suspension_bridge()