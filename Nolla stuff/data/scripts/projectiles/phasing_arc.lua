dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local distance = 28

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end
local vel_x,vel_y = ComponentGetValueVector2( velocity_comp, "mVelocity")

local dir = 0 - math.atan2( vel_y, vel_x )

local ox = math.cos( dir ) * distance
local oy = 0 - math.sin( dir ) * distance

EntitySetTransform( entity_id, x + ox, y + oy )