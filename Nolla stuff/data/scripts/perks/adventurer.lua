dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once( "data/scripts/game_helpers.lua" )

local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( player_id )

local currbiome = BiomeMapGetName( x, y )
local flag = "adventurer_" .. tostring(currbiome) .. "_visited"

if ( GameHasFlagRun( flag ) == false ) then
	local heal = 60
	heal = heal / 25
	heal_entity( player_id, heal )
	
	GameAddFlagRun( flag )
	GamePrint( "$log_adventurer" )
end