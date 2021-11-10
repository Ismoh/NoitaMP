dofile_once("data/scripts/lib/utilities.lua")

local distance_threshold = 38

-- see if anyone is nearby and turn shield components on/off
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

-- offset closer to middle of force field
y = y - 10
x = x + 5

local dist = 99999999

-- probe closest enemy
local enemy = EntityGetClosestWithTag(x, y, "enemy")
if enemy ~= 0 then
	local x2,y2 = EntityGetTransform(enemy)
	dist = get_distance(x,y,x2,y2)
end

-- probe player
local player = EntityGetClosestWithTag(x, y, "player_unit")
if player ~= 0 then
	local x2,y2 = EntityGetTransform(player)
	dist = math.min(dist, get_distance(x,y,x2,y2))
end

local enable = dist > distance_threshold

-- enable/disable light
--local sprite = EntityGetFirstComponent( entity_id, "SpriteComponent")
--EntitySetComponentIsEnabled(entity_id, sprite, enable)

edit_all_components( entity_id, "SpriteComponent", function(comp,vars)
		if enable then vars.visible = 1
		else vars.visible = 0 end
	end)

-- enable/disable components in child entities
local children = EntityGetAllChildren( entity_id)
if children == nil then return end

for _,v in ipairs(children) do
	if EntityGetTags(v) == "shield_entity" then
		EntitySetComponentsWithTagEnabled( v, "enabled_while_shielding", enable )
	end
end

