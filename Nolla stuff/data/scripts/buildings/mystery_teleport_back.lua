dofile_once("data/scripts/lib/utilities.lua")

function portal_teleport_used()
	GameTriggerMusicFadeOutAndDequeueAll( 5.0 )
	
	AddFlagPersistent( "secret_tower" )
end