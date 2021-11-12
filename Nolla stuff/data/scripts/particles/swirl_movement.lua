dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

if is_in_camera_bounds(x, y, 16) then
	edit_component2( entity_id, "VelocityComponent", function(comp,vars)
		local vx,vy = ComponentGetValue2( comp, "mVelocity")
		local steer_limit = math.pi * 0.2
		local steer_min = 0.1
		local steer_max = 0.15
		local steer = ProceduralRandomf(entity_id, 0, steer_min, steer_max)

		local wobble_size = 0.2
		local wobble_amp = 0.1
		local wobble = math.sin((x + entity_id)*wobble_size) * wobble_amp + math.sin(y*wobble_size) * wobble_amp
		steer = steer + wobble

		if entity_id%2 == 0 then steer = -steer end
		
		vx, vy = vec_rotate(vx, vy, steer)
		ComponentSetValue2( comp, "mVelocity", vx, vy)
	end)
end