dofile_once("data/scripts/lib/utilities.lua")

local offset_y = -16
local follow_amount = 0.2
local bob_amount = 1.5
local bob_speed = 0.05
local roll_amount = 0.08
local roll_speed = 0.08

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(entity_id)
local t = GameGetFrameNum() - entity_id -- unique timing for this entity

-- target pos
local target_x, target_y = EntityGetTransform(root_id)
target_y = target_y + offset_y

-- bob
target_y = target_y + math.sin(t * bob_speed) * bob_amount

-- roll
local rot = math.sin(t * roll_speed) * roll_amount

-- move towards target
x,y = vec_lerp(target_x, target_y, x, y, follow_amount)
EntitySetTransform(entity_id, x, y, rot)
