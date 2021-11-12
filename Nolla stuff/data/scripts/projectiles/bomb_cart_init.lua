dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local force_x = 600
local force_y = -200
local dir = 0

-- propel away from shooter
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp == nil then return end
local who_shot = ComponentGetValue2( comp, "mWhoShot")
if( who_shot == nil or who_shot == 0 ) then return end

dir = sign(x - EntityGetTransform(who_shot))

-- store initial direction for bomb_cart.lua
local is_reversed = ComponentSetValue2(get_variable_storage_component(entity_id, "reverse"), "value_bool", dir < 0)

force_x = force_x * dir

PhysicsApplyForce(entity_id, force_x, force_y)


