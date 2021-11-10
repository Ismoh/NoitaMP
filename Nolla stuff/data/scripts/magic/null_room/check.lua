dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local altars = EntityGetWithTag( "null_room_check" )

if ( #altars >= 3 ) then
	GameTriggerMusicEvent( "music/oneshot/heaven_02_no_drs", true, x, y )
	AddFlagPersistent( "secret_null" )
	
	EntityLoad( "data/entities/particles/supernova.xml", x, y )
	create_all_player_perks( x, y - 32 )
	remove_all_perks()
	
	GamePrintImportant( "$log_curse_secret", "" )
	
	for i,v in ipairs( altars ) do
		EntityKill( v )
	end
end