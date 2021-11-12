dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player_id = EntityGetClosestWithTag( x, y, "player_unit" )

if ( player_id ~= nil) and ( player_id ~= NULL_ENTITY ) then
	local px, py = EntityGetTransform( player_id )
	
	local projectile = ""
			
	edit_component( entity_id, "AnimalAIComponent", function(comp,vars)
		projectile = ComponentGetValue2( comp, "attack_ranged_entity_file" )
	end)
	
	if ( projectile ~= nil ) and ( #projectile > 0 ) then
		local ydist = 25
		
		if ( string.find( projectile, "fire" ) ~= nil ) or ( string.find( projectile, "spit" ) ~= nil ) then
			ydist = 40
		elseif ( string.find( projectile, "arrow" ) ~= nil ) then
			ydist = 18
		end
	
		if ( math.abs( px - x ) < 170 ) and ( math.abs( py - y ) < ydist ) then
			local dir = 0
			local dircheck = ""
			
			edit_component( entity_id, "SpriteComponent", function(comp,vars)
				dircheck = ComponentGetValue2( comp, "image_file" )
			end)
			
			if ( dircheck ~= nil ) then
				if ( string.sub( dircheck, -9 ) == "right.xml" ) then
					dir = 1
				elseif ( string.sub( dircheck, -8 ) == "left.xml" ) then
					dir = -1
				end
			end
			
			if ( ( dir == 1 ) and ( px > x ) ) or ( ( dir == -1 ) and ( px < x ) ) then
				local velocity = 300
				
				if ( string.find( projectile, "arrow" ) ~= nil ) then
					SetRandomSeed( x, y + GameGetFrameNum() )
					velocity = Random( 300, 400 )
				elseif ( string.find( projectile, "fire" ) ~= nil ) then
					velocity = 320
				elseif ( string.find( projectile, "thunder" ) ~= nil ) then
					velocity = 50
				elseif ( string.find( projectile, "spit" ) ~= nil ) then
					velocity = 360
				end
				
				dir = 0 - math.atan2( py - y, px - x )
				local vel_x = math.cos( dir ) * velocity
				local vel_y = 0 - math.sin( dir ) * velocity
				
				if ( string.find( projectile, "arrow" ) ~= nil ) then
					vel_y = vel_y - 50
				end
				
				shoot_projectile( entity_id, projectile, x, y + 2, vel_x, vel_y )
			end
		end
	end
end