dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )
local radius = 160

if ( EntityHasTag( root_id, "spells_to_power_target" ) == false ) then
	EntityAddTag( root_id, "spells_to_power_target" )
end