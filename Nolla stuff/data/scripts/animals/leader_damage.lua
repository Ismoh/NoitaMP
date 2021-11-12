dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetFirstHitboxCenter( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

	if( entity_who_caused == entity_id ) then return end

	local health = 0
	local max_health = 0
	
	edit_component( entity_id, "DamageModelComponent", function(comp,vars)
		health = tonumber(ComponentGetValue( comp, "hp"))
		max_health = tonumber(ComponentGetValue( comp, "max_hp"))
	end)
	
	local minion_count = 5
	local minion_interval = max_health / minion_count
	
	local new_health = health - damage
	local nearest_interval = math.floor( health / minion_interval ) * minion_interval
	
	local limit = 7
	local count = 0
	
	while (nearest_interval > new_health) and (count < limit) and (nearest_interval >= 0) do
		GameEntityPlaySound( entity_id, "duplicate" )

		-- find a spawn spot
		local x = Randomf(10,50) -- spawn distance
		local y = 0
		x,y = vec_rotate(x, 0, Randomf(math.pi * 2)) -- random direction
		local did_hit, hit_x, hit_y = RaytracePlatforms(pos_x, pos_y, pos_x + x, pos_y + y)
		local dist = get_distance(pos_x, pos_y, hit_x, hit_y)
		if did_hit then dist = math.max(0, dist - 8) end -- avoid spawning too close by the platform
		
		x, y = vec_normalize(x, y)
		x, y = vec_mult(x, y, dist)
		x = x + pos_x
		y = y + pos_y

		EntityLoad( "data/entities/animals/scavenger_grenade.xml", x, y )
		EntityLoad( "data/entities/particles/teleportation_target.xml", x, y )
		
		nearest_interval = nearest_interval - minion_interval
		
		count = count + 1
	end
end
