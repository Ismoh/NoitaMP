dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player = EntityGetClosestWithTag(x, y, "player_unit")

local count = 2
while count > 0 do
	local pid = perk_spawn_random(x,y)
	-- rerandomize if picked perk is gamble
	component_read( get_variable_storage_component(pid, "perk_id"), { value_string = "" }, function(comp)
		print(comp.value_string)
		if comp.value_string ~= "GAMBLE" then
			perk_pickup(pid, player, "", false, false )
			count = count - 1
		else
			--print("Gamble perk spawned another Gamble. Rerandomizing...")
			EntityKill(pid)
		end
	end)
end

EntityKill(entity_id)
