dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local dir_x = 8
local dir_y = 0
dir_x, dir_y = vec_rotate( dir_x, dir_y, ProceduralRandomf( x, GameGetFrameNum(), 0, math.pi * 2 ) )
EntityLoad( "data/entities/misc/electricity_weak.xml", x + dir_x, y + dir_y )

-- debug
--GameCreateSpriteForXFrames( "data/particles/radar_enemy_strong.png",  x + dir_x, y + dir_y, true, 0, 0, 30 )
--GameCreateSpriteForXFrames( "data/particles/radar_enemy_medium.png",  x, y, true, 0, 0, 30 )