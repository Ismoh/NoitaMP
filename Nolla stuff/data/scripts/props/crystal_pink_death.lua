dofile_once("data/scripts/lib/utilities.lua")

function death()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )


	local angle_max = math.pi * 0.25

	for i=1,5 do
		local vel_x = 0
		local vel_y = -20
		vel_x, vel_y = vec_rotate(vel_x, vel_y, ProceduralRandomf(pos_x, pos_y - i*4.81, -angle_max, angle_max))
		shoot_projectile( entity_id, "data/entities/projectiles/rocket_crystal_pink.xml", pos_x + vel_x * 0.2, pos_y + vel_y * 0.2, vel_x, vel_y, false )
	end
end