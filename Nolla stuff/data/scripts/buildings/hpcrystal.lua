dofile_once("data/scripts/lib/utilities.lua")

function heal_someone()
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )
	local radius = 192
	
	local p = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )
	local lcomp = EntityGetFirstComponent( entity_id, "LuaComponent", "hpcrystal_effect" )
	local tries = 0
	local maxtries = 50
	
	if ( lcomp ~= nil ) then
		if ( #p > 0 ) then
			local player_id = p[1]
			local px, py = EntityGetTransform( player_id )
			
			local targets = EntityGetInRadiusWithTag( px, py, math.floor( radius * 0.85 ), "enemy" )
		
			if ( #targets > 0 ) then
				SetRandomSeed( GameGetFrameNum(), x + entity_id )
				local rnd = Random( 1, #targets )
				
				while ( tries < maxtries ) do
					rnd = ( rnd % #targets ) + 1
					local target_id = targets[rnd]
					
					local comp = EntityGetFirstComponent( target_id, "DamageModelComponent" )
					
					if ( comp ~= nil ) then
						local hp = ComponentGetValue2( comp, "hp" )
						local max_hp = ComponentGetValue2( comp, "max_hp" )
						
						if ( hp < max_hp ) then
							tries = 99
							local eid = EntityLoad( "data/entities/misc/fullheal.xml", x, y )
							EntityAddChild( target_id, eid )
							ComponentSetValue2( lcomp, "execute_every_n_frame", 180 )
						end
					end
					
					tries = tries + 1
				end
			end
		end
		
		if ( tries >= maxtries ) and ( tries < 99 ) then
			ComponentSetValue2( lcomp, "execute_every_n_frame", 30 )
		end
	end
end

heal_someone()
