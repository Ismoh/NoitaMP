dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if HasFlagPersistent( "secret_amulet" ) then
	EntitySetComponentsWithTagEnabled( entity_id, "player_amulet", true )
end

if HasFlagPersistent( "secret_amulet_gem" ) then
	EntitySetComponentsWithTagEnabled( entity_id, "player_amulet_gem", true )
end

if HasFlagPersistent( "moon_is_sun" ) and HasFlagPersistent( "darkmoon_is_darksun" ) then
	AddFlagPersistent( "secret_hat" )
end

if HasFlagPersistent( "secret_hat" ) then
	EntitySetComponentsWithTagEnabled( entity_id, "player_hat2", true )
end