dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, a = EntityGetTransform( entity_id )

local angle = ( GameGetFrameNum() - 352 ) * 0.0081
local angle2 = ( GameGetFrameNum() + 212 ) * 0.006

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")

	vel_x = math.cos( angle ) * 25
	vel_y = math.cos( angle2 ) * 15

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)