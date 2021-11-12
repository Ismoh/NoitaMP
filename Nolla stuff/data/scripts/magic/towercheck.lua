dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local test2 = EntityGetInRadiusWithTag( x, y, 16, "small_friend" )
local test3 = EntityGetInRadiusWithTag( x, y, 16, "player_unit" )
local test4 = EntityGetInRadiusWithTag( x, y, 16, "big_friend" )
	
if ( #test2 > 0 ) then
	CreateItemActionEntity( "NUKE_GIGA", x, y )
	AddFlagPersistent( "card_unlocked_nukegiga" )
	EntityLoad( "data/entities/projectiles/deck/nuke.xml", x, y )
	AddFlagPersistent( "final_secret_orb" )
	
	EntityKill( entity_id )
elseif ( #test4 > 0 ) then
	CreateItemActionEntity( "BOMB_HOLY_GIGA", x, y )
	AddFlagPersistent( "card_unlocked_bomb_holy_giga" )
	EntityLoad( "data/entities/projectiles/deck/nuke.xml", x, y )
	AddFlagPersistent( "final_secret_orb2" )
	
	EntityKill( entity_id )
elseif GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) and ( #test3 > 0 ) then
	CreateItemActionEntity( "DIVIDE_10", x, y )
	AddFlagPersistent( "card_unlocked_divide" )
	
	EntityKill( entity_id )
elseif ( #test3 > 0 ) then
	CreateItemActionEntity( "AIR_BULLET", x, y )
	
	EntityKill( entity_id )
end