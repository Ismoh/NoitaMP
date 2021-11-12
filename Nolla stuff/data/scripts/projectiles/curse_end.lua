dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity( entity_id )

local x,y = EntityGetTransform( entity_id )
local curseflag = EntityHasTag( entity_id, "effect_CURSE" )

if curseflag then
	EntityRemoveTag( entity_id, "effect_CURSE" )
end