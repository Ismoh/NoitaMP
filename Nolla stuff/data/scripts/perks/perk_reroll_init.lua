
local entity_id = GetUpdatedEntityID()
local itemcost_comp = EntityGetFirstComponent( entity_id, "ItemCostComponent" )
local costsprite_comp = EntityGetComponent( entity_id, "SpriteComponent", "shop_cost" )

local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) )
local cost = 200 * math.pow( 2, perk_reroll_count )

if ( costsprite_comp ~= nil ) then
	local comp = costsprite_comp[1]
	local offsetx = 6
	
	local text = tostring(cost)
	
	if ( text ~= nil ) then
		local textwidth = 0
	
		for i=1,#text do
			local l = string.sub( text, i, i )
			
			if ( l ~= "1" ) then
				textwidth = textwidth + 6
			else
				textwidth = textwidth + 3
			end
		end
		
		offsetx = textwidth * 0.5 - 0.5
		
		ComponentSetValue2( comp, "offset_x", offsetx )
	end
end

ComponentSetValue( itemcost_comp, "cost", tostring(cost))

-- ComponentSetMetaCustom( ingestion_component, "ingestible_materials", values)
