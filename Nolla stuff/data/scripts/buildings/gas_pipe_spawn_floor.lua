dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local search_dist_y = 50
local scatter_x = 8

if not DoesWorldExistAt( pos_x, pos_y + search_dist_y, pos_x, pos_y ) then return end

local floor_found = false
local floor_x = 0
local floor_y = 0
local max = -99999999
-- pick the ray that reaches the lowest
for x = pos_x - scatter_x, pos_x + scatter_x, scatter_x do
	local ray_hit,ray_x,ray_y = RaytracePlatforms(x, pos_y, x, pos_y + search_dist_y )
	if ray_hit and floor_y > max then
		floor_found = true
		floor_x = ray_x
		floor_y = ray_y
		max = ray_y
	end
end

-- spawn & cleanup
if floor_found then
	EntityLoad("data/entities/buildings/biome_modifiers/gas_pipe_floor.xml", floor_x, floor_y)
end
EntityKill(entity_id)

