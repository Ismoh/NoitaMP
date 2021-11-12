dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local distance_to_surface = ProceduralRandomf(pos_x, entity_id, 8, 30)
local speed = 0.04

local found_normal,nx,ny,dist = GetSurfaceNormal( pos_x, pos_y, distance_to_surface, 12 )
if found_normal then
	local dx = -nx * dist
	local dy = -ny * dist
	
	-- add sine wobble
	local t = GameGetFrameNum()
	t = t + entity_id * 0.01
	local wobble = math.sin(t * 0.2) * 0.5
	dx, dy = vec_rotate(dx, dy, wobble)

	dx = dx * speed
	dy = dy * speed

	EntitySetTransform(entity_id, pos_x + dx, pos_y + dy)
end