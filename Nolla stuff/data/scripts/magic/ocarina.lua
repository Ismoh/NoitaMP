dofile_once("data/scripts/lib/utilities.lua")

local ocarina_songs = { 
	portal = { "a", "f", "d", "e", "a2" },
	bomb = { "f", "c", "d", "c" },
	worm = { "gsharp", "f", "e", "b", "d" },
	alchemy = { "a2", "d", "dis", "e", "a" },
}

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local players = EntityGetInRadiusWithTag( x, y, 24, "player_unit" )

if ( #players > 0 ) then
	local player_id = players[1]
	
	local variables = EntityGetComponent( entity_id, "VariableStorageComponent" )
	local note = ""

	if ( variables ~= nil ) then
		for i,comp in ipairs(variables) do
			local name = ComponentGetValue( comp, "name" )
			
			if ( name == "ocarina_note" ) then
				note = ComponentGetValue( comp, "value_string" )
			end
		end
	end
	
	if ( string.len(note) > 0 ) then
		local song_state = -1
		local do_portal_magic = false
		local do_bomb_magic = false
		local do_worm_magic = false
		local do_alchemy_magic = false
		local found = false
		local currsong = 0
		local songcomp = 0
		local casting_spell = false
		
		variables = EntityGetComponent( player_id, "VariableStorageComponent" )
		
		if ( variables ~= nil ) then
			for i,comp in ipairs(variables) do
				local name = ComponentGetValue( comp, "name" )
				
				if ( name == "ocarina_song" ) then
					currsong = ComponentGetValue2( comp, "value_string" )
					songcomp = comp
					break
				end
			end
			
			if ( songcomp ~= 0 ) then
				for i,comp in ipairs(variables) do
					local name = ComponentGetValue( comp, "name" )
					
					if ( name == "ocarina_song_pos" ) then
						song_state = ComponentGetValueInt( comp, "value_int" )
						
						local b = ocarina_songs[currsong] or {}
						
						if ( #b > 0 ) then
							local current_note_pos = song_state + 1
							local song_length = #b
							local current_note = b[current_note_pos] or "none"
							
							if ( currsong == "alchemy" ) then
								current_note = alt_notes[current_note]
							end
							
							if ( current_note_pos < song_length ) and ( note == current_note ) then
								song_state = song_state + 1
								found = true
							elseif ( current_note_pos == song_length ) and ( note == current_note ) then
								casting_spell = true
								
								if ( currsong == "portal" ) then
									do_portal_magic = true
								elseif ( currsong == "bomb" ) then
									do_bomb_magic = true
								elseif ( currsong == "worm" ) then
									do_worm_magic = true
								elseif ( currsong == "alchemy" ) then
									do_alchemy_magic = true
								end
								
								song_state = 0
								currsong = ""
							end
						end
						
						if ( found == false ) then
							currsong = ""
							song_state = 0
						end
						
						if ( #currsong == 0 ) and ( casting_spell == false ) then
							for song,d in pairs( ocarina_songs ) do
								local fnote = d[1]
								
								if ( song == "alchemy" ) then
									fnote = alt_notes[fnote]
								end
								
								if ( note == fnote ) then
									found = true
									currsong = song
									song_state = 1
									ComponentSetValue2( songcomp, "value_string", currsong )
									ComponentSetValue2( comp, "value_int", 1 )
									break
								end
							end
						end
						
						ComponentSetValue2( songcomp, "value_string", currsong )
						ComponentSetValue2( comp, "value_int", song_state )
					end
				end
			end
		end
		
		if ( do_portal_magic ) then
			local already_done = EntityHasTag( player_id, "ocarina_secret_00" )
			
			if ( already_done == false ) then
				EntityLoad( "data/entities/buildings/mystery_teleport_back.xml", x, y - 48 )
				GamePrintImportant( "$log_ocarina", "$logdesc_ocarina" )
				GameAddFlagRun( "ocarina_secret_00" )
				EntityAddTag( player_id, "ocarina_secret_00" )
			else
				GamePrint( "$log_ocarina_done" )
			end
		end
		
		if ( do_bomb_magic ) then
			local already_done = EntityHasTag( player_id, "ocarina_secret_01" )
			
			if ( already_done == false ) then
				EntityLoad( "data/entities/projectiles/bomb_holy.xml", x, y )
				GamePrintImportant( "$log_ocarina", "$logdesc_ocarina" )
				GameAddFlagRun( "ocarina_secret_01" )
				EntityAddTag( player_id, "ocarina_secret_01" )
			else
				GamePrint( "$log_ocarina_done" )
			end
		end
		
		if ( do_worm_magic ) then
			local already_done = EntityHasTag( player_id, "ocarina_secret_02" )
			
			if ( already_done == false ) then
				EntityLoad( "data/entities/animals/worm_big.xml", x, y - 64 )
				GamePrintImportant( "$log_ocarina", "$logdesc_ocarina" )
				GameAddFlagRun( "ocarina_secret_02" )
				EntityAddTag( player_id, "ocarina_secret_02" )
			else
				GamePrint( "$log_ocarina_done" )
			end
		end
		
		if ( do_alchemy_magic ) then
			local keys = EntityGetInRadiusWithTag( x, y, 48, "alchemist_key" )
			
			if ( #keys > 0 ) then
				for i,key_id in ipairs( keys ) do
					local variablestorages = EntityGetComponent( key_id, "VariableStorageComponent" )
					local already_done = EntityHasTag( key_id, "alchemy_ocarina" )
					
					if ( variablestorages ~= nil ) and ( already_done == false ) then
						for j,storage_id in ipairs(variablestorages) do
							local var_name = ComponentGetValue( storage_id, "name" )
							if ( var_name == "status" ) then
								local status = ComponentGetValue( storage_id, "value_int" )
								
								status = status + 1
								
								GameAddFlagRun( "alchemy_ocarina" )
								EntityAddTag( key_id, "alchemy_ocarina" )
								ComponentSetValue2( storage_id, "value_int", status )
								
								if ( status == 1 ) then
									GamePrintImportant( "$log_alchemist_key_first", "$logdesc_alchemist_key_first" )
									EntitySetComponentsWithTagEnabled( key_id, "first", true )
									EntityLoadToEntity( "data/entities/animals/boss_alchemist/key_particles_first.xml", key_id )
									
									edit_component( key_id, "ItemComponent", function(comp,vars)
										ComponentSetValue2( comp, "ui_description", "$itemdesc_key_1")
									end)
								elseif ( status == 2 ) then
									GamePrintImportant( "$log_alchemist_key_second", "$logdesc_alchemist_key_second" )
									EntitySetComponentsWithTagEnabled( key_id, "second", false )
									EntityLoadToEntity( "data/entities/animals/boss_alchemist/key_particles_second.xml", key_id )
									
									edit_component( key_id, "ItemComponent", function(comp,vars)
										ComponentSetValue2( comp, "ui_description", "$itemdesc_key_2")
									end)
								end
							end
						end
					end
				end
			else
				GamePrint( "$log_alchemist_key_invalid" )
			end
		end
	end	
end		