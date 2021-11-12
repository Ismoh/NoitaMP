dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
LoadPixelScene( "data/biome_impl/ending_placeholder_victory.png", "data/biome_impl/ending_placeholder_victory_visual.png", x-256, y-256, "", true )
EntityLoad( "data/entities/buildings/teleport_ending_victory.xml", x, y-72 )

-- The boss drops cards

local validcards = {}

for j,thisitem in ipairs(actions) do
	local spawnids = thisitem.spawn_level
	local biomeid = 6
	
	local sid_string = ""
	local sid_value = -99

	for i=1,string.len(spawnids) do
		local letter = string.sub(spawnids, i, i)
		
		if (letter ~= ",") then
			sid_string = sid_string .. letter
		end
		
		if (letter == ",") or (i == string.len(spawnids)) then
			sid_value = tonumber(sid_string)
			sid_string = ""
		end
		
		if (sid_value == biomeid) then
			table.insert(validcards, string.lower(thisitem.id))
			break
		end
	end
end

if (#validcards > 0) then

	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	
	for i=1,5 do
		local randomcard = Random( 1, #validcards )
		
		local card = validcards[randomcard]
		local eid = CreateItemActionEntity( card, x - 24 * 2.5 + i * 24, y + 64 + Random( -20, 20 ) )
		table.remove(validcards, randomcard)
	end
end