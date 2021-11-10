local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 160, "enemy" )

for i,eid in pairs( targets ) do
	if ( EntityHasTag( eid, "poopstone_immunity" ) == false ) then
		EntityAddRandomStains( eid, CellFactory_GetType("poo"), 10 )
		local e1c,e1e = GetGameEffectLoadTo( eid, "FOOD_POISONING", false )
		local e2c,e2e = GetGameEffectLoadTo( eid, "POISON", false )
		local e3c,e3e = GetGameEffectLoadTo( eid, "SLIMY", false )
		
		if ( e1c ~= nil ) and ( e1e ~= nil ) then
			ComponentSetValue2( e1c, "frames", 300 )
		end
		
		if ( e2c ~= nil ) and ( e2e ~= nil ) then
			ComponentSetValue2( e2c, "frames", 300 )
		end
		
		if ( e3c ~= nil ) and ( e3e ~= nil ) then
			ComponentSetValue2( e3c, "frames", 300 )
		end
	end
end