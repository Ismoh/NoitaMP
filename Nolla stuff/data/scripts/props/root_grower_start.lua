dofile_once("data/scripts/lib/utilities.lua")

function grow()
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	-- stick to closest surface
	local found_normal,nx,ny,dist = GetSurfaceNormal( pos_x, pos_y, 20, 8 )
	if found_normal then
		pos_x = pos_x + nx * dist
		pos_y = pos_y + ny * dist
		EntitySetTransform(entity_id, pos_x, pos_y)

		-- set initial growth dir
		edit_component2( entity_id, "VelocityComponent", function(comp,vars)
			ComponentSetValueVector2( comp, "mVelocity", -nx, -ny)
		end)
	end
	
	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/root_grow", pos_x, pos_y )

	-- grow!
	EntitySetComponentsWithTagEnabled(entity_id, "grow", true)
end

function collision_trigger()
	grow()
end

function damage_received()
	grow()
end
