dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local test = get_flag_name( "u_dheglmticg" )
local test2 = get_flag_name( "bqedcjkvxooa" )

local essence_1 = GameHasFlagRun( "essence_fire" )
local essence_2 = GameHasFlagRun( "essence_air" )
local essence_3 = GameHasFlagRun( "essence_water" )
local essence_4 = GameHasFlagRun( "essence_laser" )

local targets = EntityGetWithTag( test )
local targets2 = EntityGetInRadiusWithTag( x, y, 48, "player_unit" )

if essence_1 and essence_2 and essence_3 and essence_4 and ( #targets > 0 ) and ( #targets2 > 0 ) then
	--EntityLoad("data/entities/items/orbs/orb_13.xml", x, y)
	AddFlagPersistent( test2 )
	CreateItemActionEntity( "TOUCH_GOLD", x - 40, y )
	CreateItemActionEntity( "TOUCH_WATER", x - 24, y )
	CreateItemActionEntity( "TOUCH_OIL", x - 8, y )
	CreateItemActionEntity( "TOUCH_ALCOHOL", x + 8, y )
	CreateItemActionEntity( "TOUCH_BLOOD", x + 24, y )
	CreateItemActionEntity( "TOUCH_SMOKE", x + 40, y )
	
	EntityLoad("data/entities/misc/moon_effect_test.xml", x, y)
	
	GamePrintImportant( "$log_moon_altar_extra", "$logdesc_moon_altar_extra" )
	
	EntityKill( entity_id )
end