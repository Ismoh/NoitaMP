dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

-- go to east biomes
pos_x = 36030

-- set height to current biome start point. Will be wrong in side biomes and other locations
if pos_y < 1200 then
	-- coal mine or surface
	pos_x = pos_x + 780
	pos_y = 0
elseif pos_y < 2732 then
	-- excavationsite
	pos_y = 1525
elseif pos_y < 4790 then
	-- snowcave
	pos_y = 3070
elseif pos_y < 6320 then
	-- snowcastle
	pos_y = 5118
elseif pos_y < 9368 then
	-- jungle
	pos_y = 6644
elseif pos_y < 10414 then
	-- vault
	pos_y = 8704
else
	-- deeper. go to beginning of crypt
	pos_y = 10740
end

ComponentSetValue2(teleport_comp, "target", pos_x, pos_y)

-- make sure teleporter doesn't work before it's initialized here
EntitySetComponentsWithTagEnabled( entity_id, "enabled_by_script", true )
