dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y * entity_id )

local opts = { "wizard_tele", "wizard_dark", "wizard_poly", "wizard_homing", "wizard_weaken", "wizard_twitchy", "wizard_neutral", "wizard_hearty", "wizard_returner" }

for i=1,1 do
	local rnd = Random( 1, #opts )
	EntityLoad( "data/entities/animals/" .. opts[rnd] .. ".xml", x, y )
end

EntityKill( entity_id )