function raytrace( x0, y0, x_direction, max_length )
	local hit_something,hit_x,hit_y = Raytrace( x0, y0, x0 + (x_direction * max_length), y0 )
	return hit_x
end

function do_bridge()
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )

	local overlap = 2
	local piece_width_actual = 16
	local piece_width = piece_width_actual - overlap
	local height = 10

	local min_x = raytrace( x, y, -1, 400 )
	local max_x = raytrace( x, y, 1, 400 )

	if not DoesWorldExistAt( min_x, y-1, max_x, y+1 ) then
		return
	end

	-- ---
	local num_pieces = math.floor( (max_x-min_x) / piece_width + 0.5 ) 

	local xstart = min_x - x
	local xpos = xstart

	-- NOTE( Olli ): breaking forces have been adjusted near the self-collapse limit of lava lake bridge, might need tweaking if moved elsewhere or the bridge surroundings are modified
	local break_force_end = 30.0
	local break_force_mid = 0.175
	local break_force_mid_top = 0.09
	local break_distance = 4.0
	local break_distance_end = 4.0

	-- left pole
	EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
	{
		body_id = 10000,
		offset_x = xpos-1,
		offset_y = -height+1,
		image_file = "data/props_breakable_gfx/log_vertical_10_00.png",
		material = CellFactory_GetType( "wood_prop_noplayerhit" ),
	})

	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "WELD_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = xpos,
		offset_y = 0,
		body1_id = 10000,
		break_force = break_force_end * num_pieces * 10.0,
		break_distance = break_distance_end,
		ray_x = -5,
		ray_y = 5,
	})

	-- right pole
	EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
	{
		body_id = 10001,
		offset_x = max_x - x,
		offset_y = -height+1,
		image_file = "data/props_breakable_gfx/log_vertical_10_00.png",
		material = CellFactory_GetType( "wood_prop_noplayerhit" ),
	})

	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "WELD_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = max_x+1 - x,
		offset_y = 0,
		body1_id = 10001,
		break_force = break_force_end * num_pieces * 10.0,
		break_distance = break_distance_end,
		ray_x = 5,
		ray_y = 5,
	})

	-- bottom
	for i=1,num_pieces do
		EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
		{
			body_id = i,
			offset_x = xpos,
			offset_y = 0,
			image_file = "data/props_breakable_gfx/plank_horizontal_16_00.png",
			material = CellFactory_GetType( "wood_prop" ),
		})

		if i>0 then
			EntityAddComponent2( entity_id, "PhysicsJoint2Component",
			{
				type = "REVOLUTE_JOINT",
				offset_x = xpos+1,
				offset_y = 1,
				body1_id = i-1,
				body2_id = i,
				break_force = break_force_mid * num_pieces,
				break_distance = break_distance,
			})
		end

		xpos = xpos + piece_width
	end

	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = xstart,
		offset_y = 1,
		body1_id = 1,
		break_force = break_force_end * num_pieces,
		break_distance = break_distance_end,
		ray_x = -5,
		ray_y = 5,
	})

	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT_ATTACH_TO_NEARBY_SURFACE",
		offset_x = xpos,
		offset_y = 1,
		body1_id = num_pieces,
		break_force = break_force_end * num_pieces,
		break_distance = break_distance_end,
		ray_x = 5,
		ray_y = 5,
	})

	xpos = xstart
	local body_id = num_pieces+1
	local body_id_start = body_id

	-- top
	for i=1,num_pieces do

		EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
		{
			body_id = body_id,
			offset_x = xpos,
			offset_y = -height + 1,
			image_file = "data/props_breakable_gfx/plank_horizontal_16_01.png",
			material = CellFactory_GetType( "wood_prop_noplayerhit" ),
		})

		if i>0 then
			EntityAddComponent2( entity_id, "PhysicsJoint2Component",
			{
				type = "REVOLUTE_JOINT",
				offset_x = xpos+1,
				offset_y = -height + 1,
				body1_id = body_id-1,
				body2_id = body_id,
				break_force = break_force_mid_top * num_pieces,
				break_distance = break_distance,
			})
		end

		xpos = xpos + piece_width
		body_id = body_id + 1
	end

	-- connect top to left pole
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT",
		offset_x = xstart,
		offset_y = -height + 1,
		body1_id = body_id_start,
		body2_id = 10000,
		break_force = break_force_end * num_pieces,
		break_distance = break_distance_end,
	})

	-- connect top to right pole
	EntityAddComponent2( entity_id, "PhysicsJoint2Component",
	{
		type = "REVOLUTE_JOINT",
		offset_x = max_x - x,
		offset_y = -height + 1,
		body1_id = body_id - 1,
		body2_id = 10001,
		break_force = break_force_end * num_pieces,
		break_distance = break_distance_end,
	})

	-- vertical columns linking bottom and top parts
	xpos = xstart + piece_width

	for i=1,num_pieces-1 do
		EntityAddComponent2( entity_id, "PhysicsImageShapeComponent",
		{
			body_id = body_id,
			offset_x = xpos,
			offset_y = -height + 1,
			image_file = "data/props_breakable_gfx/metalrod_vertical_10_00.png",
			material = CellFactory_GetType( "wood_prop_noplayerhit" ),
		})

		EntityAddComponent2( entity_id, "PhysicsJoint2Component",
		{
			type = "REVOLUTE_JOINT",
			offset_x = xpos,
			offset_y = -height + 1,
			body1_id = num_pieces+1+i,
			body2_id = body_id,
			break_force = 5.0,
		})

		EntityAddComponent2( entity_id, "PhysicsJoint2Component",
		{
			type = "REVOLUTE_JOINT",
			offset_x = xpos,
			offset_y = 1,
			body1_id = i,
			body2_id = body_id,
			break_force = 5.0,
		})

		xpos = xpos + piece_width
		body_id = body_id + 1
	end

	-- create bodies and joints, destroy the entity (which is needed only as the spawner)
	PhysicsBody2InitFromComponents( entity_id )
end


do_bridge()
