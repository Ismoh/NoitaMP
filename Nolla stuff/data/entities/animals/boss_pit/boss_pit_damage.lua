dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	edit_component( entity_id, "HitboxComponent", function(comp,vars)
		ComponentSetValue2( comp, "damage_multiplier", 0.0 )
	end)
	
	EntitySetComponentsWithTagEnabled( entity_id, "invincible", true )

	SetRandomSeed( x, y * GameGetFrameNum() )
	
	if ( Random( 1, 3 ) == 1 ) then
		local p = ""
		local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "state" ) then
					state = ComponentGetValue2( v, "value_int" )
					
					state = (state + 1) % 10
					
					ComponentSetValue2( v, "value_int", state )
				elseif ( n == "memory" ) then
					p = ComponentGetValue2( v, "value_string" )
					
					if ( #p == 0 ) then
						p = "data/entities/projectiles/enlightened_laser_darkbeam.xml"
						ComponentSetValue2( v, "value_string", p )
					end
				end
			end
		end
		
		if ( #p > 0 ) then
			local angle = Random( 1, 200 ) * math.pi
			local vel_x = math.cos( angle ) * 100
			local vel_y = 0 - math.cos( angle ) * 100
			
			local wid = shoot_projectile( entity_id, "data/entities/animals/boss_pit/wand.xml", x, y, vel_x, vel_y )
			edit_component( wid, "VariableStorageComponent", function(comp,vars)
				ComponentSetValue2( comp, "value_string", p )
			end)
		end
	end
end