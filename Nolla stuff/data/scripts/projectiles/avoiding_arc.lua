dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local vel_x_new = 0
local vel_y_new = 0
local raycast_distance = 20
local strength = 0.3

local raycast_dirs = { {1,0}, {0,-1}, {-1,0}, {0,1} }

for i=1,4 do
	local rdirs = raycast_dirs[i]
	
	local rdir_x = rdirs[1]
	local rdir_y = rdirs[2]
	
	local raycast_success,r_x,r_y = RaytraceSurfacesAndLiquiform( pos_x, pos_y, pos_x + rdir_x * raycast_distance, pos_y + rdir_y * raycast_distance )
	
	if raycast_success then
		--print( tostring(i) .. ": " .. tostring(( math.abs( r_x - pos_x ) )) .. ", " .. tostring(( math.abs( r_y - pos_y ) )) )
		
		vel_x_new = vel_x_new - ( raycast_distance ^ 2 - ( r_x - pos_x ) ^ 2 ) * rdir_x * strength
		vel_y_new = vel_y_new - ( raycast_distance ^ 2 - ( r_y - pos_y ) ^ 2 ) * rdir_y * strength
	end
end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")

	vel_x = vel_x + vel_x_new
	vel_y = vel_y + vel_y_new

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)