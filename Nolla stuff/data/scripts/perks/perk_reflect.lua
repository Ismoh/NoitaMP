dofile( "data/scripts/perks/perk_list.lua" )

for i,perk in ipairs(perk_list) do
	RegisterPerk( 
		perk.id,
		perk.ui_name,
		perk.ui_description,
		perk.ui_icon,
		perk.perk_icon
		)
end