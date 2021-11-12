function do_crane_section( entity_id, width, height, offset_x, offset_y )

	local pos_x0 = offset_x - (width / 2)
	local pos_y0 = offset_y
	
	--[[
	[1]   /4/[3]
	[1]  /4/ [3]
	[1] /4/  [3]
	[1]/4/   [3]
	[1][2][2][3]
	]]--

	local body1 = PhysicsAddBodyCreateBox( entity_id, "wood_prop", pos_x0, 						pos_y0 - width - height/2, 	height, width )
	local body3 = PhysicsAddBodyCreateBox( entity_id, "wood_prop", pos_x0 + width - height, 	pos_y0 - width - height/2, 	height, width )
	local body2 = PhysicsAddBodyCreateBox( entity_id, "wood_prop", pos_x0, 						pos_y0 - height, 			width, height )
	
	-- const char* func_name = "Lua_PhysicsAddBodyImage( entity_id, image_file, material, offset_x = 0, offset_y = 0, bool centered = false, bool is_circle = false )";
	-- hax
	local body4 = PhysicsAddBodyImage( entity_id,"data/props_gfx/physics_cross_beam_1.png", "wood_prop", pos_x0, pos_y0 - width )


	PhysicsAddJoint( entity_id, body1, body2, pos_x0 + height/2, pos_y0 - height/2 , "REVOLUTE_JOINT" )			
	PhysicsAddJoint( entity_id, body2, body3, pos_x0 + width - height/2, pos_y0 - height/2 , "REVOLUTE_JOINT" )			

	PhysicsAddJoint( entity_id, body1, body4, pos_x0 + height/2, pos_y0 - height/2 , "REVOLUTE_JOINT" )			
	PhysicsAddJoint( entity_id, body2, body4, pos_x0 + height/2, pos_y0 - height/2 , "REVOLUTE_JOINT" )			
	PhysicsAddJoint( entity_id, body3, body4, pos_x0 + width - height/2, pos_y0 - width + height/2 , "REVOLUTE_JOINT" )			

	return body1, body2, body3, body4
end

function do_suspension_bridge()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id, x, y )

	local width = 60
	local height = 8
	
	local body1 = -1
	local body2 = -1
	local body3 = -1
	local body4 = -1
	local prev_body1 = -1
	local prev_body3 = -1

	local pos_x = 0
	local pos_y = 0

	local joint_x = -(width / 2)
	local joint_y = pos_y

	for i=1,3 do
		body1, body2, body3, body4 = do_crane_section( entity_id, width, height, pos_x, pos_y )
		joint_y = pos_y

		if( prev_body1 ~= -1 ) then
			PhysicsAddJoint( entity_id, body2, prev_body1, joint_x + height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
		else
			PhysicsAddJoint( entity_id, body2, prev_body1, joint_x + height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
		end

		if( prev_body3 ~= -1 ) then
			PhysicsAddJoint( entity_id, body2, prev_body3, joint_x + width - height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
		else
			PhysicsAddJoint( entity_id, body2, prev_body3, joint_x + width - height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
		end
		prev_body1 = body1
		prev_body3 = body3
		pos_y = pos_y - width

	end
	-- const char* func_name = "Lua_PhysicsAddBodyImage( entity_id, image_file, material, offset_x = 0, offset_y = 0, bool centered = false, bool is_circle = false, material_image_file = "" )";
		
	--height: 111
	joint_y = pos_y
	pos_x = 0 - ( 226 / 2 )
	pos_y = pos_y - 111

	local tanker = PhysicsAddBodyImage( entity_id, "data/biome_impl/physics_tank_visual.png", "wood_prop", pos_x, pos_y, false, false, "data/biome_impl/physics_tank.png" )
	PhysicsAddJoint( entity_id, tanker, prev_body1, joint_x + height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
	PhysicsAddJoint( entity_id, tanker, prev_body3, joint_x + width - height/2, joint_y - height/2 , "REVOLUTE_JOINT" )			
	

end

do_suspension_bridge()