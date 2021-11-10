dofile("data/scripts/lib/utilities.lua")

function load_rope_two_joints()
	local y = -150
	load_verlet_rope_with_two_joints( "data/entities/verlet_chains/vines/verlet_vine.xml", -20, y, 20, y )
end

function load_rope_one_joint()
	local y = -150
	load_verlet_rope_with_one_joint( "data/entities/verlet_chains/vines/verlet_vine.xml", -120, y )
end