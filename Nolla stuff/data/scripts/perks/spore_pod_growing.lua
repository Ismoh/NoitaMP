dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
SetRandomSeed( x * entity_id, y + GameGetFrameNum() )

shoot_projectile_from_projectile( entity_id, "data/entities/misc/perks/spore_pod_growing.xml", x, y, 0, 0 )