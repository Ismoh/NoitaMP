dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

-- biome start positions
local positions = {
	{970, 0},
	{190, 1525},
	{190, 3070},
	{190, 5118},
	{190, 6644},
	{190, 8704},
	{190, 10740},
}

SetRandomSeed(pos_x, pos_y)
local pos = random_from_array(positions)

ComponentSetValue2(teleport_comp, "target", pos[1], pos[2])

-- make sure teleporter doesn't work before it's initialized here
EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_script", true )
