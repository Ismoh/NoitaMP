dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local orbcomp = EntityGetComponent( entity_id, "OrbComponent" )
local orb_id = -1

for key,comp_id in pairs(orbcomp) do 
	orb_id = ComponentGetValueInt( comp_id, "orb_id" )
end

if (orb_id >= 100) then

	-- reset the VariableStorageComponent
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	for key,comp_id in pairs(components) do 
		local var_name = ComponentGetValue( comp_id, "name" )
		if( var_name == "card_name") then
			ComponentSetValue( comp_id, "value_string", "" )
		end
	end


	-- set the sprite to red
	components = EntityGetComponent( entity_id, "SpriteComponent" )
	for key,comp_id in pairs(components) do 
		ComponentSetValue( comp_id, "image_file", "data/items_gfx/orbs/orb_red_evil.xml" )
	end
end
