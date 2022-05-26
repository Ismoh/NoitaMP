----------------------------------------------------------------------------------------------------
-- Imports by dofile, dofile_once and require
----------------------------------------------------------------------------------------------------
dofile("mods/noita-mp/files/scripts/init/init_.lua")
local fu = require("file_util")
local ui = require("Ui")

logger:debug("init.lua", "Starting to load noita-mp init.lua..")


----------------------------------------------------------------------------------------------------
-- Stuff needs to be executed before anything else
----------------------------------------------------------------------------------------------------
fu.SetAbsolutePathOfNoitaRootDirectory()

-- Is used to stop Noita pausing game, when focus is gone (tab out game)
ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")

local worldSeedMagicNumbersFileAbsPath = fu.GetAbsoluteDirectoryPathOfMods() .. "/temp/WorldSeed.xml"
if fu.Exists(worldSeedMagicNumbersFileAbsPath) then
    logger:debug("init.lua", "Loading " .. worldSeedMagicNumbersFileAbsPath)
    ModMagicNumbersFileAdd(worldSeedMagicNumbersFileAbsPath)
else
    logger:debug("init.lua", "Unable to load " .. worldSeedMagicNumbersFileAbsPath)
end

fu.Find7zipExecutable()

local saveSlotsLastModifiedBeforeWorldInit = fu.getLastModifiedSaveSlots()

EntityUtils.modifyPhysicsEntities()

----------------------------------------------------------------------------------------------------
-- NoitaMP functions
----------------------------------------------------------------------------------------------------

local function createGlobalWhoAmIFunction()
    _G.whoAmI = function()
        if _G.Server:amIServer() then
            return "SERVER"
        end
        if _G.Client:amIClient() then
            return "CLIENT"
        end
        return nil
    end
end

--- When connecting the first time to a server, the server will send the servers' seed to the client.
--- Then the client restarts, empties his selected save slot, to be able to generate the correct world,
--- with the servers seed.
local function setSeedIfConnectedSecondTime()
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))
    logger:debug("init.lua", "Servers world seed = ", seed)
    if not seed and seed > 0 then
        if DebugGetIsDevBuild() then
            util.Sleep(5) -- needed to be able to attach debugger again
        end

        local saveSlotMetaDirectory = ModSettingGet("noita-mp.saveSlotMetaDirectory")
        if saveSlotMetaDirectory then
            fu.removeContentOfDirectory(saveSlotMetaDirectory)
        else
            error("Unable to emtying selected save slot!", 2)
        end

        SetWorldSeed(seed)
        _G.Client.connect(nil, nil, 1)
    end
end

----------------------------------------------------------------------------------------------------
-- Noita API callback funcstions
----------------------------------------------------------------------------------------------------
function OnModPreInit()
    createGlobalWhoAmIFunction()

    setSeedIfConnectedSecondTime()
end

function OnWorldInitialized()
    logger:debug(nil, "init.lua | OnWorldInitialized()")

    local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
    logger:debug(nil, "init.lua | make_zip = " .. tostring(make_zip))
    if make_zip then
        local archive_name = "server_save06_" .. os.date("%Y-%m-%d_%H-%M-%S")
        local destination = fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "_"
        local archive_content =
        fu.Create7zipArchive(archive_name .. "_from_server", fu.GetAbsoluteDirectoryPathOfSave06(), destination)
        local msg =
        ("init.lua | Server savegame [%s] was zipped with 7z to location [%s]."):format(archive_name, destination)
        logger:debug(nil, msg)
        GamePrint(msg)
        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", false, false) -- automatically start the server again
    end

    --logger:debug("init.lua | Initialise client and server stuff..")
    --dofile_once("mods/noita-mp/files/scripts/net/server_class.lua") -- run once to init server object
    --dofile_once("mods/noita-mp/files/scripts/net/client_class.lua") -- run once to init client object
    --dofile_once("mods/noita-mp/files/scripts/net/Server.lua")
    --dofile_once("mods/noita-mp/files/scripts/net/Client.lua")
end

function OnPlayerSpawned(player_entity)
    -- local component_id = em:AddNetworkComponentToEntity(player_entity, util.getLocalPlayerInfo(), -1)

    if not GameHasFlagRun("nameTags_script_applied") then
        GameAddFlagRun("nameTags_script_applied")
        EntityAddComponent2(player_entity,
            "LuaComponent",
            {
                script_source_file = "mods/noita-mp/files/scripts/noita-components/name_tags.lua",
                execute_every_n_frame = 1,
            })
    end
end

function OnPausePreUpdate()
    _G.Server.update()
    _G.Client.update()
end

--- PreUpdate of world
function OnWorldPreUpdate()
    if not _G.saveSlotMeta then
        local saveSlotsLastModifiedAfterWorldInit = fu.getLastModifiedSaveSlots()
        for i = 1, #saveSlotsLastModifiedBeforeWorldInit do
            for j = 1, #saveSlotsLastModifiedAfterWorldInit do
                local saveSlotMeta = nil
                if saveSlotsLastModifiedBeforeWorldInit[i].lastModified > saveSlotsLastModifiedAfterWorldInit[j].lastModified then
                    saveSlotMeta = saveSlotsLastModifiedBeforeWorldInit[i]
                else
                    saveSlotMeta = saveSlotsLastModifiedAfterWorldInit[j]
                end

                if saveSlotMeta then
                    --- Set modSettings as well when changing this: ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta, false)
                    _G.saveSlotMeta = saveSlotMeta
                    ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta.dir, false)
                    logger:info(nil, "Save slot found in '%s'", util.pformat(_G.saveSlotMeta))
                end
            end
        end
    end

    --UpdateLogLevel()

    _G.Server.update()
    _G.Client.update()

    --dofile("mods/noita-mp/files/scripts/ui.lua")

    ui.drawGui()
end
