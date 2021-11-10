function do_chain()
	local entity_id = GetUpdatedEntityID()

	local pos_x  = -2
	local pos_y  = -11
	local offset = -5.5

	local t0 = PhysicsAddBodyImage( entity_id, "data/props_gfx/torch_hang_chain.png", "aluminium", pos_x, pos_y )

	PhysicsAddJoint( entity_id, t0, 1 )
end

do_chain()