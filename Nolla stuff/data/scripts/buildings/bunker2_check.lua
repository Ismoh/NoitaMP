dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetInRadiusWithTag( x, y, 200, "player_unit" )

if ( #p > 0 ) and GameHasFlagRun( "fishing_hut_b" ) then
	EntityLoad("data/entities/props/physics_chair_1.xml", x - 16, y + 16)
	EntityLoad("data/entities/items/wands/experimental/experimental_wand_1.xml", x + 64, y - 32)
	
	CreateItemActionEntity( "IF_HALF", x + 24, y - 8)
	CreateItemActionEntity( "IF_HP", x + 38, y - 9)
	CreateItemActionEntity( "IF_PROJECTILE", x + 52, y - 10)
	CreateItemActionEntity( "IF_ENEMY", x + 66, y - 11)
	CreateItemActionEntity( "IF_ELSE", x + 80, y - 12)
	CreateItemActionEntity( "IF_ELSE", x + 94, y - 13)
	CreateItemActionEntity( "IF_END", x + 108, y - 14)
	CreateItemActionEntity( "IF_END", x + 122, y - 15)
	CreateItemActionEntity( "RESET", x + 1162, y - 16)
	
	EntityLoad("data/entities/buildings/workshop_temporary.xml", x + 48, y)
	
	EntityKill( entity_id )
end