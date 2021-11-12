dofile_once("data/scripts/lib/utilities.lua")

local entity_id   		= GetUpdatedEntityID()
local pos_x,pos_y,rot	= EntityGetTransform( entity_id )

-- updates entity based on how many statues destroyed
-- NOTE: damage, stains etc don't carry over when statue changes state
if GameHasFlagRun("statue_hands_destroyed_3") then
	-- 3 statues destroyed. remove remaining statues.
	--print("removing statue")
	EntityLoad("data/entities/particles/teleportation_source.xml", pos_x, pos_y)
	EntityKill(entity_id)
elseif EntityHasTag(entity_id, "statue_hand_2") and GameHasFlagRun("statue_hands_destroyed_2") then
	-- 2 statues destroyed, convert to statue_hand_3
	--print("transforming to 3")
	local e = EntityLoad("data/entities/buildings/statue_hand_3.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, rot)
	EntityLoad("data/entities/particles/teleportation_source.xml", pos_x, pos_y)
	EntityKill(entity_id)
elseif EntityHasTag(entity_id, "statue_hand_1") and GameHasFlagRun("statue_hands_destroyed_1")
and EntityHasTag(entity_id, "statue_hand_3") == false and EntityHasTag(entity_id, "statue_hand_2") == false then
	-- 1 statue destroyed, convert to statue_hand_2
	--print("transforming to 2")
	local e = EntityLoad("data/entities/buildings/statue_hand_2.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, rot)
	EntityLoad("data/entities/particles/teleportation_source.xml", pos_x, pos_y)
	EntityKill(entity_id)
end

