dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)
local _,x,y = RaytraceSurfaces(pos_x, pos_y, pos_x, pos_y - 40)
EntityApplyTransform(entity_id, x, y)
