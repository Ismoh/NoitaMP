dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if HasFlagPersistent( "moon_is_sun" ) then
	EntityLoad( "data/entities/items/pickup/sun/newsun.xml", x, y )
end