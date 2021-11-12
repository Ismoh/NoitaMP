dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, a = EntityGetTransform( entity_id )

local arc = -0.15
local angle = ( GameGetFrameNum() + 100 ) * 0.01
a = math.cos( angle ) * arc

EntitySetTransform( entity_id, x, y, a )