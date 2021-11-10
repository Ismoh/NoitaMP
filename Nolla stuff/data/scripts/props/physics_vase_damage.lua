dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	-- print("damage")
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

	if( entity_who_caused == entity_id ) then return end

	for i=1,4 do
		local e = EntityLoad( "data/entities/animals/longleg.xml", pos_x + Random(-10, 10), pos_y + Random(-10, 10))
	end
end
