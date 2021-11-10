dofile_once( "data/scripts/lib/utilities.lua" )

function kick( who_kicked )
	local entity = GetUpdatedEntityID()

	local src = -1
	edit_component( entity, "AudioComponent", function(comp,vars)
		src = ComponentGetValue2( comp, "m_latest_source" )
	end)

	if src == -1 then
		GameEntityPlaySound( entity, "03" )
		EntitySetComponentsWithTagEnabled( entity, "fx", true )
		EntityAddTag( entity, "fish_attractor" )
		
		GameAddFlagRun( "musicmachine4" )
	end
end