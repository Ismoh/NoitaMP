-- todo - change the color of the sampo
local entity_id = GetUpdatedEntityID()
local orb_count = GameGetOrbCountThisRun()

local MAX_ORB_NAMES = 13

if( orb_count < 0 ) then orb_count = 0 end
if( orb_count > MAX_ORB_NAMES ) then orb_count = MAX_ORB_NAMES end

local orb_name = "$item_mcguffin_" .. tostring(orb_count)
local orb_desc = "$itemdesc_mcguffin_" .. tostring(orb_count)

if( GameGetOrbCountThisRun() > 33 ) then
	orb_name = "$item_mcguffin_33"
	orb_desc = "$itemdesc_mcguffin_33"
end

local item_component = EntityGetFirstComponent( entity_id, "ItemComponent" )
if( item_component ~= nil ) then
	ComponentSetValue( item_component, "item_name", orb_name )
	ComponentSetValue( item_component, "ui_description", orb_desc )
end

local uiinfo_component = EntityGetFirstComponent( entity_id, "UIInfoComponent" )
if( uiinfo_component ~= nil ) then
	ComponentSetValue( uiinfo_component, "name", orb_name )
end
