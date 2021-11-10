dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local comp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

if ( comp ~= nil ) then
	edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
		local vel_x,vel_y = ComponentGetValueVector2( vcomp, "mVelocity")
		
		if ( vel_x > 0 ) then
			ComponentSetValue2( comp, "special_scale_x", 1 )
		elseif ( vel_x < 0 ) then
			ComponentSetValue2( comp, "special_scale_x", -1 )
		end
	end)
end