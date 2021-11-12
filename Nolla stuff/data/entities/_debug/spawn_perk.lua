dofile( "data/scripts/lib/coroutines.lua" )
dofile( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/perks/perk.lua")

local gui_frame_fn = nil

local gui = GuiCreate()



gui_frame_fn = function()
	local destroy = false
	local hax_btn_id = 123
	local num_perks = #perk_list

	-----
	local perk_button_action = function ( i )

		if GuiButton( gui, 0, 0, perk_list[i].ui_name, hax_btn_id+i ) then
			GamePrint( "DEBUG - attempting to spawn " .. perk_list[i].id .. " at player location" )

			local x, y = GameGetCameraPos()
			local player_entity = EntityGetClosestWithTag( x, y, "player_unit")
			if( player_entity ~= 0 ) then
				x, y = EntityGetTransform( player_entity )
			end
			perk_spawn( x, y - 8, perk_list[i].id )
		end
	end

	-----
	GuiLayoutBeginVertical( gui, 1, 0 )
	GuiText( gui, 0,0, "Select a perk to spawn at player location" )
	if GuiButton( gui, 0, 0, "Close", hax_btn_id ) then
		print("2")
		destroy = true
	end
	GuiLayoutEnd( gui)

	-- column 1
	GuiLayoutBeginVertical( gui, 5, 4 )
	for i=1,31 do
		if i > num_perks then 
			break 
		end

		perk_button_action( i )
	end
	GuiLayoutEnd( gui )

	-- column 2
	GuiLayoutBeginVertical( gui, 35, 4 )
	for i=32,63 do
		if i > num_perks then 
			break 
		end

		perk_button_action( i )
	end
	GuiLayoutEnd( gui )

	-- column 3
	GuiLayoutBeginVertical( gui, 65, 4 )
	for i=63,94 do
		if i > num_perks then 
			break 
		end

		perk_button_action( i )
	end
	GuiLayoutEnd( gui )

	-----

	-----
	if destroy then
		GuiDestroy( gui )
		gui_frame_fn = nil
		gui = nil
		EntityKill( GetUpdatedEntityID() )
	end
end
	

async_loop(function()
	if gui ~= nil then
		GuiStartFrame( gui )
	end

	if gui_frame_fn ~= nil then
		gui_frame_fn()
	end

	wait(0)
end)
