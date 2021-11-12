function audio_event_dead( file, event_root )
	local entity = GetUpdatedEntityID()
	EntitySetComponentsWithTagEnabled( entity, "fx", false )
	EntityRemoveTag( entity, "fish_attractor" )
end