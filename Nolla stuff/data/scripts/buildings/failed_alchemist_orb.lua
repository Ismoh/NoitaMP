dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local alchemist_id = EntityLoad( "data/entities/animals/failed_alchemist_b.xml", pos_x, pos_y )
GamePlaySound( "data/audio/Desktop/animals.bank", "animals/statue/appear", pos_x, pos_y )

EntityAddComponent( alchemist_id, "VariableStorageComponent", 
	{ 
		_tags="no_gold_drop",
	} )
	
EntityKill( entity_id )