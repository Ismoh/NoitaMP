dofile_once( "data/scripts/status_effects/status_list.lua" )

for i,effect in ipairs(status_effects) do
	GameRegisterStatusEffect( 
		effect.id,
		effect.ui_name,
		effect.ui_description,
		effect.ui_icon,
		effect.protects_from_fire or false,
		effect.remove_cells_that_cause_when_activated or false,
		effect.effect_entity or "",
		effect.min_threshold_normalized or 0.0,
		effect.extra_status_00 or "",
		effect.effect_permanent or false,
		effect.is_harmful or false
	)
end