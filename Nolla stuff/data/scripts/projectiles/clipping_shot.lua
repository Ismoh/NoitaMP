dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local parent_id = EntityGetParent( entity_id )

local target_id = 0

if ( parent_id ~= NULL_ENTITY ) then
	target_id = parent_id
else
	target_id = entity_id
end

if ( target_id ~= NULL_ENTITY ) then
	local projectile_components = EntityGetComponent( target_id, "ProjectileComponent" )
	local velocity_components = EntityGetComponent( target_id, "VelocityComponent" )
	
	if( projectile_components == nil ) then return end

	if ( #projectile_components > 0 ) then
		edit_component( target_id, "ProjectileComponent", function(comp,vars)
			vars.penetrate_world = 1
			vars.penetrate_world_velocity_coeff = 0.1
			
			local friction = ComponentGetValue( comp, "friction" )
			friction = math.max( 0, friction )
			vars.friction = friction
		end)
	end
	
	if( velocity_components == nil ) then return end

	if ( #velocity_components > 0 ) then
		edit_component( target_id, "VelocityComponent", function(comp,vars)
			local friction = ComponentGetValue( comp, "air_friction" )
			friction = math.max( 0, friction )
			vars.air_friction = friction
		end)
	end
end
