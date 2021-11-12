local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local biome = BiomeMapGetName( pos_x, pos_y )

local vb = GlobalsGetValue( "visited_biomes" )
local vbc = tonumber( GlobalsGetValue( "visited_biomes_count" ) ) or 0

if ( vb ~= nil ) then
	local first = string.sub( vb, 1, #biome )
	if ( first ~= biome ) then
		local found = false
		local whenfound = string.find( vb, biome )
		if ( whenfound ~= nil ) then
			found = true
		end
		
		if ( found == false ) or ( ( whenfound ~= nil ) and ( whenfound > #vb * 0.5 ) ) then
			vb = biome .. "," .. vb
			vbc = math.min( 1000, vbc + 1 )
		end
		
		--print( vb .. ", " .. tostring( vbc ) )
		
		if ( #vb > 80 ) then
			vb = string.sub( vb, 1, 80 )
		end
	end
else
	print( "nooo" )
end

if ( ( string.find( biome, "holymountain" ) ~= nil ) or ( string.find( biome, "victoryroom" ) ~= nil ) ) then
	local deepest_hm = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_DEPTH", "0" ) )
	
	pos_y = math.floor( pos_y / 512 )
	
	if ( pos_y > deepest_hm + 1 ) then
		local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
		hm_visits = hm_visits + 1
		deepest_hm = pos_y
		GlobalsSetValue( "HOLY_MOUNTAIN_VISITS", tostring( hm_visits ) )
		GlobalsSetValue( "HOLY_MOUNTAIN_DEPTH", tostring( deepest_hm ) )
		
		print( "uusi HM " .. tostring( hm_visits ) )
	end
end

GlobalsSetValue( "visited_biomes", vb )
GlobalsSetValue( "visited_biomes_count", tostring( vbc ) )