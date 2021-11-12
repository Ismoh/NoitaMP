dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

if ( Random( 1, 4 ) > 1 ) then
	local angle = math.rad( Random( 1, 360 ) )
	local vel_x = 0
	local vel_y = 0
	local length = Random( 400, 700 )
	
	if ( Random( 1, 4 ) > 1 ) then
		local targets = EntityGetWithTag( "homing_target" )
		local target_id = 0
		
		if ( #targets > 0 ) then
			local valid_targets = {}
			
			for i,target in ipairs(targets) do
				local tx, ty = EntityGetTransform( target )
				
				local distance = math.abs( ty - y ) + math.abs( tx - x )
				
				if ( distance < 72 ) then
					table.insert( valid_targets, target )
				end
			end
			
			if ( #valid_targets > 0 ) then
				local rnd = Random( 1, #valid_targets )
				
				target_id = valid_targets[rnd]
				
				if ( target_id ~= 0) then
					local tx, ty = EntityGetTransform( target_id )
					angle = 0 - math.atan2( ty - y, tx - x )
				end
			end
		end
	end

	vel_x = math.cos( angle ) * length
	vel_y = 0- math.sin( angle ) * length
	shoot_projectile( entity_id, "data/entities/projectiles/deck/tentacle.xml", x, y, vel_x, vel_y )
end
