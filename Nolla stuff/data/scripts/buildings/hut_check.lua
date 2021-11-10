dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetWithTag( "player_unit" )
local book = EntityGetInRadiusWithTag( x, y, 32, "normal_tablet" )
local book2 = EntityGetInRadiusWithTag( x, y, 32, "forged_tablet" )
local tele = EntityGetInRadiusWithTag( x, y, 32, "teleport_bunker" )

if ( #p > 0 ) and ( #book > 0 ) and ( #tele == 0 ) then
	for i,bk in ipairs( book ) do
		if ( EntityGetComponent( bk, "PhysicsBodyComponent" ) ~= nil ) then
			AddFlagPersistent( "progress_hut_a" )
			GameAddFlagRun( "fishing_hut_a" )
			
			EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
			EntityLoad("data/entities/buildings/teleport_bunker.xml", x, y)
			
			EntityKill( bk )
			break
		end
	end
elseif ( #p > 0 ) and ( #book2 > 0 ) and ( #tele == 0 ) then
	for i,bk in ipairs( book2 ) do
		if ( EntityGetComponent( bk, "PhysicsBodyComponent" ) ~= nil ) then
			AddFlagPersistent( "progress_hut_b" )
			GameAddFlagRun( "fishing_hut_b" )
			
			EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
			EntityLoad("data/entities/buildings/teleport_bunker2.xml", x, y)
			
			EntityKill( bk )
			break
		end
	end
end