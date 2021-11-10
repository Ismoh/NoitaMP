dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
entity_id = EntityGetRootEntity( entity_id )

if ( entity_id ~= NULL_ENTITY ) then
	local projectile_components = EntityGetComponent( entity_id, "HomingComponent" )
	
	if( projectile_components == nil ) then return end
		
	if ( #projectile_components > 0 ) then
		edit_component( entity_id, "HomingComponent", function(comp,vars)
			local targeting = ComponentGetValue2( comp, "homing_targeting_coeff" )
			local velocity = ComponentGetValue2( comp, "homing_velocity_multiplier" )
			
			targeting = math.min( 800, targeting + 2 )
			velocity = math.min( 2.0, velocity + 0.01 )
			
			ComponentSetValue2( comp, "homing_targeting_coeff", targeting )
			ComponentSetValue2( comp, "homing_velocity_multiplier", velocity )
		end)
	end
end
