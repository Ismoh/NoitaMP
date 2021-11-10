dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local ox,oy,spd,rspd

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		
		if ( n == "origin_x" ) then
			ox = ComponentGetValue2( v, "value_float" )
		elseif ( n == "origin_y" ) then
			oy = ComponentGetValue2( v, "value_float" )
		elseif ( n == "orbit_speed" ) then
			spd = ComponentGetValue2( v, "value_int" )
		elseif ( n == "rot_speed" ) then
			rspd = ComponentGetValue2( v, "value_float" )
		end
	end
end

if ( ox ~= nil ) and ( oy ~= nil ) and ( spd ~= nil ) and ( rspd ~= nil ) then
	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
		
		local dir = get_direction( x, y, ox, oy )
		spd = math.rad( spd )
		
		vel_x = math.cos( dir + spd ) * rspd
		vel_y = 0 - math.sin( dir + spd ) * rspd

		ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
	end)
end