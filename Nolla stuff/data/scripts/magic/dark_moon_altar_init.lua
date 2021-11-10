dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if HasFlagPersistent( "darkmoon_is_darksun" ) then
	EntityLoad( "data/entities/items/pickup/sun/newsun_dark.xml", x, y )
end