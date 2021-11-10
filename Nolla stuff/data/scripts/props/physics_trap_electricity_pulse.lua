dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local dir_x = 16
local dir_y = 0

local dx,dy = 0,0

for i=1,4 do
	dx, dy = vec_rotate( dir_x, dir_y, math.pi * 0.5 * ( i - 1 ) )
	EntityLoad( "data/entities/misc/electricity_medium.xml", x + dx, y + dy )
end