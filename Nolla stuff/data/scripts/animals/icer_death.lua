dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local how_many = 12
	local angle_inc = ( 2 * 3.14159 ) / how_many
	local theta = 0
	local length = 100

	for i=1,how_many do
		local vel_x = math.cos( theta ) * length
		local vel_y = math.sin( theta ) * length
		theta = theta + angle_inc

		shoot_projectile( entity_id, "data/entities/projectiles/ice.xml", pos_x, pos_y, vel_x, vel_y )
	end
end