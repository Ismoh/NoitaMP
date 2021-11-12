dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/orb_distant_monster/create", pos_x, pos_y )
GameScreenshake( 100 )

EntityKill( entity_id )