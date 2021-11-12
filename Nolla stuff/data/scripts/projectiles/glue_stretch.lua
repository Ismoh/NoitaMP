dofile_once("data/scripts/lib/utilities.lua")

local initial_break_distance = 100
local final_break_distance = 50
local aging_speed = 0.25
local sprite_width = 16 -- for accurate scaling (visible pixels only, no margins)

local entity_id = GetUpdatedEntityID()

-- get anchor entities' positions
local v = {} -- x1, y1, x2, y2
local children = EntityGetAllChildren(entity_id)
if children ~= nil and #children > 0 then
	for _,anchor in ipairs(children) do
		if EntityHasTag(anchor, "glue_anchor") then
			local x,y = EntityGetTransform(anchor)
			v[#v+1] = x
			v[#v+1] = y
		end
	end
end

if #v < 4 then
	-- anchor missing
	--print("anchors missing " .. #v)
	EntityKill(entity_id)
	return
end

-- angle between anchors for aligning sprite
local dir_x = v[1] - v[3]
local dir_y = v[2] - v[4]
local angle = math.atan(dir_y / dir_x)
local dist = get_magnitude(dir_x, dir_y)

-- break if anchors are too far apart
local break_dist = initial_break_distance
local t = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
break_dist = break_dist - t * aging_speed -- glue gets weaker over time
break_dist = math.max(break_dist, final_break_distance)
if dist > break_dist then
	EntityKill(entity_id)
	return
end

-- position & stretch sprite between anchors
local pos_x = (v[1] + v[3]) * 0.5
local pos_y = (v[2] + v[4]) * 0.5
local scale_x = dist / sprite_width
local scale_y = map(dist, 0, break_dist, 1, 0.5)
EntitySetTransform(entity_id, pos_x, pos_y, angle, scale_x, scale_y)

local alpha = map(dist, 0, break_dist, 1, 0.3)
component_write( EntityGetFirstComponent(entity_id, "SpriteComponent" ), { alpha = alpha } )
