dofile( "data/scripts/lib/coroutines.lua" )
dofile_once("data/scripts/lib/utilities.lua")


local gui = nil
local gui_frame_fn = nil


function wait_seconds( seconds )
	wait( seconds * 60 )
end


async(function()
	gui = GuiCreate()

	local x = 100
	local y = 100
	
	wait_seconds(8)

	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "NOITA" )
		GuiTextCentered( gui, 0,0, "A GAME BY" )
		GuiTextCentered( gui, 0,0, "Olli Harjola" )
		GuiTextCentered( gui, 0,0, "Petri Purho" )
		GuiTextCentered( gui, 0,0, "Arvi Teikari" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "PROGRAMMING BY" )
		GuiTextCentered( gui, 0,0, "Petri Purho" )
		GuiTextCentered( gui, 0,0, "Olli Harjola" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "DESIGN BY" )
		GuiTextCentered( gui, 0,0, "Olli Harjola" )
		GuiTextCentered( gui, 0,0, "Petri Purho" )
		GuiTextCentered( gui, 0,0, "Arvi Teikari" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "(SOME) GRAPHICS BY" )
		GuiTextCentered( gui, 0,0, "Arvi Teikari" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "(OTHER) GRAPHICS BY" )
		GuiTextCentered( gui, 0,0, "Petri Purho" )
		GuiTextCentered( gui, 0,0, "Olli Harjola" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)

	---
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "MUSIC BY" )
		GuiTextCentered( gui, 0,0, "From Grotto" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)

	---
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "SOUND DESIGN BY" )
		GuiTextCentered( gui, 0,0, "Niilo Takalainen" )
		GuiTextCentered( gui, 0,0, "Olli Harjola" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "TESTERS BY" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)
	
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "TRANSLATION BY" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)

	---
	gui_frame_fn = function()
		GuiLayoutBeginVertical( gui, 50, 20 )
		GuiTextCentered( gui, 0,0, "THE END" )
		GuiLayoutEnd( gui )
	end
	wait_seconds(2)

	---
	GuiDestroy( gui )
	gui_frame_fn = nil
	gui = nil
	
	GameRemoveFlagRun( "ending_no_game_over_menu" )
	EntityKill( GetUpdatedEntityID() )
end)


async_loop(function()
	if gui ~= nil then
		GuiStartFrame( gui )
	end

	if gui_frame_fn ~= nil then
		gui_frame_fn()
	end

	wait(0)
end)