dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local vel_x,vel_y = 0,0
local owner_id = 0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( comp ~= nil ) then
	owner_id = ComponentGetValue2( comp, "mWhoShot" )
end

if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) then
	local ox, oy = EntityGetTransform( owner_id )
	
	if ( ox ~= nil ) and ( oy ~= nil ) then
		local dir = get_direction( ox, oy, x, y )
		local dist = get_distance( x, y, ox, oy )
		
		vel_x = vel_x + math.cos( dir ) * dist * 0.33
		vel_y = vel_y - math.sin( dir ) * dist * 0.33

		edit_component( entity_id, "VelocityComponent", function(comp2,vars)
			ComponentSetValueVector2( comp2, "mVelocity", vel_x, vel_y)
		end)
	end
end