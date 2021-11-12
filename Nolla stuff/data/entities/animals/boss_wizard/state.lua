dofile_once("data/scripts/lib/utilities.lua")

function shot( pid )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local help = EntityGetWithTag( "wizard_orb_death" )
	local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "boss_wizard_state" )
	local comp2 = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "boss_wizard_mode" )
	local comp3 = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )
	if ( comp ~= nil ) and ( comp2 ~= nil ) and ( comp3 ~= nil ) then
		local state = ComponentGetValue2( comp, "value_int" )
		local mode = ComponentGetValue2( comp2, "value_int" )
		
		if ( mode == 0 ) then
			state = (state + 1) % 5
			if ( state == 1 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/meteor.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 220 )
			elseif ( state == 2 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/laser.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 170 )
			elseif ( state == 3 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/summon.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 300 )
			elseif ( state == 4 ) then
				if ( #help > 0 ) then
					ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/statusburst.xml" )
				else
					ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/laser.xml" )
				end
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 190 )
			elseif ( state == 0 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/debuff_init.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 240 )
			end
		elseif ( mode == 1 ) then
			SetRandomSeed( x + y, GameGetFrameNum() )
			state = Random( 0, 4 )
			
			if ( state == 1 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/meteor.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 220 )
			elseif ( state == 2 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/laser.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 170 )
			elseif ( state == 3 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/summon.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 300 )
			elseif ( state == 0 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/debuff_init.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 240 )
			elseif ( state == 4 ) then
				ComponentSetValue2( comp3, "attack_ranged_entity_file", "data/entities/animals/boss_wizard/bloodtentacle.xml" )
				ComponentSetValue2( comp3, "attack_ranged_frames_between", 80 )
			end
		elseif ( mode == 2 ) then
			ComponentSetValue2( comp3, "attack_ranged_enabled", false )
		end
		
		ComponentSetValue2( comp, "value_int", state )
	end
end