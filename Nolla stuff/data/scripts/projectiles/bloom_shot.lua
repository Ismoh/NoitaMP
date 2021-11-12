dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local how_many = 8
	local angle_inc = (( 2 * 3.14159 ) / how_many) * -0.5
	local theta = angle_inc * -0.3
	local length = 260

	for i=1,how_many do
		local vel_x = math.cos( theta - 0.31415 ) * length
		local vel_y = math.sin( theta - 0.31415 ) * length
		theta = theta + angle_inc

		shoot_projectile( entity_id, "data/entities/projectiles/bloomshot.xml", pos_x + vel_x * 0.05, pos_y + vel_y * 0.05, vel_x, vel_y, false )
	end
end