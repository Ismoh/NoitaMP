dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	-- print("damage")
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	if( entity_who_caused == entity_id ) then return end
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

	if (Random(0,15) == 1) then
		local e = EntityLoad( "data/entities/animals/longleg.xml", pos_x + math.random(-10, 10), pos_y + math.random(-10, 10))	

		edit_component( e, "VelocityComponent", function(comp,vars)
			local vel_x = Random(-90,90)
			local vel_y = Random(-150,0)
			ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
		end)
	end
end
