dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local targets = EntityGetWithTag( "enemy" )
if ( #targets > 0 ) then
	for i,v in ipairs( targets ) do
		if ( EntityHasTag( v, "biome_modifier_effect" ) == false ) then
			local game_effect_comp = GetGameEffectLoadTo( v, "INVISIBILITY", true )
			if ( game_effect_comp ~= nil ) then
				ComponentSetValue2( game_effect_comp, "frames", -1 )
			end
			
			EntityAddTag( v, "biome_modifier_effect" )
		end
	end
	
	EntityKill( entity_id )
end