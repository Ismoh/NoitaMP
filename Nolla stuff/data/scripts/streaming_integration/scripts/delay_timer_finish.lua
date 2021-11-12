dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/streaming_integration/event_list.lua")

local entity_id = GetUpdatedEntityID()
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

local event_id = ""

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "event" ) then
			event_id = ComponentGetValue2( v, "value_string" )
			break
		end
	end
end

if ( string.len( event_id ) > 0 ) then
	for i,data in ipairs( streaming_events ) do
		if ( data.id == event_id ) then
			if ( data.action_delayed ~= nil ) then
				data.action_delayed( data )
			end
		end
	end
end