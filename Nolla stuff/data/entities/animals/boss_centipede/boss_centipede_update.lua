dofile_once( "data/scripts/lib/coroutines.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )

-- Description of overall boss behavior:
-- Boss waits for player to pick up item.
-- When item is collected, combat starts.
-- During combat if player is nearby, boss performs attacks and mauneuvers randomly (next_phase() sets phase variable).
-- Some attacks are performed several times in a row (phase_repeats).
-- If boss suffers enough damage it enters "aggro mode" with a different set of attacks.
-- If player moves away from the arena, boss gains cell eating ability and starts chasing.
-- Boss health and abilities vary based on how many orbs player has collected (search for "orbcount").

-- enum for changing C++ logic state. keep this in sync with the values in limbboss_system.cpp
local states = {
	MoveAroundNest = 0,
	FollowPlayer = 1,
	Escape = 2,
	DontMove = 3,
	MoveTo = 4,
	MoveDirectlyTowardsPlayer = 5,
}

local is_dead = false
local boss_chase = 0
local is_eye_open = false
local is_aggro = false
local orbcount = 0
local shield_enabled = false
local did_wait = false
local death_sound_started = false

function init_boss()
	local entity = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity )
	
	local init_comp = get_variable_storage_component(entity, "initialized")
	local orbcount_comp = get_variable_storage_component(entity, "orbcount")

	-- init boss only once
	if init_comp and ComponentGetValue2(init_comp, "value_bool") == false then
		ComponentSetValue2(init_comp, "value_bool", true)
		
		-- Get the amount of orbs to adjust boss difficulty
		-- orbcount = orbcount + new game plus count
		local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
		orbcount = GameGetOrbCountThisRun()
		orbcount = orbcount + newgame_n

		ComponentSetValue2(orbcount_comp, "value_int", orbcount) -- store orbcount for savegames
		
		-- Set boss HP based on orbs
		local boss_hp = 46.0 + ( 2.0 ^ (orbcount + 1.3) ) + (orbcount*15.5)
		local comp = EntityGetFirstComponent( entity, "DamageModelComponent" )
		if( comp ~= nil ) then
			ComponentSetValue( comp, "max_hp", tostring(boss_hp) )
			ComponentSetValue( comp, "hp", tostring(boss_hp) )
		end

		-- no orbs = weaker shield
		if orbcount == 0 then
			EntityAddChild( entity, EntityLoad("data/entities/animals/boss_centipede/boss_centipede_shield_weak.xml", pos_x, pos_y) )
		else
			EntityAddChild( entity, EntityLoad("data/entities/animals/boss_centipede/boss_centipede_shield_strong.xml", pos_x, pos_y) )
		end

		-- orbs boost damage resistances
		local damagemodel_comp = EntityGetFirstComponent( entity, "DamageModelComponent" )
		if damagemodel_comp ~= nil then
			if orbcount >= 3 then
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "melee", 1.5)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "drill", 0.25)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "projectile", 0.2)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "fire", 0)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "ice", 0)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "electricity", 0)
			end
			if( orbcount >= 4 ) then
				EntitySetDamageFromMaterial( entity, "acid", 0.01)
			end
			if orbcount >= 5 then
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "melee", 1.0)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "drill", 0.01)
			end
			if orbcount >= 7 then
				EntitySetDamageFromMaterial( entity, "acid", 0.0)
			end
			if orbcount >= 9 then
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "slice", 0.5)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "physics_hit", 0.5)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "radioactive", 0.5)
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "poison", 0.5)
			end
			if( orbcount >= 11 ) then
				ComponentObjectSetValue2(damagemodel_comp, "damage_multipliers", "melee", 0.5)
			end
		end

		-- orbs determine material damages
		if( orbcount > 0 ) then

			-- material weaknesses based on orb count 
			if( orbcount == 12 ) then EntitySetDamageFromMaterial( entity, "magic_liquid_polymorph", 0.35) end
			if( orbcount == 13 ) then EntitySetDamageFromMaterial( entity, "magic_liquid_random_polymorph", 0.35) end
			if( orbcount == 14 ) then EntitySetDamageFromMaterial( entity, "magic_liquid_teleportation", 0.35) end
			if( orbcount == 15 ) then EntitySetDamageFromMaterial( entity, "magic_liquid_movement_faster", 0.35) end
			if( orbcount == 16 ) then EntitySetDamageFromMaterial( entity, "material_confusion", 0.35) end
		end

		-- over 30 orbs immunity to touch spells
		if( orbcount > 30 ) then
			EntityAddTag( entity, "touchmagic_immunity")
		end
	else
		-- make sure orbcount is not lost on game load
		orbcount = ComponentGetValue2(orbcount_comp, "value_int")
	end
	
	-- Turn on the limbs
	local children = EntityGetAllChildren( entity )
	
	if children ~= nil then
		for _,it in ipairs(children) do
			EntitySetComponentsWithTagEnabled( it, "disabled_at_start", true )
		end
	end

	-- check if boss was in aggro mode
	is_aggro = get_variable_storage_component(entity, "aggro") ~= nil
end

init_boss()


-- gather some data we're gonna reuse --------------
local herd_id = get_herd_id( GetUpdatedEntityID() )
local subphase = 0
local phase_repeats = 0

-- Phase logic
function phase_chase_slow()
	close_eye()
	set_logic_state( states.FollowPlayer )
	--boss_wait(2 * 60)
	boss_wait(60)
	next_phase()
end

function phase_chase()
	close_eye()
	set_logic_state( states.FollowPlayer )
	boss_wait(140)
	next_phase()
end

function phase_chase_direct()
	close_eye()
	set_logic_state( states.MoveDirectlyTowardsPlayer )
	boss_wait(2 * 80)
	next_phase()
end

function phase_circleshot()
	move_to_reference()
	boss_wait(50) -- a brief pause if shield was previously on

	shield_on()
	boss_wait(10)
	open_eye()
	GameEntityPlaySound( GetUpdatedEntityID(), "phase_circleshot_start" )
	
	local shot_count = 10 + math.floor(orbcount / 3)
	local frame = GameGetFrameNum()
	local r = ProceduralRandomf(frame, frame)
	local spiral_speed = 25 * (r*2-1) -- random turn speed & direction with each attack
	
	for i=1,shot_count do
		circleshot(r * 180 + i*spiral_speed)
		boss_wait(12)
	end

	close_eye()
	shield_off()
	boss_wait(60)

	set_logic_state( states.FollowPlayer )
	next_phase()
end

function phase_spawn_minion()
	set_logic_state( states.FollowPlayer )
	
	local spawn_count = 1 + math.floor(orbcount / 2)
	for i=1,spawn_count do
		if not minion_check_maxcount() then
			open_eye()
			GameEntityPlaySound( GetUpdatedEntityID(), "spawn_minion" )
			spawn_minion()
			boss_wait(30)
		end
	end

	close_eye()
	next_phase()
end

function phase_firepillar()
	move_to_reference()
	boss_wait(50) -- a brief pause if shield was previously on

	shield_on()
	boss_wait(10)
	open_eye()

	GameEntityPlaySound( GetUpdatedEntityID(), "shoot_fire" )
	firepillar()
	
	close_eye()
	boss_wait(40)
	--shield_off()
	--boss_wait(20)

	set_logic_state( states.FollowPlayer )
	next_phase()
end

function phase_explosion()
	set_logic_state( states.FollowPlayer )
	open_eye()
	
	GameEntityPlaySound( GetUpdatedEntityID(), "shoot_explosion" )
	if (orbcount < 6) then
		explode()
	else
		explode(true)
	end
	
	boss_wait(20)
	close_eye()
	
	set_logic_state( states.FollowPlayer )
	next_phase()
end

function phase_homingshot()
	open_eye()
	
	local shot_count = 4 + math.floor(orbcount * 0.5)
	for i=1,shot_count do
		homingshot()
		GameEntityPlaySound( GetUpdatedEntityID(), "shoot_homingshot" )
		boss_wait(20)
	end

	close_eye()
	next_phase()
end

function phase_polymorph()
	open_eye()
	boss_wait(30)

	polymorphshot()
	GameEntityPlaySound( GetUpdatedEntityID(), "shoot_homingshot" )
	boss_wait(20)

	close_eye()
	next_phase()
end

function phase_melee()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )
	
	open_eye()
	explosion_attack()
	
	GameEntityPlaySound( GetUpdatedEntityID(), "phase_rush_start" )

	-- flinch away so boss won't hang around on top of player
	local dir_x = 0
	local dir_y = -70
	dir_x, dir_y = vec_rotate(dir_x, dir_y, ProceduralRandomf(pos_x, GameGetFrameNum(), -math.pi * 0.5, math.pi * 0.5))
	set_force_coeff_mult(20)
	move_to(pos_x + dir_x, pos_y + dir_y)
	boss_wait(50)
	set_force_coeff_mult(1)

	close_eye()
	next_phase()
end

function phase_clean_materials()
	set_logic_state( states.FollowPlayer )
	boss_wait(25)
	GameEntityPlaySound( GetUpdatedEntityID(), "shoot_clean_materials" )
	clear_materials()
	next_phase()
end

function phase_aggro()
	set_force_coeff_mult(5)
	set_main_animation("aggro", "aggro")
	
	boss_wait(60)

	-- circle shots to random directions
	local shot_count = 12 + math.floor(orbcount / 3)
	local frame = GameGetFrameNum()
	for i=1,shot_count do
		circleshot_aggro()
		boss_wait(12)
	end
	
	boss_wait(20)
	explosion_attack()

	boss_wait(60)

	set_logic_state( states.FollowPlayer )
	next_phase()
end

function next_phase()
	shield_off()

	-- set a new phase
	local entity_id = GetUpdatedEntityID()
	local players = EntityGetWithTag( "player_unit" )
	if #players > 0 then
		local player_id = players[1]
		
		local xe,ye = EntityGetTransform( entity_id )
		local xp,yp = EntityGetTransform( player_id )
		
		local dist = get_distance(xp,yp,xe,ye)
		
		local phases = -- { phase, repeat amount }
		{
			{ phase_chase_slow, 0 },
			{ phase_circleshot, 1 },
			{ phase_spawn_minion, 0 },
			{ phase_firepillar, 2 },
		}

		-- additional attack mode on higher orbcount
		if orbcount >= 2 then phases[#phases+1] = { phase_homingshot, 0 } end

		if is_aggro then
			-- aggro mode, replace the usual phases with a more difficult selection
			phases =
			{
				--{ phase_chase, 0 },
				{ phase_aggro, 0 },
			}
		end
		
		-- polymorph shots
		if orbcount >= 11 then phases[#phases+1] = { phase_polymorph, 0 } end

		if dist < 65 and not is_aggro then
			-- do a melee attack
			phase = phase_melee
			phase_repeats = 0
		elseif dist < 700 then -- use attack phases
			-- see if phase has repeats queued before picking a new one
			if phase_repeats > 0 then
				phase_repeats = phase_repeats - 1
				return
			end

			-- Every phase increases a 'subphase' variable, and at 6 subphase forces the boss to use the clean_materials phase
			if subphase < 6 then
				SetRandomSeed(xe+xp+subphase, ye+yp)
				local next_phase = random_from_array(phases)
				phase = next_phase[1]
				phase_repeats = next_phase[2]
				
				subphase = subphase + 1
			else
				subphase = 0
				phase_repeats = 0
				phase = phase_clean_materials
			end
		else -- further away: start chasin'
			phase = phase_chase_direct
		end
		
		-- If player is way too far, boss assumes they have left the arena entirely and sets up phase 2
		if (dist > 1300) and (boss_chase == 0) then
			boss_chase = 1
			
			local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
		
			if (celleater ~= nil) then
				ComponentSetValue( celleater, "eat_probability", tostring(100.0) )
				ComponentSetValue( celleater, "radius", tostring(64.0) )
			end
			
			set_force_coeff_mult(5)

			
			phase = phase_chase_direct
		end
		
		--print("Boss distance: " .. tostring(dist))
	end
end


-- actual boss attacks -----------------

function circleshot(angle)
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local branches = 6 + orbcount - phase_repeats
	local space = math.floor(360 / branches)
	local speed = 80
	
	-- spawn projectiles on each branch
	for i=1,branches do
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		shoot_projectile( this, "data/entities/animals/boss_centipede/orb_circleshot.xml", pos_x, pos_y, vel_x, vel_y )
		angle = angle + space
	end

	-- muzzle flash & audio
	EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_pink.xml", pos_x, pos_y)
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/magic/create", pos_x, pos_y )
end

function circleshot_aggro()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local branches = 4 + orbcount
	local speed = 120
	local frame = GameGetFrameNum()
	
	-- spawn projectiles to random directions
	for i=1,branches do
		local r = ProceduralRandomf(frame + i, frame)
		local angle = r * 360
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		shoot_projectile( this, "data/entities/animals/boss_centipede/orb_circleshot.xml", pos_x, pos_y, vel_x, vel_y )
	end

	GameCreateParticle( "slime_green", pos_x, pos_y, 50, 0, -20, true, false )

	-- muzzle flash & audio
	EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_pink.xml", pos_x, pos_y)
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/magic/create", pos_x, pos_y )
end

function homingshot()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local vel_x = 0
	local vel_y = ProceduralRandomf(pos_x, pos_y + GameGetFrameNum(), -200, 50)

	shoot_projectile( this, "data/entities/animals/boss_centipede/orb_homing.xml", pos_x, pos_y, vel_x, vel_y )
end

function polymorphshot()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	-- triangular launch shape
	shoot_projectile( this, "data/entities/animals/boss_centipede/orb_polymorph.xml", pos_x, pos_y - 10, 0, -50 )
	shoot_projectile( this, "data/entities/animals/boss_centipede/orb_polymorph.xml", pos_x - 5, pos_y, -30, 20 )
	shoot_projectile( this, "data/entities/animals/boss_centipede/orb_polymorph.xml", pos_x - 5, pos_y, -30, 20 )
end

function firepillar()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local amount = 10 + orbcount - phase_repeats * 2
	local space  = math.floor(180 / amount)
	local speed  = 150
	local angle  = space * 0.5
	
	for i=1,amount do
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		vel_y = vel_y - 200
		shoot_projectile( this, "data/entities/animals/boss_centipede/firepillar.xml", pos_x, pos_y, vel_x, vel_y )
		
		angle = angle + space
	end

	-- muzzle flash & audio
	EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular.xml", pos_x, pos_y)
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/magic/create", pos_x, pos_y )
end

function explode(big_explosion_)
	local big_explosion = big_explosion_ or false
	
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	if big_explosion then
		shoot_projectile( this, "data/entities/animals/boss_centipede/boss_centipede_explosion_large.xml", pos_x, pos_y, 0, 0 )
	else
		shoot_projectile( this, "data/entities/animals/boss_centipede/boss_centipede_explosion.xml", pos_x, pos_y, 0, 0 )
	end
end

function explosion_attack()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local attack = shoot_projectile( this, "data/entities/animals/boss_centipede/melee.xml", pos_x, pos_y, 0, 0 )
end

function clear_materials()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	shoot_projectile( this, "data/entities/animals/boss_centipede/clear_materials.xml", pos_x, pos_y, 0, 0 )
end

function minion_check_maxcount()
	return #EntityGetWithTag("boss_centipede_minion") >= 3 + orbcount
end

function spawn_minion()
	-- check that we only have less than N minions
	--if minion_check_maxcount() then return end
		
	-- spawn
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	EntityLoad( "data/entities/animals/boss_centipede/boss_centipede_minion.xml", x, y )
	EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_blue.xml", x, y)
end

function shield_on()
	if shield_enabled then return end -- avoid playing unnecessary transitions

	local entity_id = GetUpdatedEntityID()
	local children = EntityGetAllChildren(entity_id)
	if children == nil then return end
	for _,v in ipairs(children) do
		if EntityGetName(v) == "shield_entity" then
			EntitySetComponentsWithTagEnabled( v, "shield", true )
			-- muzzle flash
			local x, y = EntityGetTransform(entity_id)
			EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_large_pink_reverse.xml", x, y)
			GameEntityPlaySound( v, "activate" )
			shield_enabled = true
			return
		end
	end
end

function shield_off()
	if not shield_enabled then return end -- avoid playing unnecessary transitions

	local entity_id = GetUpdatedEntityID()
	local children = EntityGetAllChildren(entity_id)
	if children == nil then return end
	for _,v in ipairs(children) do
		if EntityGetName(v) == "shield_entity" then
			EntitySetComponentsWithTagEnabled( v, "shield", false )
			-- muzzle flash
			local x, y = EntityGetTransform(entity_id)
			EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_large_pink.xml", x, y)
			GameEntityPlaySound( v, "deactivate" )
			shield_enabled = false
			return
		end
	end
	
end

function chase_start()
	set_force_coeff_mult(5)
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	
	if (celleater ~= nil) then
		--ComponentSetValue( celleater, "eat_probability", tostring(100.0) )
	end
end

function chase_stop()
	set_force_coeff_mult(1)
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	
	if (celleater ~= nil) then
		--ComponentSetValue( celleater, "eat_probability", tostring(0.0) )
	end
end

-- Setting the boss movement logic state
function set_logic_state( state )
	edit_component( GetUpdatedEntityID(), "LimbBossComponent", function(comp,vars)
		vars.state = state
	end)

	-- DEBUG:
	local ai = EntityGetFirstComponent( GetUpdatedEntityID(), "LimbBossComponent" )
	local old = 0
	
	if (ai ~= nil) then
		old = tonumber(ComponentGetValue( ai, "state" ))
	end
	
	local on,nn = "",""
	
	for i,v in pairs(states) do
		if (v == old) then
			on = i
		end
		
		if (v == state) then
			nn = i
		end
	end
	
	--print("Changing state from " .. tostring(on) .. " to " .. tostring(nn))
end

-- Special code for moving to a set position
function move_to_reference()
	if ( boss_chase == 0 ) then
		local reference = EntityGetWithTag( "reference" )
		if ( #reference > 0 ) then
			local reference_id = reference[1]
			local x,y = EntityGetTransform( reference_id )
			move_to( x, y )
		else
			print("Boss - NO REFERENCE FOUND!!!")
		end
	else
		set_logic_state( states.FollowPlayer )
	end
end

function move_to( x, y )
	set_logic_state( states.MoveTo )

	edit_component( GetUpdatedEntityID(), "LimbBossComponent", function(comp,vars)
		vars.mMoveToPositionX = x
		vars.mMoveToPositionY = y
	end)
end

function open_eye()
	if is_eye_open then return end
	set_main_animation( "open", "opened" )
	GameEntityPlaySound( GetUpdatedEntityID(), "open_mouth" )
	is_eye_open = true
	boss_wait(55)
end

function close_eye()
	-- don't close eye if there's still attacks lined up
	if not is_eye_open or phase_repeats > 0 then return end
	set_main_animation("close", get_idle_animation_name())
	GameEntityPlaySound( GetUpdatedEntityID(), "close_mouth" )
	is_eye_open = false
	boss_wait(50)
end

-- The boss can't die normally; if their HP is zero, this does stuff instead
function check_death()
	if is_dead then return end
	
	local entity_id = GetUpdatedEntityID()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )

	local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if( comp ~= nil ) then
		local hp = ComponentGetValueFloat( comp, "hp" )

		-- check aggro
		if not is_aggro then
			local max_hp = ComponentGetValueInt( comp, "max_hp")
			is_aggro = hp <= clamp(max_hp * 0.1, 9, 40)
			--print("hp/max: " .. hp .. " / " .. max_hp)

			-- enter aggro mode
			if is_aggro then
				-- store aggro to entity
				EntityAddComponent( entity_id, "VariableStorageComponent", 
				{ 
					name = "aggro",
				})

				set_main_animation("aggro", "aggro")

				-- spawn body chunks
				GameEntityPlaySound( entity_id, "destroy_face" )
				local x,y = EntityGetTransform( entity_id )
				local o = EntityLoad( "data/entities/animals/boss_centipede/body_chunks.xml", x, y)
				PhysicsApplyForce( o, 0, -600)
				PhysicsApplyTorque( o, 200)
				GameCreateParticle( "slime_green", x+20, y, 250, 0, -20, true, false )
			
				phase_repeats = 0
				next_phase()
			end
		end

		-- check death
		if ( hp <= 0.0 ) then
			move_to_reference()
			GameTriggerMusicFadeOutAndDequeueAll()
			if death_sound_started == false then
				GameEntityPlaySound( GetUpdatedEntityID(), "dying" )
				death_sound_started = true
			end

			local o = EntityLoad( "data/entities/animals/boss_centipede/body_chunks.xml", x, y)
				PhysicsApplyForce( o, 0, -600)
				PhysicsApplyTorque( o, 200)

			for i = 1,40 do
				local rand = function() return Random( -10, 10 ) end
				local x,y = EntityGetTransform( entity_id )
				GameScreenshake( i * 1, x, y )
				GameCreateParticle( "slime_green",            x + rand(), y + rand(), 10, i * 5.5, i * 5.5, true, false )
				if i > 20 then
					GameCreateParticle( "gunpowder_unstable", x + rand(), y + rand(), 3,  40.0,    40.0,    true, false )
				end

				wait( 3 )
			end
			
			local reference = EntityGetWithTag( "reference" )
			local x_portal,y_portal = EntityGetTransform( GetUpdatedEntityID() )
			
			if ( #reference > 0 ) then
				local ref_id = reference[1]
				x_portal,y_portal = EntityGetTransform( ref_id )
				EntityKill( ref_id )
			end

			-- fix for spider legs, looks visually quite bad (what? how's this related to spider legs)
			-- 150 puts it right under the bridge, which kinda cool
			y_portal = y_portal + 50
			
			EntityLoad( "data/entities/buildings/teleport_ending_victory_delay.xml", x_portal, y_portal )

			-- kill
			comp = EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" )
			if( comp ~= nil ) then
				ComponentSetValue( comp, "kill_now", "1" )
			end

			GlobalsSetValue( "FINAL_BOSS_ACTIVE", "0" )

			local boss_kill_count = tonumber( GlobalsGetValue( "GLOBAL_BOSS_KILL_COUNT", "0" ) )
			boss_kill_count = boss_kill_count + 1
			print( "boss_kill_count: " .. boss_kill_count )
			GlobalsSetValue( "GLOBAL_BOSS_KILL_COUNT", tostring( boss_kill_count ) )
			
			AddFlagPersistent( "boss_centipede" )
			StatsLogPlayerKill( GetUpdatedEntityID() ) -- this is needed because otherwise the boss kill doesn't get registered as a kill for the player
			is_dead = true

			return
		end
	end
end

-- Basic idle function
function boss_wait( frames )
	check_death()
	wait( frames )
	check_death()
    did_wait = true
end

function animate_sprite( sprite, current_name, next_name )
	GamePlayAnimation( GetUpdatedEntityID(), current_name, 0, next_name, 0 )
end

function get_idle_animation_name()
	return "stand"
end

function set_main_animation( current_name, next_name )
	local sprite = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent" )
	if ( sprite ~= nil ) then
		if not is_aggro then
			animate_sprite( sprite, current_name, next_name )
		else
			-- aggro overrides animations
			animate_sprite( sprite, "aggro", "aggro" )
		end
	end
end

function set_force_coeff_mult( mult )
	local entity_id = GetUpdatedEntityID()
	local physics_ai = EntityGetFirstComponent( entity_id, "PhysicsAIComponent" )

	if (physics_ai ~= nil) then
		-- use a hardcoded value instead of getting from comp to avoid varying the value across save/load serialization
		-- remember to update value here if changed in the component
		local force_coeff_orig = 14.0
		ComponentSetValue( physics_ai, "force_coeff", tostring( force_coeff_orig * mult ) )
	end
end

-- run phase state machine -----------------

next_phase()
-- always start combat with circle shots
--if get_initialized() then
--	phase = phase_circleshot
--	phase_repeats = 2
--end

async_loop(function()

	if is_dead then
		wait(60 * 10)
	else
		did_wait = false
		phase()
		if did_wait == false then -- ensure the coroutine doesn't get stuck in an infinite loop if the states never wait
		    boss_wait(1)
		end
	end
    
end)