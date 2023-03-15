-- Disable log channel testing in Noita
if BaabInstruction then
    ModSettingSet("noita-mp.log_level_testing", "off")
end
----------------------------------------------------------------------------------------------------
--- Imports by dofile, dofile_once and require
----------------------------------------------------------------------------------------------------
dofile("mods/noita-mp/files/scripts/init/init_.lua")
local Utils = require("Utils")
local fu    = require("FileUtils")
local ui    = require("Ui").new()
Logger.debug(Logger.channels.initialize, "Starting to load noita-mp init.lua..")

----------------------------------------------------------------------------------------------------
--- Stuff needs to be executed before anything else
----------------------------------------------------------------------------------------------------
fu.SetAbsolutePathOfNoitaRootDirectory()
NoitaMpSettings.clearAndCreateSettings()
-- Is used to stop Noita pausing game, when focus is gone (tab out game)
ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")
fu.Find7zipExecutable()
local saveSlotsLastModifiedBeforeWorldInit = fu.GetLastModifiedSaveSlots()

----------------------------------------------------------------------------------------------------
--- NoitaMP functions
----------------------------------------------------------------------------------------------------

--- When connecting the first time to a server, the server will send the servers' seed to the client.
--- Then the client restarts, empties his selected save slot, to be able to generate the correct world,
--- with the servers seed.
local function setSeedIfConnectedSecondTime()
    local cpc  = CustomProfiler.start("ModSettingGet")
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))
    CustomProfiler.stop("ModSettingGet", cpc)
    Logger.debug(Logger.channels.initialize, ("Servers world seed = %s"):format(seed))
    if not seed and seed > 0 then
        if DebugGetIsDevBuild() then
            Utils.Sleep(5) -- needed to be able to attach debugger again
        end

        local cpc1                  = CustomProfiler.start("ModSettingGet")
        local saveSlotMetaDirectory = ModSettingGet("noita-mp.saveSlotMetaDirectory")
        CustomProfiler.stop("ModSettingGet", cpc1)
        if saveSlotMetaDirectory then
            fu.RemoveContentOfDirectory(saveSlotMetaDirectory)
        else
            error("Unable to emptying selected save slot!", 2)
        end

        SetWorldSeed(seed)
        _G.Client.connect(nil, nil, 1)
    end
end

----------------------------------------------------------------------------------------------------
--- Noita API callback functions
----------------------------------------------------------------------------------------------------

function OnModPreInit()
    setSeedIfConnectedSecondTime()
end

function OnWorldInitialized()
    local cpc = CustomProfiler.start("init.OnWorldInitialized")
    Logger.debug(Logger.channels.initialize, "OnWorldInitialized()")

    local cpc1     = CustomProfiler.start("ModSettingGet")
    local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
    CustomProfiler.stop("ModSettingGet", cpc1)
    Logger.debug(Logger.channels.initialize, "make_zip = " .. tostring(make_zip))
    if make_zip then
        local archive_name    = "server_save06_" .. os.date("%Y-%m-%d_%H-%M-%S")
        local destination     = fu.GetAbsoluteDirectoryPathOfNoitaMP() .. pathSeparator .. "_"
        local archive_content = fu.Create7zipArchive(archive_name .. "_from_server",
            fu.GetAbsoluteDirectoryPathOfSave06(), destination)
        local msg             = ("init.lua | Server savegame [%s] was zipped with 7z to location [%s]."):format(
            archive_name,
            destination)
        Logger.debug(Logger.channels.initialize, msg)
        GamePrint(msg)
        local cpc1 = CustomProfiler.start("ModSettingSetNextValue")
        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", false,
            false) -- automatically start the server again
        CustomProfiler.stop("ModSettingSetNextValue", cpc1)
    end
    CustomProfiler.stop("init.OnWorldInitialized", cpc)
end

function OnPlayerSpawned(player_entity)
    local cpc = CustomProfiler.start("init.OnPlayerSpawned")
    Logger.info(Logger.channels.initialize, ("Player spawned with entityId = %s!"):format(player_entity))

    if not GameHasFlagRun("nameTags_script_applied") then
        GameAddFlagRun("nameTags_script_applied")
        EntityAddComponent2(player_entity,
            "LuaComponent",
            {
                script_source_file    = "mods/noita-mp/files/scripts/noita-components/name_tags.lua",
                execute_every_n_frame = 1,
            })
    end
    CustomProfiler.stop("init.OnPlayerSpawned", cpc)
end

function OnPausePreUpdate()
    local cpc = CustomProfiler.start("init.OnPausePreUpdate")
    Server.update()
    Client.update()
    CustomProfiler.stop("init.OnPausePreUpdate", cpc)
end

--- PreUpdate of world
function OnWorldPreUpdate()
    local cpc = CustomProfiler.start("init.OnWorldPreUpdate")
    --if profiler.isRunning() and os.clock() >= 120 then
    --    fu.createProfilerLog()
    --end

    if not MinaUtils.getLocalMinaInformation().entityId then
        return
    end

    EntityUtils.addOrChangeDetectionRadiusDebug(MinaUtils.getLocalMinaInformation().entityId)

    if not _G.saveSlotMeta then
        local saveSlotsLastModifiedAfterWorldInit = fu.GetLastModifiedSaveSlots()
        for i = 1, #saveSlotsLastModifiedBeforeWorldInit do
            for j = 1, #saveSlotsLastModifiedAfterWorldInit do
                local saveSlotMeta
                if saveSlotsLastModifiedBeforeWorldInit[i].lastModified > saveSlotsLastModifiedAfterWorldInit[j].lastModified then
                    saveSlotMeta = saveSlotsLastModifiedBeforeWorldInit[i]
                else
                    saveSlotMeta = saveSlotsLastModifiedAfterWorldInit[j]
                end

                if saveSlotMeta then
                    --- Set modSettings as well when changing this: ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta, false)
                    _G.saveSlotMeta = saveSlotMeta
                    local cpc1      = CustomProfiler.start("ModSettingSetNextValue")
                    ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta.dir, false)
                    CustomProfiler.stop("ModSettingSetNextValue", cpc1)
                    Logger.info(Logger.channels.initialize,
                        ("Save slot found in '%s'"):format(Utils.pformat(_G.saveSlotMeta)))
                end
            end
        end
    end

    Server.update()
    Client.update()
    ui.update()

    local cpc1 = CustomProfiler.start("init.OnWorldPreUpdate.collectgarbage.count")
    if collectgarbage("count") >= 250000 then
        local cpc2 = CustomProfiler.start("init.OnWorldPreUpdate.collectgarbage.collect")
        -- if memory usage is above 1GB, force a garbage collection
        GamePrintImportant("Memory Usage", "Forcing garbage collection because memory usage is above 1GB.")
        CustomProfiler.stopAll()
        CustomProfiler.report()
        collectgarbage("collect")
        CustomProfiler.stop("init.OnWorldPreUpdate.collectgarbage.collect", cpc2)
    end

    CustomProfiler.stop("init.OnWorldPreUpdate.collectgarbage.count", cpc1)
    CustomProfiler.stop("init.OnWorldPreUpdate", cpc)
end

----------------------------------------------------------------------------------------------------
--- Patch every XML file to remove the CameraBoundComponent
----------------------------------------------------------------------------------------------------
--do
--    Logger.info(Logger.channels.initialize, "Starting to patch XML files to remove CameraBoundComponents. Might take a while.")
--    local timer = os.time()
--    Server.entityCameraBindings = {}
--    local rootNoitaPath = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/"
--    local function patchXMLFile(file)
--        local data = ModTextFileGetContent(file)
--        local dS, dE = data:find("<CameraBoundComponent[^<>]*>%s*</CameraBoundComponent>")
--        if dS and dE then
--            print(data:sub(dS, dE))
--        else
--            dS, dE = data:find("<CameraBoundComponent[^<>]*>")
--        end
--        if dS and dE then
--            local comp = data:sub(dS, dE)
--            local newData = data:gsub("<CameraBoundComponent[^<>]*>%s*</CameraBoundComponent>", ""):gsub("<CameraBoundComponent[^<>]*>", "")
--            ModTextFileSetContent(file, newData)
--
--            local enabled = (comp:match('enabled%s*=%s*"([01])"') == "1") or true
--            local dist = (tonumber(comp:match('distance%s*=%s*"([0-9]+)"'))) or 250
--            local dist_respawn = (tonumber(comp:match('distance_border%s*=%s*"([0-9]+)"'))) or 20
--            local max_count = (tonumber(comp:match('max_count%s*=%s*"([0-9]+)"'))) or 10
--            local freeze_on_distance_kill = (comp:match('freeze_on_distance_kill%s*=%s*"([01])"') == "1") or 1
--            local freeze_on_max_count_kill = (comp:match('freeze_on_max_count_kill%s*=%s*"([01])"') == "1") or 1
--
--            Server.entityCameraBindings[file] = {
--                enabled = enabled,
--                dist = dist,
--                dist_respawn = dist_respawn,
--                max_count = max_count,
--                freeze_on_distance_kill = freeze_on_distance_kill,
--                freeze_on_max_count_kill = freeze_on_max_count_kill
--            }
--        end
--    end
--    local function patchModTree(path)
--        Logger.debug(Logger.channels.initialize, ("Patching dir %s"):format(path))
--        --- Works on windows only
--        for dir in io.popen(('dir "%s" /b'):format(fu.ReplacePathSeparator(rootNoitaPath .. path))):lines() do
--            local file = path .. "/" ..  dir
--            if fu.IsDirectory(rootNoitaPath .. file) then
--                -- Ignore git folders
--                local s, e = file:find("%.git$")
--                if s and e then
--
--                else
--                    patchModTree(file)
--                end
--            else
--                local s, e = file:find("%.xml$")
--                if s and e then
--                    patchXMLFile(file)
--                end
--            end
--        end
--    end
--    local enabledMods = ModGetActiveModIDs()
--    for i=1, #enabledMods do
--        local v = enabledMods[i]
--        if v ~= "noita-mp" then
--            patchModTree("mods/" .. v)
--        end
--    end
--    local filesToPatch = dofile("mods/noita-mp/files/scripts/init/vanillaFilesToPatch.lua")
--    for i=1, #filesToPatch do patchXMLFile(filesToPatch[i]) end
--    Logger.info(Logger.channels.initialize, ("Finished patching XML files. Took %sms."):format(os.time() - timer))
--end
