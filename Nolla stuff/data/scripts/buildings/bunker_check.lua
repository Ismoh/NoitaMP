dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetInRadiusWithTag( x, y, 200, "player_unit" )

if ( #p > 0 ) and GameHasFlagRun( "fishing_hut_a" ) then
	EntityLoad("data/entities/props/physics_table.xml", x, y + 16)
	EntityLoad("data/entities/animals/failed_alchemist.xml", x - 24, y)
	EntityLoad("data/entities/items/wands/experimental/experimental_wand_2.xml", x + 64, y - 32)
	
	CreateItemActionEntity( "COLOUR_RED", x + 32, y - 8)
	CreateItemActionEntity( "COLOUR_ORANGE", x + 44, y - 9)
	CreateItemActionEntity( "COLOUR_YELLOW", x + 56, y - 10)
	CreateItemActionEntity( "COLOUR_GREEN", x + 68, y - 11)
	CreateItemActionEntity( "COLOUR_BLUE", x + 80, y - 12)
	CreateItemActionEntity( "COLOUR_PURPLE", x + 92, y - 13)
	CreateItemActionEntity( "COLOUR_RAINBOW", x + 104, y - 14)
	CreateItemActionEntity( "COLOUR_INVIS", x + 116, y - 15)
	
	EntityLoad("data/entities/buildings/workshop_temporary.xml", x + 48, y)
	
	EntityKill( entity_id )
end