dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local t = GameGetFrameNum()
local scale = math.sin(t * 0.1) * 0.75 + math.sin(t * 0.7256) * 0.25
local radius = map(scale, -1, 1, 5, 20)
scale = radius / 48 -- depends on sprite size

-- particle ring radius
local comp = EntityGetFirstComponent(entity_id, "ParticleEmitterComponent", "modulate_radius")
ComponentSetValue2(comp, "area_circle_radius", radius, radius)

-- scale sprite
EntitySetTransform(entity_id, pos_x, pos_y, 0, scale, scale)

