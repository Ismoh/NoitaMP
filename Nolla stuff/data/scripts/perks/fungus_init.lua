dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if EntityHasTag( entity_id, "homing_target" ) then
	EntityRemoveTag( entity_id, "homing_target" )
end

if EntityHasTag( entity_id, "enemy" ) then
	EntityRemoveTag( entity_id, "enemy" )
end