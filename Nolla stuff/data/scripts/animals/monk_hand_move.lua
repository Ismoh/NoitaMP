dofile_once("data/scripts/lib/utilities.lua")

local lerp_amount = 0.9
local offset_x = 15
local bob_h = 8
local bob_w = 20
local bob_speed_y = 0.023
local bob_speed_x = 0.01121
local rotate_amount = math.pi * 0.05
local rotate_speed = 0.093

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

if pos_x == 0 and pos_y == 0 then
	pos_x, pos_y = EntityGetTransform(EntityGetParent(entity_id))
end


-- ghost continously lerps towards a target that floats around the parent
local target_x, target_y = EntityGetTransform(EntityGetParent(entity_id))
local body_x, body_y = target_x, target_y -- store for drawing the arms
if target_x == nil then return end
target_y = target_y - 20

-- handedness from variable storage
local comp = get_variable_storage_component(entity_id, "is_right")
is_right = ComponentGetValue2(comp, "value_bool")
if not is_right then offset_x = -offset_x end

target_x = target_x + offset_x

local time = GameGetFrameNum()
local r = ProceduralRandomf(entity_id, 0, -1, 1)

-- randomize times and speeds slightly so that multiple fists don't fly identically
time = time + r * 10000
bob_speed_y = bob_speed_y + (r * bob_speed_y * 0.1)
bob_speed_x = bob_speed_x + (r * bob_speed_x * 0.1)
lerp_amount = lerp_amount - (r * lerp_amount * 0.01)

-- bob
target_y = target_y + math.sin(time * bob_speed_y) * bob_h
target_x = target_x + math.sin(time * bob_speed_x) * bob_w

-- rotate
rotate_amount = rotate_amount * math.sin(time * rotate_speed)

-- move towards target
pos_x,pos_y = vec_lerp(pos_x, pos_y, target_x, target_y, lerp_amount)
EntitySetTransform( entity_id, pos_x, pos_y, rotate_amount, 1, 1)

-- "arms" particle fx position.
-- sets the fx entity position to between hand and body and wobbles it!
do
	local children = EntityGetAllChildren(entity_id)
	if children == nil or #children == 0 then return end

	local x = pos_x
	local y = pos_y
	
	-- "shoulder" position
	body_y = body_y - 10
	offset_x = 4
	if not is_right then offset_x = -offset_x end
	body_x = body_x + offset_x

	for _,fx_entity in pairs(children) do
		if EntityHasTag(fx_entity, "arm_fx") then

			-- pick a position between body and hand. 0 is body, 1 is hand
			local pos = ProceduralRandomf(time, fx_entity)

			-- figure out how much to distort the position
			-- middle distorts most so we want a range of 0 to 1 to 0
			local amount = pos * 2 - 1 -- 0...1 -> -1...0...1
			amount = -math.abs(amount) -- -1...0...-1
			amount = amount + 1 -- 0...1...0

			local distort_x = math.sin((x + time) * 0.03) * 8 * amount
			local distort_y = math.sin((y + time) * 0.05734 + 40) * 4 * amount

			x, y = vec_lerp(body_x, body_y, x, y, pos)
			x = x + distort_x
			y = y + distort_y
			--GameCreateParticle("spark_red_bright", x, y, 1, 0, 0, true)
			EntitySetTransform(fx_entity, x, y)
		end
	end
end


