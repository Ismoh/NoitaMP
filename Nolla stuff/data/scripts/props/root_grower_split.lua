dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local r = ProceduralRandomf(pos_x, pos_y + GameGetFrameNum())
if r < 0.005 then
	-- spawn another big branch (rare)
	-- offset randomly for more efficient initial spread
	pos_x = pos_x + ProceduralRandomf(pos_x-12, pos_y, -3, 3)
	pos_y = pos_y + ProceduralRandomf(pos_x, pos_y+54, -3, 3)
	EntityLoad( "data/entities/props/root_grower.xml", pos_x, pos_y )
	return
elseif r < 0.2 then
	-- regular small branch
	pos_x = pos_x + ProceduralRandomf(pos_x-7, pos_y, -3, 3)
	pos_y = pos_y + ProceduralRandomf(pos_x, pos_y, -3, 3)
	EntityLoad( "data/entities/props/root_grower_branch.xml", pos_x, pos_y )
	return
elseif r < 0.5 then
	-- leaf sprite
	local e = EntityLoad( "data/entities/props/root_grower_leaf.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, ProceduralRandomf(pos_x, pos_y, math.pi * 2))
end