dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
--local t = GameGetFrameNum()

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 90, "gate_monster")) do
	if id ~= entity_id then
		-- repel other gate monsters to prevent them from sticking together
		local x,y = EntityGetTransform(id)
		x = x- pos_x
		y = y- pos_y
		x, y = vec_normalize(x, y)
		x, y = vec_mult(x, y, 800)
		PhysicsApplyForce(id, x, y)
	end
end
