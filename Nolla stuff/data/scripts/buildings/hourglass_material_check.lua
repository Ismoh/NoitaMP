dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	EntitySetComponentsWithTagEnabled(entity_id, "enabled_by_liquid", true)
	EntitySetComponentsWithTagEnabled(entity_id, "disabled_by_liquid", false)
	
	-- kill others
	for _,v in pairs(EntityGetInRadiusWithTag(x, y, 150, "hourglass_entity")) do
		if v ~= entity_id then EntityKill(v) end
	end

	-- play jingle
	if EntityHasTag(entity_id, "hourglass_blood") then
		print("play blood jingle")
		GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
		GameTriggerMusicEvent( "music/oneshot/heaven_02_no_drs", true, x, y )
	elseif EntityHasTag(entity_id, "hourglass_teleport") then
		-- flag for mountain_tree pillars
		AddFlagPersistent( "secret_hourglass" )
		print("play teleport jingle")
		GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
		GameTriggerMusicEvent( "music/oneshot/heaven_03", true, x, y )
	end
end
