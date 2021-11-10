dofile_once("data/scripts/lib/utilities.lua")

function shot( eid )
	if ( eid ~= nil ) and ( eid ~= NULL_ENTITY ) then
		local c = EntityGetFirstComponent( eid, "ProjectileComponent" )
		
		local flag_name = "PERK_PICKED_HOMUNCULUS"
		local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) )
		local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
		
		if ( c ~= nil ) and ( EntityHasTag( eid, "projectile_heal" ) == false ) then
			local extra_damage = math.min( 50, 1.2 ^ math.max( pickup_count - 1, 0 ) ) + ( hm_visits * 0.1 )
			-- print( "extra damage " .. tostring( extra_damage ) .. ", " .. tostring( pickup_count ) .. ", " .. tostring( hm_visits ) )
			local damage = ComponentGetValue2( c, "damage" ) + extra_damage
			ComponentSetValue2( c, "damage", damage )
		end
	end
end

