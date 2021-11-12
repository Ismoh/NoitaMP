dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

	local health = 0
	
	edit_component( entity_id, "DamageModelComponent", function(comp,vars)
		health = tonumber(ComponentGetValue( comp, "hp"))
	end)
	
	if (health > 0.3) and (health - damage < 0.3) then
		for i=1,3 do
			local offsetx = Random(-10,10)
			local offsety = Random(-10,10)
			
			local e = EntityLoad( "data/entities/animals/slimeshooter.xml", x + offsetx, y + offsety )	

			edit_component( e, "VelocityComponent", function(comp,vars)
				local vel_x = Random(-90,90)
				local vel_y = Random(-150,25)
				ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
			end)
		end
	end
end