dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local rats = EntityGetWithTag( "plague_rat" )
	
	-- don't revenge tentacle on heal
	if ( damage < 0 ) or ( #rats >= 20 ) then return end

	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	local flag_name = "RAT_PERK_TOTAL_COUNT"
	local pickup_count = tonumber( GlobalsGetValue( flag_name, "0" ) )
	local rat_count = math.min( 1 + pickup_count, 10 )
	
	if ( entity_who_caused == entity_id ) or ( ( EntityGetParent( entity_id ) ~= NULL_ENTITY ) and ( entity_who_caused == EntityGetParent( entity_id ) ) ) then return end

	-- check that we're only shooting every 10 frames
	if script_wait_frames( entity_id, 2 ) then  return  end
	
	for i=1,rat_count do
		local rnd = Random( 1, 3 )
		if ( rnd == 1 ) then
			EntityLoad( "data/entities/misc/perks/plague_rats_rat.xml", x, y )
		end
	end
end
