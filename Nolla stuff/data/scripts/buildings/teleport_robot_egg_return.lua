dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/biomes/summon_portal_util.lua")

-- this is called every x frames
local entity_id    = GetUpdatedEntityID()

local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

-- sets teleporter target to original location
local portal_x, portal_y = get_portal_position()
if( teleport_comp ~= nil ) then
	ComponentSetValue2( teleport_comp, "target", portal_x, portal_y )
end
