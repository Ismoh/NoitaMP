dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local time = GameGetFrameNum()

local rot_speed = 0.003
local twist_speed_1 = 0.02
local twist_amount_1 = 0.6
local twist_speed_2 = 0.012217
local twist_amount_2 = 0.7
local circle_scale_min = -120
local circle_scale_max = 2
local pulse_speed = 0.004

local children = EntityGetAllChildren(entity_id)
if children == nil or #children == 0 then return end

-- rotation along circle + twists
local rot = time * rot_speed
rot = rot + math.sin(time * twist_speed_1) * twist_amount_1 + math.sin(time * twist_speed_2) * twist_amount_2

-- set the fx entity positions
for i,fx_entity in pairs(children) do
	if EntityHasTag(fx_entity, "fx") then
		-- set entity rotation (entities stay in same position)
		local circle_pos = math.pi * 2 / #children * i
		circle_pos = circle_pos + rot
		EntitySetTransform(fx_entity, pos_x, pos_y, rot + circle_pos)

		-- change radius via particle offset
		local comp = EntityGetFirstComponent( fx_entity, "ParticleEmitterComponent")
		if comp ~= nil then
			circle_pos = (math.sin(time * pulse_speed) + 1) * 0.5
			ComponentSetValue2(comp, "offset", 0, lerp(circle_scale_max, circle_scale_min, circle_pos))
		end
	end
end

-- set teleport return target to match origin
if time % 71 == 0 then
	local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

	if( teleport_comp ~= nil ) then
		local teleport_back_x = -2210
		local teleport_back_y = 5223

		-- NOTE: make sure seed matches with snowcastle_cavern.lua init()!
		if ProceduralRandom(0,0) > 0.5 then teleport_back_x = 1707 end

		ComponentSetValue2( teleport_comp, "target", teleport_back_x, teleport_back_y )
	end
end

-- hide teleporter for debug
--EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", false)
