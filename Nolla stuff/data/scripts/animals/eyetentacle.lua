dofile_once("data/scripts/lib/utilities.lua")

local pos_x, pos_y = EntityGetTransform( GetUpdatedEntityID() )

local vel_x = 200
local vel_y = 200

local entity_id = EntityLoad( "data/entities/projectiles/tentacle.xml", pos_x, pos_y )
local herd_id   = get_herd_id( entity_id )

edit_component( entity_id, "ProjectileComponent", function(comp,vars)
	vars.mWhoShot       = entity_id
	vars.mShooterHerdId = herd_id
end)

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
end)

return entity_id