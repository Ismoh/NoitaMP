dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
local radius = 160

if EntityHasTag( entity_id, "essence_to_power_target" ) then
	EntityRemoveTag( entity_id, "essence_to_power_target" )
end

if EntityHasTag( root_id, "essence_to_power_target" ) then
	EntityRemoveTag( root_id, "essence_to_power_target" )
end