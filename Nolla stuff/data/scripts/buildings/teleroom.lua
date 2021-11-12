dofile_once("data/scripts/lib/utilities.lua")

if HasFlagPersistent( "miniboss_fish" ) then
	EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "enabled_by_liquid", true )
else
	EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "enabled_by_liquid", false )
end
