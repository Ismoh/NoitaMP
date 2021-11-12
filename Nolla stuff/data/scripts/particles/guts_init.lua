dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local fx = ProceduralRandomf(entity_id + x, y, -2, 2)
local fy = ProceduralRandomf(x + y, entity_id * 1.532, -25, 0)

PhysicsApplyForce(entity_id, fx, fy)
PhysicsApplyTorque(entity_id, ProceduralRandomf(x + y, entity_id, -10, 10))
