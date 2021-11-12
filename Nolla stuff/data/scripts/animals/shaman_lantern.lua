dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y,angle = EntityGetTransform(entity_id)
local vx,vy = GameGetVelocityCompVelocity( EntityGetRootEntity(entity_id ))

local momentum = 0.9
local range = 2

local swing = 0
local storage = get_variable_storage_component(entity_id, "swing")
component_readwrite(storage, { value_int = 0 }, function(comp)
   swing = comp.value_int
   swing = swing + math.floor(math.abs(vx * 100) + math.abs(vy * 100))
   swing = swing * momentum
   swing = clamp(swing, -1000, 1000)
   comp.value_int = swing
end)

swing = swing * 0.001
angle = math.sin(GameGetFrameNum() * 0.15 - swing) * range * swing

EntitySetTransform(entity_id,x,y,angle)

