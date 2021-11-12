dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	if( entity_who_caused == entity_id ) then return end
	if script_wait_frames( entity_id, 2 ) then  return  end
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	local angle_inc = 0
	local angle_inc_set = false
	
	local length = 400
	
	if ( entity_who_caused ~= nil ) and ( entity_who_caused ~= NULL_ENTITY ) then
		local ex, ey = EntityGetTransform( entity_who_caused )
		
		if ( ex ~= nil ) and ( ey ~= nil ) then
			angle_inc = 0 - math.atan2( ( ey - y ), ( ex - x ) )
			angle_inc_set = true
		end
	end
	
	for i=1,2 do
		local angle = 0
		if angle_inc_set then
			angle = angle_inc + Random( -5, 5 ) * 0.01
		else
			angle = math.rad( Random( 1, 360 ) )
		end
		
		local vel_x = math.cos( angle ) * length
		local vel_y = 0- math.sin( angle ) * length

		shoot_projectile( entity_id, "data/entities/projectiles/wraith_glowing_laser.xml", x, y, vel_x, vel_y )
	end
	
	GameEntityPlaySound( entity_id, "shoot" )
end
