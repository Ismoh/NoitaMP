dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local moon_x = 0 + 256
local moon_y = -26112 + 256

local indicator_distance = 32

local dir_x = moon_x - pos_x
local dir_y = moon_y - pos_y

-- sprite positions around character
dir_x,dir_y = vec_normalize(dir_x,dir_y)
local indicator_x = pos_x + dir_x * indicator_distance
local indicator_y = pos_y + dir_y * indicator_distance

GameCreateSpriteForXFrames( "data/particles/radar_moon.png", indicator_x, indicator_y )
