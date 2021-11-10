dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
	EntityLoad( "data/entities/misc/convert_radioactive_with_delay.xml", x,y )
end