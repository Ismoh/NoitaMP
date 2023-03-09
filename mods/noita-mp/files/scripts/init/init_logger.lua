if not _G.Logger then
    if require then
        require("Logger")
    else
        _G.Logger = dofile_once("mods/noita-mp/files/scripts/util/Logger.lua")
    end
    Logger.info(Logger.channels.initialize, "_G.Logger initialised!")
else
    Logger.info(Logger.channels.initialize, "_G.Logger was already initialised!")
end
