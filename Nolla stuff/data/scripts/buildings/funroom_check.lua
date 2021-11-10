dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 24

local targets = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )
local targets2 = EntityGetInRadiusWithTag( x, y, radius, "tripping_extreme" )

if ( #targets > 0 ) and ( #targets2 > 0 ) then
	-- GameTriggerMusicEvent( "music/oneshot/tripping_balls_02", false, x, y )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/fungal_effect/create", x, y )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_trip_secret2" ), CellFactory_GetType( "templebrick_golden_static" ) )
	ConvertMaterialEverywhere( CellFactory_GetType( "rock_static_trip_secret" ), CellFactory_GetType( "material_rainbow" ) )
	GameScreenshake( 80, x, y )
	
	EntityKill( entity_id )
end