dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_entity = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( entity_id )

local effects = { "effect_confusion_ui", "effect_drunk_ui", "effect_hearty", "effect_movement_slower_ui", "effect_twitchy", "effect_weaken", "effect_wither", "effect_homing_shooter" }

SetRandomSeed( GameGetFrameNum(), entity_id )

local rnd = Random( 1, #effects )

local eid = EntityLoad( "data/entities/misc/" .. effects[rnd] .. ".xml" )
EntityAddChild( root_entity, eid )

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", x, y )
GamePrint( "$boss_wizard_" .. tostring(rnd) )

EntityKill( entity_id )