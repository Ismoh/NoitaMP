dofile_once("data/scripts/lib/utilities.lua")

function drop()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "kick_count" )
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	if ( comp ~= nil ) then
		local count = ComponentGetValue2( comp, "value_int" )
		count = count + 1
		ComponentSetValue2( comp, "value_int", count )
		
		SetRandomSeed( x + entity_id, y - GameGetFrameNum() )
		
		local outcome = Random( 1, 21 )
		
		if ( count == 1 ) then
			outcome = 10
		elseif ( count > 3 ) then
			outcome = math.max( 1, outcome - ( count - 2 ) )
		end
		
		-- print( tostring( outcome ) )
		
		if ( outcome == 1 ) then
			EntityLoad( "data/entities/projectiles/deck/explosion_giga.xml", x, y )
			EntityKill( entity_id )
			return
		elseif ( outcome == 20 ) then
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_1000.xml", x, y, Random(-40,40), Random(-40,40) )
		elseif ( outcome == 15 ) then
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_200.xml", x - 8, y, Random(-40,40), Random(-40,40) )
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_200.xml", x + 8, y, Random(-40,40), Random(-40,40) )
		elseif ( outcome < 10 ) then
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_50.xml", x, y, Random(-40,40), Random(-40,40) )
		else
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_10.xml", x - 8, y, Random(-40,40), Random(-40,40) )
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_10.xml", x + 8, y, Random(-40,40), Random(-40,40) )
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_10.xml", x, y - 8, Random(-40,40), Random(-40,40) )
			shoot_projectile( entity_id, "data/entities/items/pickup/bloodmoney_10.xml", x , y + 8, Random(-40,40), Random(-40,40) )
		end
	end
end

function kick()
	drop()
end