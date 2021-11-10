function death()
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform(entity_id)

	local deaths = tonumber(GlobalsGetValue("STEVARI_DEATHS", "0"))
	deaths = deaths + 1
	GlobalsSetValue("STEVARI_DEATHS", tostring(deaths))

	if deaths >= 3 then
		GamePrintImportant( "$logdesc_temple_upgrade_guardian", "" )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", pos_x, pos_y )
		GameScreenshake( 50 )
	end
end
