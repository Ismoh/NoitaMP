dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 240

local c_id,c_x,c_y = EntityGetClosestWormAttractor( x, y )
local f_id,f_x,f_y = EntityGetClosestWormDetractor( x, y )

edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( vcomp, "mVelocity")
	
	local dist = math.abs( vel_y ) + math.abs( vel_x )
	
	if ( dist > 450 ) then
		vel_x = vel_x * 0.86
		vel_y = vel_y * 0.86
	end
	
	if ( f_id ~= nil ) and ( f_x ~= nil ) and ( f_y ~= nil ) then
		dist = get_distance2( x, y, f_x, f_y )
		
		if ( dist < radius ) then
			local tx,ty = f_x,f_y
			
			if ( tx >= x ) then
				vel_x = vel_x - ( 200 - math.abs( tx - x ) ) * 0.05
			else
				vel_x = vel_x + ( 200 - math.abs( tx - x ) ) * 0.05
			end
			
			if ( ty >= y ) then
				vel_y = vel_y - ( 200 - math.abs( ty - y ) ) * 0.05
			else
				vel_y = vel_y + ( 200 - math.abs( ty - y ) ) * 0.05
			end
		end
	end
	
	if ( c_id ~= nil ) and ( c_x ~= nil ) and ( c_y ~= nil ) then
		dist = get_distance2( x, y, c_x, c_y )
		
		if ( dist < radius ) then
			local tx,ty = c_x,c_y
			
			if ( tx >= x ) then
				vel_x = vel_x + ( math.abs( tx - x ) ) * 0.05
			else
				vel_x = vel_x - ( math.abs( tx - x ) ) * 0.05
			end
			
			if ( ty >= y ) then
				vel_y = vel_y + ( math.abs( ty - y ) ) * 0.05
			else
				vel_y = vel_y - ( math.abs( ty - y ) ) * 0.05
			end
		end
	end
	
	ComponentSetValueVector2( vcomp, "mVelocity", vel_x, vel_y )
end)