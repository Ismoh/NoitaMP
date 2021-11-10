--- constants ---
dofile_once( "data/scripts/gun/gun_enums.lua")

ACTION_DRAW_RELOAD_TIME_INCREASE = 0
ACTION_MANA_DRAIN_DEFAULT = 10
ACTION_UNIDENTIFIED_SPRITE_DEFAULT = "data/ui_gfx/gun_actions/unidentified.png"

-- passing data to C++ code (reflection)
reflecting = false
current_action = nil

-- gun current state
first_shot   = true
reloading    = false
start_reload = false
got_projectiles = false

state_from_game = nil

discarded       	= { }
deck 				= { }
hand 				= { }

c                   = { }
current_projectile  = nil
current_reload_time =  0
shot_effects        = { }

active_extra_modifiers	= { }

mana = 0.0

state_shuffled         = false
state_cards_drawn      = 0
state_discarded_action = false
state_destroyed_action = false

playing_permanent_card = false

use_game_log = false

-- add the generated functions
dofile_once("data/scripts/gun/gunaction_generated.lua")
dofile_once("data/scripts/gun/gun_generated.lua")
dofile_once("data/scripts/gun/gunshoteffects_generated.lua")


-- initialize global/constant gun state
gun = {}
ConfigGun_Init( gun )
current_reload_time = gun.reload_time

-- setup additional card-related variables
dont_draw_actions = false
force_stop_draws = false
shot_structure = {}
recursion_limit = 2

-- action effect reflection stuff

function reset_modifiers( state )
	ConfigGunActionInfo_Init( state )
end

function register_action( state )
	state.reload_time = current_reload_time
	ConfigGunActionInfo_PassToGame( state )
end

function register_gunshoteffects( effects )
	ConfigGunShotEffects_PassToGame( effects )
end

--- call this when current action changes

function set_current_action( action )
	c.action_id                	 = action.id
	c.action_name              	 = action.name
	c.action_description       	 = action.description
	c.action_sprite_filename   	 = action.sprite
	c.action_type              	 = action.type
	c.action_recursive           = action.recursive
	c.action_spawn_level       	 = action.spawn_level
	c.action_spawn_probability 	 = action.spawn_probability
	c.action_spawn_requires_flag = action.spawn_requires_flag
	c.action_spawn_manual_unlock = action.spawn_manual_unlock or false
	c.action_max_uses          	 = action.max_uses
	c.custom_xml_file          	 = action.custom_xml_file
	c.action_ai_never_uses		 = action.ai_never_uses or false
	c.action_never_unlimited	 = action.never_unlimited or false

	c.action_is_dangerous_blast  = action.is_dangerous_blast

	c.sound_loop_tag = action.sound_loop_tag

	c.action_mana_drain = action.mana
	if action.mana == nil then
		c.action_mana_drain = ACTION_MANA_DRAIN_DEFAULT
	end

	c.action_unidentified_sprite_filename = action.sprite_unidentified
	if action.sprite_unidentified == nil then
		c.action_unidentified_sprite_filename = ACTION_UNIDENTIFIED_SPRITE_DEFAULT
	end

	current_action = action
end

function clone_action( source, target )
	target.id                = source.id
	target.name              = source.name
	target.type              = source.type
	target.recursive         = source.recursive
	target.related_projectiles = source.related_projectiles
	target.related_extra_entities = source.related_extra_entities
	target.action            = source.action
	target.deck_index        = source.deck_index
	target.custom_uses_logic = source.custom_uses_logic
	target.mana              = source.mana
	target.sound_loop_tag	 = source.sound_loop_tag
end


--- debug functions ---

function debug_print(text) 
	print(text) 
end

function debug_print_action_table(t)
	for i,action in ipairs(t) do
		debug_print(action.name)
	end
end

function debug_print_deck() debug_print_action_table(deck)
end
function debug_print_discarded() debug_print_action_table(discarded)
end
function debug_print_hand() debug_print_action_table(hand)
end


-- various utilities

function create_shot( num_of_cards_to_draw )
	local shot = { }
	shot.state = { }
	reset_modifiers( shot.state )
	shot.num_of_cards_to_draw = num_of_cards_to_draw
	return shot
end

function draw_shot( shot, instant_reload_if_empty )
	local c_old = c

	c = shot.state
	
	shot_structure = {}
	draw_actions( shot.num_of_cards_to_draw, instant_reload_if_empty )
	register_action( shot.state )
	SetProjectileConfigs()

	c = c_old
end


--- helper functions. actions may call these ---

function order_deck()
	if gun.shuffle_deck_when_empty then
		SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
		-- shuffle the deck
		state_shuffled = true

		local rand = Random 
	    local iterations = #deck
	    local new_deck = { }

	    for i = iterations, 1, -1 do  -- looping from iterations to 1 (inclusive)
			local index = rand( 1, i )
			local action = deck[ index ]
			table.remove( deck, index )
			table.insert( new_deck, action )
	    end

		deck = new_deck
    else
		-- sort the deck
		if ( force_stop_draws == false ) then
			table.sort( deck, function(a,b) 
					local a_index = a.deck_index or 0 
					local b_index = b.deck_index or 0
					return a_index<b_index
				end )
		else
			table.sort( deck, function(a,b) local a_ = a.deck_index or 0 local b_ = b.deck_index or 0 return a_<b_ end )
		end
    end
end

function play_action( action )
	OnActionPlayed( action.id )

	table.insert( hand, action )

	set_current_action( action )
	action.action()

	local is_projectile = false

	if action.type == ACTION_TYPE_PROJECTILE then
		is_projectile = true
		got_projectiles = true
	end

	if  action.type == ACTION_TYPE_STATIC_PROJECTILE then
		is_projectile = true
		got_projectiles = true
	end

	if action.type == ACTION_TYPE_MATERIAL then
		is_projectile = true
		got_projectiles = true
	end

	if is_projectile then
		for i,modifier in ipairs(active_extra_modifiers) do
			extra_modifiers[modifier]()
		end
	end

	current_reload_time = current_reload_time + ACTION_DRAW_RELOAD_TIME_INCREASE
end

function draw_action( instant_reload_if_empty )
	local action = nil

	state_cards_drawn = state_cards_drawn + 1

	if reflecting then  return  end


	if ( #deck <= 0 ) then
		if instant_reload_if_empty and ( force_stop_draws == false ) then
			move_discarded_to_deck()
			order_deck()
			start_reload = true
		else
			reloading = true
			return true -- <------------------------------------------ RETURNS
		end
	end

	if #deck > 0 then
		-- draw from the start of the deck
		action = deck[ 1 ]

		table.remove( deck, 1 )
		
		-- update mana
		local action_mana_required = action.mana
		if action.mana == nil then
			action_mana_required = ACTION_MANA_DRAIN_DEFAULT
		end

		if action_mana_required > mana then
			OnNotEnoughManaForAction()
			table.insert( discarded, action )
			return false -- <------------------------------------------ RETURNS
		end

		if action.uses_remaining == 0 then
			table.insert( discarded, action )
			return false -- <------------------------------------------ RETURNS
		end

		mana = mana - action_mana_required
	end

	--- add the action to hand and execute it ---
	if action ~= nil then
		play_action( action )
	end

	return true
end

function handle_mana_addition( action )
	if ( action ~= nil ) then
		local action_mana_required = action.mana or 0
		
		if ( action_mana_required < 0 ) then
			mana = mana - action_mana_required
		end
	end
end

function draw_actions( how_many, instant_reload_if_empty )
	if ( dont_draw_actions == false ) then
		c.action_draw_many_count = how_many
		
		if playing_permanent_card and (how_many == 1) then
			return -- SPECIAL RULE: modifiers that use draw_actions(1) to draw one more action don't result in two actions being drawn after them if the modifier is permanently attached and wand 'casts 1'
		end

		for i = 1, how_many do
			local ok = draw_action( instant_reload_if_empty )
			if ok == false then
				-- attempt to draw other actions
				while #deck > 0 do
					if draw_action( instant_reload_if_empty ) then
						break
					end
				end
			end

			if reloading then
				return
			end
		end
	end
end

function add_projectile( entity_filename )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	BeginProjectile( entity_filename )
	EndProjectile()
end

function add_projectile_trigger_timer( entity_filename, delay_frames, action_draw_count )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	BeginProjectile( entity_filename )
	BeginTriggerTimer( delay_frames )
		draw_shot( create_shot( action_draw_count ), true )
	EndTrigger()
	EndProjectile()
end

function add_projectile_trigger_hit_world( entity_filename, action_draw_count )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end
	
	BeginProjectile( entity_filename )
	BeginTriggerHitWorld()
		draw_shot( create_shot( action_draw_count ), true )
	EndTrigger()
	EndProjectile()
end

function add_projectile_trigger_death( entity_filename, action_draw_count )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	BeginProjectile( entity_filename )
	BeginTriggerDeath()
		draw_shot( create_shot( action_draw_count ), true )
	EndTrigger()
	EndProjectile()
end

function baab_instruction( name )
	if reflecting then 
		return 
	end

	BaabInstruction( name )
end

function move_discarded_to_deck()
	for i,action in ipairs(discarded) do
		table.insert(deck, action)
	end
	discarded = { }
end

function move_hand_to_discarded()
	for i,action in ipairs(hand) do

		local identify = false

		if got_projectiles or (action.type == ACTION_TYPE_OTHER) or (action.type == ACTION_TYPE_UTILITY) then -- ACTION_TYPE_MATERIAL, ACTION_TYPE_PROJECTILE are handled via got_projectiles
			if action.uses_remaining > 0 then
				if action.custom_uses_logic then
					-- do nothing
				elseif action.is_identified then
					-- consume consumable actions
					action.uses_remaining = action.uses_remaining - 1
					local reduce_uses = ActionUsesRemainingChanged( action.inventoryitem_id, action.uses_remaining )
					if not reduce_uses then
						action.uses_remaining = action.uses_remaining + 1 -- cancel the reduction
					end
				end
			end

			identify = true
		end

		if identify then
			ActionUsed( action.inventoryitem_id )
			action.is_identified = true
		end

		if use_game_log then
			if action.is_identified then
				LogAction( action.name )
			else
				LogAction( "?" )
			end
		end

		if action.uses_remaining ~= 0 or action.custom_uses_logic then
			if action.permanently_attached == nil then
				table.insert( discarded, action )
			end
		end
	end
	hand = { }
end

function check_recursion( data, rec_ )
	local rec = rec_ or 0
	
	if ( data ~= nil ) then
		if ( data.recursive ~= nil ) and data.recursive then
			if ( rec >= recursion_limit ) then
				return -1
			else
				return rec + 1
			end
		end
	end
	
	return rec
end

--- exported functions. called by the C++ code -------------------------------------

-- call this to do one shot (or round, or turn)
root_shot = nil

function _start_shot( current_mana )
	-- debug checks
	if state_from_game == nil then
		print("'gun.lua' - state_from_game is nil - did we ever initialize this gun?")
		return
	end
	
	dont_draw_actions = false
	force_stop_draws = false

	-- create the initial shot
	root_shot = create_shot( 1 )
	c = root_shot.state

	-- set up the initial state for the selected gun
	ConfigGunActionInfo_Copy( state_from_game, c )
	ConfigGunShotEffects_Init( shot_effects )

	root_shot.num_of_cards_to_draw = gun.actions_per_round

	mana = current_mana

	-- set the deck order if required
	if first_shot then
		order_deck()
		current_reload_time = gun.reload_time
		first_shot = false
	end

	got_projectiles = false
end

function _draw_actions_for_shot( can_reload_at_end )
	-- debug_print("====================================================")
	-- debug_print("--- SHOOTING ---")
	-- debug_print("")
	-- debug_print("  --- DECK BEFORE SHOT ---")
	-- debug_print_deck()
	-- debug_print("  --- DISCARDED ---")
	-- debug_print_discarded()
	-- debug_print("  --- HAND ---")
	-- debug_print_hand()
	-- debug_print("")
	-- debug_print("--- DRAWING ---")
	-- debug_print("")

	-- draw actions
	draw_shot( root_shot, false )

	register_gunshoteffects( shot_effects )

	-- finish the turn
	if can_reload_at_end then
		_handle_reload()
	end

	active_extra_modifiers = { }

	-- debug_print("--- DECK AFTER SHOT ---")
	-- debug_print_deck();
	-- debug_print("")
	-- debug_print("====================================================")

	reloading = false
end
 
function _handle_reload()
	move_hand_to_discarded()

	-- start a reload?
	if (not reloading) and ( #deck <= 0 or start_reload ) then
		move_discarded_to_deck()
		order_deck()

		StartReload( current_reload_time )
		-- debug_print("reload")
		current_reload_time = gun.reload_time
		start_reload = false;
	end

	return mana
end


function _set_gun()
	gun = __globaldata
end

function _set_gun2()
	state_from_game = __globaldata
end

-- this can be used to build a new deck
function _clear_deck( use_game_log_ )
	hand      = { }
	discarded = { }
	deck      = { }
	first_shot = true
	current_reload_time = 0
	reloading = false

	use_game_log = use_game_log_
end

-- this can be used to build a new deck
function _add_card_to_deck(action_id, inventoryitem_id, uses_remaining, is_identified)
	for i,action in ipairs(actions) do
		if action.id == action_id then
			action_clone = {}
			clone_action( action, action_clone )
			action_clone.inventoryitem_id = inventoryitem_id
			action_clone.uses_remaining   = uses_remaining
			action_clone.deck_index       = #deck
			action_clone.is_identified    = is_identified
			-- debug_print( "uses " .. uses_remaining )
			table.insert( deck, action_clone )
			break
		end
	end
end

function _play_permanent_card(action_id)
	for i,action in ipairs(actions) do
		if action.id == action_id then
			playing_permanent_card = true
			action_clone = {}
			clone_action( action, action_clone )
			action_clone.permanently_attached = true
			action_clone.uses_remaining = -1
			handle_mana_addition( action_clone )
			play_action( action_clone )
			
			playing_permanent_card = false
			break
		end
	end
end

function _change_action_uses_remaining(inventoryitem_id, uses_remaining)
	local applied = false

	local apply = function(arr)
		if applied then 
			return 
		end

		for i,action in ipairs( arr ) do
			if action.inventoryitem_id == inventoryitem_id then
				action.uses_remaining = uses_remaining
				applied = true
				break
			end
		end
	end

	apply( deck )
	apply( discarded )
	apply( hand )
end

function _add_extra_modifier_to_shot(name)
	if extra_modifiers[name] == nil then
		print_error( "_add_extra_modifier_to_shot() - function '" .. name .. "' not found in gun_extra_modifiers.lua")
		return
	end

	table.insert( active_extra_modifiers, name )
end

-- slot durabilities (in shots). -1 means infinite --

function _get_gun_slot_durability_default(current_slot_count)
	local c = current_slot_count

	if     c >= 20 then
		return 40

	elseif c >= 15 then
		return 50

	elseif c >= 10 then
		return 60

	elseif c >= 8 then
		return 70

	elseif c >= 7 then
		return 80

	elseif c >= 6 then
		return 100

	elseif c >= 5 then
		return 120

	elseif c >= 4 then
		return 140

	elseif c >= 3 then
		return 160

	elseif c >= 2 then
		return 180

	elseif c == 1 then
		return -1
	end

	return -1
end

function _get_gun_slot_durability_infinite(current_slot_count)
	return -1 -- never wears out
end


--- build the table of available actions ---
dofile("data/scripts/gun/gun_actions.lua")
dofile("data/scripts/gun/gun_extra_modifiers.lua")