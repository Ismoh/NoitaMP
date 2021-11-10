function do_chain()
	local entity_id = GetUpdatedEntityID()

	local pos_x  = -2
	local pos_y  = -10
	local offset = -8

	--local t0 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y + 2 )
	local t1 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "metal_chain_nohit", pos_x, pos_y + offset*0.4 )
	local t2 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "metal_chain_nohit", pos_x, pos_y + offset*1.4 )
	local t3 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "metal_chain_nohit", pos_x, pos_y + offset*2.4 )

	--PhysicsAddJoint( entity_id, t0, 1, 0, 0 )
	PhysicsAddJoint( entity_id, t1, 1, 0, -6 )
	PhysicsAddJoint( entity_id, t1, t2 )
	PhysicsAddJoint( entity_id, t2, t3 )
	PhysicsAddJoint( entity_id, t3, -1, 0, pos_y + offset*2.75 )
	
end

do_chain()