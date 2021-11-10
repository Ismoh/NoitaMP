dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local search_dist_y = 200
local scatter_x = 10

if not DoesWorldExistAt( pos_x, pos_y - search_dist_y, pos_x, pos_y ) then return end

local ceiling_found = false
local ceiling_x = 0
local ceiling_y = 0
local min_y = 99999999
-- pick the ray that reaches the highest
for x = pos_x - scatter_x, pos_x + scatter_x, scatter_x do
	local ray_hit,ray_x,ray_y = RaytracePlatforms(x, pos_y, x, pos_y - search_dist_y )
	if ray_hit and ceiling_y < min_y then
		ceiling_found = true
		ceiling_x = ray_x
		ceiling_y = ray_y
		min_y = ray_y
	end
end

-- spawn & cleanup
if ceiling_found then
	EntityLoad("data/entities/buildings/biome_modifiers/drain_pipe.xml", ceiling_x, ceiling_y + 4)
end
EntityKill(entity_id)

