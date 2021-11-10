dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function death( )
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )
	local p = EntityGetWithTag( "player_unit" )
	
	local doit = false
	
	for i,v in ipairs( p ) do
		local c = EntityGetAllChildren( v )
		
		if ( c ~= nil ) then
			for a,b in ipairs( c ) do
				if EntityHasTag( b, "essence_effect" ) then
					EntityRemoveFromParent( b )
					EntityKill( b )
					doit = true
				end
			end
		end
	end
	
	local key1 = "ESSENCE_LASER_PICKUP_COUNT"
	local key2 = "ESSENCE_FIRE_PICKUP_COUNT"
	local key3 = "ESSENCE_WATER_PICKUP_COUNT"
	local key4 = "ESSENCE_AIR_PICKUP_COUNT"
	local key5 = "ESSENCE_ALCOHOL_PICKUP_COUNT"
	
	local pick1 = tonumber( GlobalsGetValue( key1, "0" ) )
	local pick2 = tonumber( GlobalsGetValue( key2, "0" ) )
	local pick3 = tonumber( GlobalsGetValue( key3, "0" ) )
	local pick4 = tonumber( GlobalsGetValue( key4, "0" ) )
	local pick5 = tonumber( GlobalsGetValue( key5, "0" ) )
	
	print( tostring( pick1 ) .. ", " .. tostring( pick2 ) .. ", " .. tostring( pick3 ) .. ", " .. tostring( pick4 ) .. ", " .. tostring( pick5 ) )
	
	local loadlist = {}
	
	if ( pick1 > 0 ) then
		for i=1,pick1 do
			table.insert( loadlist, "data/entities/items/pickup/stonestone.xml" )
		end
		
		GlobalsSetValue( key1, "0" )
	end
	
	if ( pick2 > 0 ) then
		for i=1,pick2 do
			table.insert( loadlist, "data/entities/items/pickup/brimstone.xml" )
		end
		
		GlobalsSetValue( key2, "0" )
	end
	
	if ( pick3 > 0 ) then
		for i=1,pick3 do
			table.insert( loadlist, "data/entities/items/pickup/waterstone.xml" )
		end
		
		GlobalsSetValue( key3, "0" )
	end
	
	if ( pick4 > 0 ) then
		for i=1,pick4 do
			table.insert( loadlist, "data/entities/items/pickup/thunderstone.xml" )
		end
		
		GlobalsSetValue( key4, "0" )
	end
	
	if ( pick5 > 0 ) then
		for i=1,pick5 do
			table.insert( loadlist, "data/entities/items/pickup/poopstone.xml" )
		end
		
		GlobalsSetValue( key5, "0" )
	end
	
	for i,v in ipairs( loadlist ) do
		EntityLoad( v, x, y - (i-1) * 12 )
	end
	
	GameRemoveFlagRun( "essence_laser" )
	GameRemoveFlagRun( "essence_fire" )
	GameRemoveFlagRun( "essence_water" )
	GameRemoveFlagRun( "essence_air" )
	GameRemoveFlagRun( "essence_alcohol" )
	
	if doit then
		EntityLoad( "data/entities/particles/image_emitters/perk_effect.xml", x, y )
		GamePrintImportant( "$log_curse_secret", "$logdesc_curse_fade" )
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", x, y )
	end
end