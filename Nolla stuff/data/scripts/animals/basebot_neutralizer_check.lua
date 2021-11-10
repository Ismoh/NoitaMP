dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()

local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

if ( comp ~= nil ) then
	local targets = EntityGetWithTag( "neutralizer_target" )
	
	if ( #targets > 0 ) then
		ComponentSetValue2( comp, "attack_ranged_entity_file", "data/entities/projectiles/machinegun_bullet_roboguard_big.xml" )
		ComponentSetValue2( comp, "attack_ranged_frames_between", 20 )
	else
		ComponentSetValue2( comp, "attack_ranged_entity_file", "data/entities/projectiles/neutralizershot.xml" )
		ComponentSetValue2( comp, "attack_ranged_frames_between", 90 )
	end
end