dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

-- reads time from VariableStorageComponent. Time updated from racing_cart_checkpoint.lua

local sprite_big = "data/particles/radar_enemy_strong.png"
local sprite_medium = "data/particles/radar_enemy_medium.png"
local sprite_small = "data/particles/radar_enemy_faint.png"

local entity_id = GetUpdatedEntityID()
local center_x, center_y = EntityGetTransform( entity_id )

local function draw_ring(value, radius, sprite)
	local x = 0
	local y = -radius
	local theta = math.pi * 2 / 9
	for i=1,10 do
		if value >= i then
			GameCreateSpriteForXFrames(sprite, center_x + x, center_y + y)
		end
		x,y = vec_rotate(x, y, theta)
	end
end

local frames = ComponentGetValue2(EntityGetFirstComponent(entity_id, "VariableStorageComponent" ), "value_int")
-- clamp time display to maximum possible
local frames_max = 600 * 3 + 60 * 9 + 6 * 9.99
frames = math.min(frames, frames_max)

local seconds = frames / 60
local tenths = (seconds % 1) * 10

-- draw
draw_ring(seconds % 10, 6, sprite_medium)
draw_ring(tenths, 10, sprite_small)
if seconds >= 30 then
	GameCreateSpriteForXFrames(sprite_big, center_x, center_y)
elseif seconds >= 20 then
	GameCreateSpriteForXFrames(sprite_medium, center_x, center_y)
elseif seconds >= 10 then
	GameCreateSpriteForXFrames(sprite_small, center_x, center_y)
end
