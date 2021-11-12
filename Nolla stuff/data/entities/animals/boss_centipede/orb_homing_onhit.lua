dofile( "data/scripts/lib/utilities.lua" )

local force_mult = 450
local force_max = 1000


-- add bounce force
function damage_received(damage, _, hitter ) --  float damage, string message, int entity_thats_responsible, bool is_fatal  )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	local force = damage * force_mult
	force = math.min(force, force_max)
	
	local x,y = EntityGetTransform(hitter)
	if x == nil or y == nil or pos_x == nil or pos_y == nil then return	end
	
	x,y = vec_sub(pos_x, pos_y, x, y)
	x,y = vec_normalize(x, y)
	x,y = vec_mult(x,y, force)

	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
		ComponentSetValueVector2( comp, "mVelocity", vel_x + x, vel_y + y)
	end)
end