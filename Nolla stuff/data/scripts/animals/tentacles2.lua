function add_tentacles()
	local entity_id = GetUpdatedEntityID()

	local pos_x  = 7
	local pos_y  = 0
	local offset = 11
	local t0 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_0.png", "meat_slime_green", pos_x          , pos_y )
	local t1 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_1.png", "meat_slime_green", pos_x +offset*1, pos_y )
	local t2 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_2.png", "meat_slime_green", pos_x +offset*2, pos_y )
	local t3 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_3.png", "meat_slime_green", pos_x +offset*3, pos_y )
	local ta = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/tentacle_head.png",        "meat_slime_green",  0, 0 )

	PhysicsAddJoint( entity_id, ta, t0 )
	PhysicsAddJoint( entity_id, t0, t1 )	
	PhysicsAddJoint( entity_id, t1, t2 )	
	PhysicsAddJoint( entity_id, t2, t3 )	
	

	t0 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_0.png", "meat_slime_green", pos_x          , pos_y + 5 )
	t1 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_1.png", "meat_slime_green", pos_x +offset*1, pos_y + 5 )
	t2 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_2.png", "meat_slime_green", pos_x +offset*2, pos_y + 5 )
	t3 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_3.png", "meat_slime_green", pos_x +offset*3, pos_y + 5 )
	PhysicsAddJoint( entity_id, ta, t0 )
	PhysicsAddJoint( entity_id, t0, t1 )
	PhysicsAddJoint( entity_id, t1, t2 )
	PhysicsAddJoint( entity_id, t2, t3 )

	t0 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_0.png", "meat_slime_green", pos_x          , pos_y - 3 )
	t1 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_1.png", "meat_slime_green", pos_x +offset*1, pos_y - 3 )
	t2 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_2.png", "meat_slime_green", pos_x +offset*2, pos_y - 3 )
	t3 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_3.png", "meat_slime_green", pos_x +offset*3, pos_y - 3 )
	PhysicsAddJoint( entity_id, ta, t0 )
	PhysicsAddJoint( entity_id, t0, t1 )
	PhysicsAddJoint( entity_id, t1, t2 )
	PhysicsAddJoint( entity_id, t2, t3 )

	local comp_ids  = EntityGetComponent( entity_id, "PhysicsBodyComponent" )
	if( comp_ids ~= nil ) then
		for index,body in ipairs(comp_ids) do
			ComponentSetValue( body, "buoyancy",  "0" )
		end
	end

	--pos_x = 0
	--t0 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_0.png", "meat_slime_green", pos_x          , pos_y + 8 )
	--t1 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_1.png", "meat_slime_green", pos_x +offset*1, pos_y + 8 )
	--t2 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_2.png", "meat_slime_green", pos_x +offset*2, pos_y + 8 )
	--t3 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle3_3.png", "meat_slime_green", pos_x +offset*3, pos_y + 8 )
	--PhysicsAddJoint( entity_id, ta, t0 )
	--PhysicsAddJoint( entity_id, t0, t1 )
	--PhysicsAddJoint( entity_id, t1, t2 )
	--PhysicsAddJoint( entity_id, t2, t3 )
end

add_tentacles()