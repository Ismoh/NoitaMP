dofile_once("data/scripts/lib/coroutines.lua")

async(function ()
		local i = 0
		while true do
			-------------------------------------
			print( "resumed " .. i )
			i = i+1
			wait( 60 )
			-------------------------------------
		end
	end)