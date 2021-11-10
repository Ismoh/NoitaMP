-- this is called every x frames
local entity_id    = GetUpdatedEntityID()

local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

local teleport_back_x = 190
local teleport_back_y = 3080

-- get the defaults from teleport_comp(s)
if( teleport_comp ~= nil ) then
	teleport_back_x, teleport_back_y = ComponentGetValue2( teleport_comp, "target" )
	-- print( "teleport std pos:" .. teleport_back_x .. ", " .. teleport_back_y )
end


teleport_back_x = tonumber( GlobalsGetValue( "TELEPORT_SNOWCAVE_BURIED_EYE_POS_X", teleport_back_x ) )
teleport_back_y = tonumber( GlobalsGetValue( "TELEPORT_SNOWCAVE_BURIED_EYE_POS_Y", teleport_back_y ) )

if( teleport_comp ~= nil ) then
	ComponentSetValue2( teleport_comp, "target", teleport_back_x, teleport_back_y )
	-- ComponentGetValue2( teleport_comp, "target.y", teleport_back_y )
end