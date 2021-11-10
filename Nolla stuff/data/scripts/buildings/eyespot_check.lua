dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 64

local targets = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )
local targets2 = EntityGetInRadiusWithTag( x, y, radius, "tripping_extreme" )
local found = false

if ( #targets > 0 ) and ( #targets2 > 0 ) then
	local filename = "data/entities/items/books/"
	
	local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "eyespot_object" )
	
	if ( comp ~= nil ) then
		local file = ComponentGetValue2( comp, "value_string" )
		filename = filename .. file .. ".xml"
		
		GameTriggerMusicEvent( "music/oneshot/tripping_balls_02", false, x, y )
		EntityLoad( filename, x, y )
		EntityKill( entity_id )
	end
end