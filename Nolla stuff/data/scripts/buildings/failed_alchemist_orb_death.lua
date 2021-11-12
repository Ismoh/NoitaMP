dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local how_many = 8.0
	local speed = 500
	local angle = math.random(0, 3.13159)
	local angle_inc = 3.1415926535 * 2 / how_many

	for i=1,how_many do
		local vel_x = math.cos(angle) * speed
		local vel_y = 0 - math.sin(angle) * speed
		shoot_projectile( entity_id, "data/entities/projectiles/darkflame.xml", pos_x, pos_y, vel_x, vel_y )
		
		angle = angle + angle_inc
	end
	
	GamePlaySound( "data/audio/Desktop/animals.bank", "animals/failed_alchemist_b_orb/explode", pos_x, pos_y )
end