dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

PhysicsApplyTorque(entity_id, -rot * 20)
PhysicsApplyForce(entity_id, 0, -30)
