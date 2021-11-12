dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local eid = EntityLoad( "data/entities/animals/special/minipit.xml", x, y )
EntityLoad( "data/entities/particles/poof_red_sparse.xml", x, y )
EntityAddComponent( eid, "VariableStorageComponent", 
{ 
	_tags="no_gold_drop",
} )

EntityKill( entity_id )