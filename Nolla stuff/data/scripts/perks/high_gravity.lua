dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local targets = EntityGetWithTag( "homing_target" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		if ( EntityHasTag( target_id, "high_gravity" ) == false ) then
			edit_component( target_id, "CharacterPlatformingComponent", function(comp,vars)
				local gravity = ComponentGetValue2( comp, "pixel_gravity" ) * 1.4
				ComponentSetValue2( comp, "pixel_gravity", gravity )
			end)
			
			edit_component( target_id, "WormComponent", function(comp,vars)
				local gravity = ComponentGetValue2( comp, "gravity" ) * 1.4
				ComponentSetValue2( comp, "gravity", gravity )
			end)
			
			EntityAddTag( target_id, "high_gravity" )
		end
	end
end