dofile("data/scripts/gun/gun.lua")


reflecting = true

ConfigGunShotEffects_Init( shot_effects )
for i,action in ipairs(actions) do
	current_reload_time = 0
	local shot = create_shot()
	c = shot.state
	set_current_action( action )
	action.action()
	-- send the action info to the game
	register_action( c )
end

reflecting = false