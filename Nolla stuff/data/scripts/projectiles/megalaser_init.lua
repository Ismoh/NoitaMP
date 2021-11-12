dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )


-- store references to beams for megalaser_launch.lua
local beams = EntityGetInRadiusWithTag( pos_x, pos_y, 5, "megalaser_beam")
for i=1,5 do
	if i <= #beams then
		EntityAddComponent( entity_id, "VariableStorageComponent", 
		{
			_tags = "beam_ref",
			name = "beam_id",
			value_int = beams[i]
		})
	end
end

