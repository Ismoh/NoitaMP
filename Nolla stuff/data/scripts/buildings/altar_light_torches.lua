dofile_once("data/scripts/lib/utilities.lua")


function collision_trigger()

	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	local torches = EntityGetWithTag( "altar_torch" )

	if ( #torches > 0 ) then
		for index,torch in ipairs(torches) do
			if torch ~= nil then
				-- TODO: check distance to entity

				local tpos_x, tpos_y = EntityGetTransform( torch )
				if (math.abs( tpos_x-pos_x ) < 128 ) and (math.abs( tpos_y-pos_y ) < 64) then
					EntitySetComponentsWithTagEnabled( torch, "fire", true )
				end

			end
		end 
	end
end