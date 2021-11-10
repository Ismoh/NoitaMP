dofile_once( "data/scripts/lib/utilities.lua" )

-- ensure fx are not left running in case game was closed while the machine was active
local entity = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity )


local animals = EntityGetInRadiusWithTag( x, y, 700, "helpless_animal" )
for i,animal in ipairs(animals) do
	if EntityGetFirstComponent( animal, "AdvancedFishAIComponent" ) == nil then
		local px,py = EntityGetTransform( animal )
		SetRandomSeed( px, py )
		if Random( 1, 100 ) <= 30 then
			if Random( 1, 100 ) <= 50 then
				EntityLoad( "data/entities/particles/questionmark_oneoff.xml", px, py-16 )
			else
				EntityLoad( "data/entities/particles/charm_oneoff.xml", px, py-16 )
			end

			if Random( 1, 100 ) <= 50 then
				GameEntityPlaySound( animal, "confused" )
			end
		end
	end
end