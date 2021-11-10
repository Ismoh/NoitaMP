dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local is_charmed = GameGetGameEffectCount( entity_id, "CHARM" )

if( is_charmed > 0 ) then

	local pos_x, pos_y = EntityGetTransform( entity_id )
	SetRandomSeed( pos_x + pos_y, -GameGetFrameNum() )

	local e_id = EntityGetClosestWithTag( pos_x, pos_y, "player_unit")
	if( e_id ~= 0 ) then
		local px, py = EntityGetTransform( e_id )
		local dist_x = math.abs( px - pos_x )
		local dist_y = ( ( pos_y + 10 ) - py ) 
		if( dist_x < 75 and dist_y > 0 and dist_y < 35 ) then
			-- close enough

			local poop_count = 0
			-- VariableStorageComponent
			local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
			if( components ~= nil ) then
				for key,comp_id in pairs(components) do 
					local var_name = ComponentGetValue( comp_id, "name" )
					if( var_name == "mimic_poop_count") then
						poop_count = tonumber( ComponentGetValue2( comp_id, "value_int" ) )
						poop_count = poop_count + 1
						ComponentSetValue2( comp_id, "value_int", poop_count )
						break
					end
				end
			end

			-- print( "poop_count: " .. poop_count )

			local vel_x = px - pos_x
			local vel_y = py - pos_y
			vel_x, vel_y = vec_normalize( vel_x, vel_y )
			vel_x = vel_x * Random( 32, 47 )
			vel_y = vel_y * Random( 32, 44 )
			if( vel_y > -5 ) then vel_y = Random( -40, -15 ) end
			if( Random( 1, 100 ) <= 25 ) then vel_x = -vel_x end

			local gift_entity = "data/entities/items/pickup/goldnugget_10.xml"

			local rnd = Random( 1, 1000 )
			if( rnd >= 1000 ) then
				gift_entity = "data/entities/items/pickup/heart.xml"			
			elseif( rnd >= 985 ) then
				gift_entity = "data/entities/items/pickup/potion.xml"
			elseif( rnd >= 925 ) then
				gift_entity = "data/entities/items/pickup/goldnugget_200.xml"
			elseif( rnd >= 800 ) then
				gift_entity = "data/entities/items/pickup/goldnugget_50.xml"
			else
				gift_entity = "data/entities/items/pickup/goldnugget_10.xml"
			end

			shoot_projectile( entity_id, gift_entity, pos_x, pos_y, vel_x, vel_y )

			if( poop_count >= 10 ) then
				if( Random( 1, 9 ) == 9 ) then
					-- died from exhaustion
					EntityInflictDamage( entity_id, 1000, "DAMAGE_PROJECTILE", "", "NONE", 0, 0 )
				end
			end
		end
	end

end
