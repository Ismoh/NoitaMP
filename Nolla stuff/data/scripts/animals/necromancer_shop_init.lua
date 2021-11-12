if( GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) ==  "1" ) then

	-- if we're in peace, load charm!
	local entity_id    = GetUpdatedEntityID()
	GetGameEffectLoadTo( entity_id, "CHARM", true )

end
