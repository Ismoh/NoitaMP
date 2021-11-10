print( "hello world" )

function add_tentacles()
	local entity_id = GetUpdatedEntityID()

	local pos_x = 0;
	local pos_y = -7;
	local t0 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle_0.png", "meat", pos_x, pos_y )
	local t1 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle_1.png", "meat", pos_x+22, pos_y )
	local t2 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle_2.png", "meat", pos_x+22*2, pos_y )
	local t3 = PhysicsAddBodyImage( entity_id, "data/enemies_gfx/slimeboss_tentacle_3.png", "meat", pos_x+22*3, pos_y )

	PhysicsAddJoint( entity_id, t0, 1 )

	PhysicsAddJoint( entity_id, t0, t1 )
	PhysicsAddJoint( entity_id, t1, t2 )
	PhysicsAddJoint( entity_id, t2, t3 )
	-- Lua_PhysicsAddJoint( entity_id, t0, t1 )

	-- 1 is the kinetic body...

end

add_tentacles()