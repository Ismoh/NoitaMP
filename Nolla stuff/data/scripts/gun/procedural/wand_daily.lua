dofile_once("data/scripts/gun/procedural/gun_procedural.lua")

function mysplit( inputstr, sep )
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

function generate_daily_wand( cost, level, force_unshuffle )
	
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local how_many_wands = Random( 5, 15 )
	local gun1 = get_gun_data( cost, level, force_unshuffle )
	for i=1,how_many_wands do
		local gun2 = get_gun_data( cost, level, force_unshuffle )

		if( gun1[ "shuffle_deck_when_empty" ] == 1 and gun2[ "shuffle_deck_when_empty"] == 0 ) then
			-- swap
			gun1 = gun2
		else
			
			if( gun2[ "shuffle_deck_when_empty"] == 1 ) then
				local gun1_capacity = gun1["deck_capacity"]
				local gun2_capacity = gun2["deck_capacity"]
				if( gun2_capacity < gun1_capacity ) then
					local swap_temp = gun1
					gun1 = gun2
					gun2 = swap_temp
				end

				local gun1_castdelay_recharge = gun1["fire_rate_wait"] + gun1["reload_time"]
				local gun2_castdelay_recharge = gun2["fire_rate_wait"] + gun2["reload_time"]

				if(	gun2_castdelay_recharge < gun1_castdelay_recharge ) then
					local swap_temp = gun1
					gun1 = gun2
					gun2 = swap_temp
				end
			end
		end
	end
	
	make_wand_from_gun_data( gun1, entity_id, level )
	-- cards? 
	local daily_cards = GlobalsGetValue( "DAILY_WAND_CARDS_NEEDED" )
	if( daily_cards ~= nil and daily_cards ~= "" ) then
		local cards = mysplit( daily_cards, "," )
		-- only add if there's enough room?
		if( #cards <= gun1["deck_capacity"] ) then
			for k,gun_action in pairs(cards) do
				AddGunAction( entity_id, gun_action )
			end
			GlobalsSetValue( "DAILY_WAND_CARDS_NEEDED", "" )
		end
	else
		wand_add_random_cards( gun1, entity_id, level )
	end


end

-- generate_daily_wand( 40, 2, false )
-- generate_gun( 40, 2, false )