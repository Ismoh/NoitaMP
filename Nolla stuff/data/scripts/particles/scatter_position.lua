dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local max_distance = ProceduralRandomf(x, entity_id, 4, 16)
local random_rot = 0.4

local pos_x, pos_y = EntityGetTransform(entity_id)

if is_in_camera_bounds(pos_x, pos_y, 32) then
	-- get direction from velocity
	local dx,dy = GameGetVelocityCompVelocity(entity_id)
	dx,dy = vec_normalize(dx,dy)
	dx,dy = vec_mult(dx,dy,max_distance)
	-- deviate from velocity's direction
	dx,dy = vec_rotate(dx,dy,ProceduralRandomf(entity_id, y, -random_rot, random_rot))

	local _,x,y = RaytraceSurfaces(pos_x, pos_y, pos_x+dx, pos_y+dy)

	EntityApplyTransform(entity_id, x, y)

	-- enable trail after transform to avoid drawing trail from origin
	local comp = EntityGetFirstComponent(entity_id, "ParticleEmitterComponent")
	if( comp ~= nil ) then
		ComponentSetValue2(comp, "mExPosition", x, y)
	end
end