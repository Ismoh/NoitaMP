dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local enemies = EntityGetInRadiusWithTag( x, y, 200, "destruction_target" )
local players = EntityGetWithTag( "player_unit" )

if ( #enemies > 0 ) then
	for _,enemy_id in ipairs(enemies) do
		local ex, ey = EntityGetTransform( enemy_id )
		
		local dist = math.abs( x - ex ) + math.abs( y - ey )
		
		if ( dist < 300 ) and ( EntityHasTag( enemy_id, "boss" ) == false ) then
			EntityLoad( "data/entities/particles/destruction.xml", ex, ey )
			EntityLoad( "data/entities/misc/explosion_was_here.xml", ex, ey )
			EntityKill( enemy_id )
		end
	end
end

if ( #players > 0 ) then
	for _,player_id in ipairs(players) do
		local px, py = EntityGetTransform( player_id )
		
		EntityLoad( "data/entities/particles/destruction.xml", px, py )
		EntityLoad( "data/entities/misc/explosion_was_here.xml", px, py )
		
		local damagemodels = EntityGetComponent( player_id, "DamageModelComponent" )
		
		if( damagemodels ~= nil ) then
			for _,damagemodel in ipairs(damagemodels) do
				local hp = ComponentGetValue2( damagemodel, "hp" )

				hp = math.max( 0.04, hp - math.max( hp * 0.1, 0.8 ) )
				
				ComponentSetValue2( damagemodel, "hp", hp )
			end
		end
	end
end

GameScreenshake( 100 )
EntityKill( entity_id )