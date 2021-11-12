dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 12

local projectiles = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
local comp = EntityGetFirstComponent( entity_id, "LuaComponent", "duck_timer" )

if ( comp ~= nil ) then
	ComponentSetValue2( comp, "execute_every_n_frame", 1 )
end

if ( #projectiles > 0 ) then
	local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if ( comp2 ~= nil ) then
		ComponentSetValue2( comp2, "on_collision_die", true )
	end
end

comp = EntityGetFirstComponent( entity_id, "SpriteComponent" )

if ( comp ~= nil ) then
	edit_component( entity_id, "VelocityComponent", function(vcomp,vars)
		local vel_x,vel_y = ComponentGetValueVector2( vcomp, "mVelocity")
		
		if ( vel_x > 0 ) then
			ComponentSetValue2( comp, "special_scale_x", 1 )
		elseif ( vel_x < 0 ) then
			ComponentSetValue2( comp, "special_scale_x", -1 )
		end
	end)
end