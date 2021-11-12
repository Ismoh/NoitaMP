-- event implementation

function get_player()
	return EntityGetWithTag("player_unit")[1]
end

function get_players()
	return EntityGetWithTag("player_unit")
end

function get_player_position()
	return EntityGetTransform(get_player())
end

function get_player_with_position()
	local player = get_player()
	local x,y = EntityGetTransform(player)
	return player,x,y
end

function get_enemies_in_radius(radius)
	local x,y = get_player_position()
	return EntityGetInRadiusWithTag(x, y, radius, "enemy")
end

function add_icon_above_head( game_effect_entity, icon_file, event, custom_name )
	if game_effect_entity ~= nil then
		EntityAddComponent2( game_effect_entity, "UIIconComponent",
		{
			name = custom_name or event.ui_name,
			icon_sprite_file = icon_file,
			display_above_head = true,
			display_in_hud = false,
			is_perk = false,
		})
	end
end

function add_icon_in_hud( game_effect_entity, icon_file, event, custom_name )
	if game_effect_entity ~= nil then
		EntityAddComponent2( game_effect_entity, "UIIconComponent",
		{
			name = custom_name or event.ui_name,
			description = event.ui_description,
			icon_sprite_file = icon_file,
			display_above_head = false,
			display_in_hud = true,
			is_perk = false,
		})
	end
end

function add_text_above_head( entity_id, text )
	if text ~= "" then
		local text_id = EntityCreateNew( "text_above_head" )
		
		EntityAddComponent2( text_id, "SpriteComponent",
		{
			image_file="data/fonts/font_pixel_white.xml",
			is_text_sprite=true,
			offset_x=12,
			offset_y=20,
			text = text, 
			update_transform=true,
			update_transform_rotation=false,
			has_special_scale=true,
			special_scale_x=0.65,
			special_scale_y=0.65,
			alpha=0.5,
		})
		
		EntityAddComponent2( text_id, "InheritTransformComponent",
		{
		})
		
		EntityAddChild( entity_id, text_id )
	end
end

function add_timer_above_head( entity_id, event_id, event_timer )
	local timer_id = EntityCreateNew( "delay_timer" )
	
	EntityAddComponent2( timer_id, "InheritTransformComponent",
	{
	})
	
	EntityAddComponent2( timer_id, "SpriteComponent",
	{
		image_file="data/fonts/font_pixel_white.xml",
		is_text_sprite=true,
		offset_x=12,
		offset_y=42,
		text = "", 
		update_transform=true,
		update_transform_rotation=false,
		has_special_scale=true,
		special_scale_x=0.65,
		special_scale_y=0.65,
		alpha=0.8,
	})
	
	EntityAddComponent2( timer_id, "LifetimeComponent",
	{
		lifetime = event_timer,
	})
	
	EntityAddComponent2( timer_id, "VariableStorageComponent",
	{
		name = "event",
		value_string = event_id,
	})
	
	EntityAddComponent2( timer_id, "VariableStorageComponent",
	{
		name = "lifetime",
		value_int = event_timer,
	})
	
	EntityAddComponent2( timer_id, "LuaComponent",
	{
		script_source_file = "data/scripts/streaming_integration/scripts/delay_timer_update.lua",
		execute_every_n_frame = 1,
	})
	
	EntityAddComponent2( timer_id, "LuaComponent",
	{
		script_source_file = "data/scripts/streaming_integration/scripts/delay_timer_finish.lua",
		execute_every_n_frame = -1,
		execute_on_removed = true,
	})
	
	EntityAddChild( entity_id, timer_id )
end

function set_lifetime( entity_id, multiplier_ )
	local multiplier = multiplier_ or 1.0
	local lifetime = math.max( get_lifetime() * multiplier, 120 )
	
	local game_effects = EntityGetComponent( entity_id, "GameEffectComponent" )
	local lifetimes = EntityGetComponent( entity_id, "LifetimeComponent" )
	
	if (game_effects ~= nil) then
		for i,v in ipairs(game_effects) do
			ComponentSetValue2( v, "frames", lifetime )
		end
	end
	
	if (lifetimes ~= nil) then
		for i,v in ipairs(lifetimes) do
			ComponentSetValue2( v, "lifetime", lifetime )
		end
	end
end

function get_lifetime()
	return StreamingGetVotingCycleDurationFrames()
end


-- event voting
local streaming_config_events_per_vote = 4


local next_event_id = 1
local event_weights = {}

-- this is called once at the start of a game to build the event list that is displayed in the options menu.
function _reflect()
	for i,it in ipairs(streaming_events) do
		RegisterStreamingEvent( it.id, it.ui_name, it.ui_description, it.ui_icon or "", it.ui_author or "", it.kind, it.weight )
	end
end

-- this is called at the start of a vote. and after that _streaming_get_event_for_vote() is called a couple of times to get the events for a vote
function _streaming_on_vote_start()
	for i,w in pairs( event_weights ) do
		local weight_change = w
		
		-- event_weights stores how much the event's weight has changed in either positive or negative direction. Every time a new vote starts, that weight change goes towards 0 by 25% so that the weight eventually returns to its default value.
		if ( math.abs( weight_change ) > 0.1 ) then
			weight_change = weight_change * 0.75
			
			--[[
			Debug print
			local data = streaming_events[i]
			print( data.id .. "'s weight changed to " .. tostring( (data.weight + weight) * 100.0 ) .. " (dynamic weight " .. tostring( w * 100.0 ) .. " -> " .. tostring( weight * 100.0 ) .. ")" )
			]]--
		else
			weight_change = nil
		end
		
		event_weights[i] = weight_change
	end
	
	for i,data in ipairs( streaming_events ) do
		-- Decrease the event's cooldown and remove it entirely if it's at zero.
		if ( data.cooldown ~= nil ) then
			if ( data.cooldown > 1 ) then
				data.cooldown = data.cooldown - 1
			else
				print( "Set cooldown off for " .. data.id )
				data.cooldown = nil
			end
		end
	end
end

function _streaming_get_event_for_vote()
	local weighted_list = {}
	local total_weight = 0
	
	for i,v in ipairs( streaming_events ) do
		local w = v.weight or 1.0
		
		if ( event_weights[i] ~= nil ) then
			w = math.max( w + event_weights[i], 0.01 )
		end

		if (( v.enabled == nil ) or ( v.enabled )) and ( v.cooldown == nil ) then
			total_weight = total_weight + w * 100
			table.insert( weighted_list, { i, total_weight, w * 100 } )
		end
	end
	
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() * total_weight )
	
	-- If no valid events were found, do search again but ignore cooldown
	if ( #weighted_list == 0 ) then
		print( "No valid events, ignoring cooldown" )
		
		total_weight = 0
		
		for i,v in ipairs( streaming_events ) do
			local w = v.weight or 1.0
			
			if ( event_weights[i] ~= nil ) then
				w = math.max( w + event_weights[i], 0.01 )
			end

			if (( v.enabled == nil ) or ( v.enabled )) then
				total_weight = total_weight + w * 100
				table.insert( weighted_list, { i, total_weight, w * 100 } )
			end
		end
	end
	
	-- If still no valid events were found, use NOTHING
	if ( #weighted_list == 0 ) then
		print( "No valid events!!" )
		return "HEALTH_PLUS", "$streamingevent_health_plus", "$streamingeventdesc_health_plus", "data/ui_gfx/streaming_event_icons/health_plus.png"
	end
	
	local rnd = Random( 0, math.max( total_weight - 0.1, 0.01 ) )
	local currweight = 0
	local event = streaming_events[next_event_id]
	
	for i,v in ipairs( weighted_list ) do
		if ( rnd >= currweight ) and ( rnd < v[2] ) then
			local id = v[1]
			event = streaming_events[id]
			
			-- Set the event on cooldown
			event.cooldown = 1
			
			-- Apply a modifier to the event's weight
			if ( event_weights[id] == nil ) then
				event_weights[id] = -0.5
			else
				event_weights[id] = event_weights[id] - 0.25
			end
			
			print( "Picked " .. event.id .. " with weight of " .. tostring( v[3] ) .. " out of a total of " .. tostring( total_weight ) )
			
			break
		else
			currweight = currweight + v[3]
		end
	end
	
	next_event_id = next_event_id + 1
	if next_event_id > #streaming_events then next_event_id = 1 end

	return event.id, event.ui_name, event.ui_description, event.ui_icon
end

-- this is called after a vote winner has been chosen
function _streaming_run_event(id)
	for i,evt in ipairs(streaming_events) do
		if evt.id == id then
			if evt.action_delayed ~= nil then
				if evt.delay_timer ~= nil then
					local p = get_players()
					
					if ( #p > 0 ) then
						for a,b in ipairs( p ) do
							add_timer_above_head( b, evt.id, evt.delay_timer )
						end
					end
				end
			elseif evt.action ~= nil then	
				evt.action(evt)
			end
			
			event_weights[i] = -1.0
			
			break
		end
	end
end

-- this is called when enabled events are changed via options
function _streaming_set_event_enabled(id,enabled)
	for i,evt in ipairs(streaming_events) do
		if evt.id == id then
			evt.enabled = enabled
			break
		end
	end
end


-- this is called on PRIVMSG and USERSTATE irc commands (also when the game is paused).
-- can be used to implement custom message handling. please note that 'message' and 'raw' have been decoded to include only characters in the ascii 1-255 range.
--[[function _streaming_on_irc( is_userstate, sender_username, message, raw )
	
end]]--