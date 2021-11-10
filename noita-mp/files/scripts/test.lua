function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
    GamePrintImportant( "OnPlayerSpawned()", "Player entity id: " .. tostring(player_entity) )


    package.path = debug.getinfo(1,"S").source:match[[^@?(.*[\/])[^\/]-$]] .."?.lua;".. package.path
    GamePrintImportant( "package path in server.lua", "package.apth = " .. tostring(package.path) )
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
    GamePrintImportant( "OnWorldInitialized()", tostring(GameGetFrameNum()) )
end