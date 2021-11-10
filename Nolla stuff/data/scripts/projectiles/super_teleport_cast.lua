dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local vel_x,vel_y = 0,0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )
end)

local angle = 0 - math.atan2( vel_y, vel_x )

local end_x = pos_x + math.cos(angle) * 120
local end_y = pos_y - math.sin(angle) * 120

local success,ex,ey = RaytracePlatforms( pos_x, pos_y, end_x, end_y )

if ( success == false ) then
	ex = end_x
	ey = end_y
end

EntitySetTransform( entity_id, ex, ey )