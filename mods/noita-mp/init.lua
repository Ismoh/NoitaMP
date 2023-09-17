-- Disable log channel testing in Noita
if BaabInstruction then
    ModSettingSet("noita-mp.log_level_testing", "off")
end

--- Imports by dofile, dofile_once and require

dofile("mods/noita-mp/files/scripts/init/init_.lua")
local np = require("noitapatcher") -- Need to be initialized before everything else, otherwise Noita will crash

local guiI = require("Gui").new()

local noitaMpSettings = require("NoitaMpSettings")
    :new(nil, nil, guiI, nil, nil, nil, nil, nil, nil)

local customProfiler = require("CustomProfiler")
    :new(noitaMpSettings.customProfiler, noitaMpSettings.fileUtils, noitaMpSettings, nil, nil, noitaMpSettings.utils, noitaMpSettings.winapi)
customProfiler.testNumber = 10
customProfiler.testString = "reset"

local Client = require("Client")
local client = Client:new()

local entityUtils = require("EntityUtils"):new(nil, require("Client"):new(), customProfiler)
local FileUtils = require("FileUtils")
local Logger = require("Logger")
local MinaUtils = require("MinaUtils")
local NoitaComponentUtils = require("NoitaComponentUtils")

local noitaPatcherUtils = require("NoitaPatcherUtils"):new(np)
local Utils = require("Utils")

Logger.debug(Logger.channels.initialize, "Starting to load noita-mp init.lua..")

--- Stuff needs to be executed before anything else
FileUtils.SetAbsolutePathOfNoitaRootDirectory()
NoitaMpSettings.clearAndCreateSettings()
-- Is used to stop Noita pausing game, when focus is gone (tab out game)
ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")
--FileUtils.Find7zipExecutable()
local saveSlotsLastModifiedBeforeWorldInit = FileUtils.GetLastModifiedSaveSlots()

--- NoitaMP functions

if not EntitiesGetMaxID then -- TODO: REMOVE when Noita main branch was updated!
    EntitiesGetMaxID = function()
        return EntityUtils.previousHighestAliveEntityId + 1024
    end
end

--local guesses = 1
--- Make sure this is only be executed once in OnWorldPREUpdate!
local function OnEntityLoaded()
    local cpc = customProfiler:start("EntityUtils.OnEntityLoaded")

    --for guessEntityId = EntityUtils.previousHighestAliveEntityId, EntityUtils.previousHighestAliveEntityId + 1024, 1 do
    for guessEntityId = EntityUtils.previousHighestAliveEntityId, EntitiesGetMaxID(), 1 do
        local entityId = guessEntityId
        while EntityGetIsAlive(entityId) do
            if entityId > EntityUtils.previousHighestAliveEntityId then
                EntityUtils.previousHighestAliveEntityId = entityId
            end

            -- DEBUG ONLY
            local debugEntityId = FileUtils.ReadFile(("%s%s%s"):format(
                FileUtils.GetAbsoluteDirectoryPathOfNoitaMP(), pathSeparator, "debugOnEntityLoaded"))
            if not Utils.IsEmpty(debugEntityId) then
                if entityId >= tonumber(debugEntityId) then
                    local debug = true
                end
            end

            local rootEntity = EntityGetRootEntity(entityId) or entityId

            if EntityGetIsAlive(rootEntity) then
                if rootEntity > EntityUtils.previousHighestAliveEntityId then
                    EntityUtils.previousHighestAliveEntityId = rootEntity
                end

                if not NoitaComponentUtils.hasInitialSerializedEntityString(rootEntity) then
                    local initialSerializedEntityString = noitaPatcherUtils.serializeEntity(rootEntity)
                    local success = NoitaComponentUtils.setInitialSerializedEntityString(rootEntity, initialSerializedEntityString)

                    if not success then
                        error("Unable to add serialized string!", 2)
                    else
                        --print(("Added iSES %s[...] to %s"):format(string.sub(initialSerializedEntityString, 1, 5), rootEntity))
                    end
                    -- free memory
                    initialSerializedEntityString = nil

                    -- Add NoitaMP Variable Storage Components
                    local hasNuid, nuid = NetworkVscUtils.hasNuidSet(rootEntity)
                    if not hasNuid and Server.amIServer() then
                        nuid = NuidUtils.getNextNuid()
                    end
                    local spawnX, spawnY = EntityGetTransform(rootEntity)
                    NetworkVscUtils.addOrUpdateAllVscs(rootEntity, MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(), nuid, spawnX, spawnY)

                    NoitaComponentUtils.setNetworkSpriteIndicatorStatus(rootEntity, "processed")
                end
            end
            entityId = EntityUtils.previousHighestAliveEntityId + 1
        end
    end
    customProfiler.stop("EntityUtils.OnEntityLoaded", cpc)
end

--- When connecting the first time to a server, the server will send the servers' seed to the client.
--- Then the client restarts, empties his selected save slot, to be able to generate the correct world,
--- with the servers seed.
local function setSeedIfConnectedSecondTime()
    local cpc  = customProfiler.start("ModSettingGet")
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))
    customProfiler.stop("ModSettingGet", cpc)
    Logger.debug(Logger.channels.initialize, ("Servers world seed = %s"):format(seed))
    if not seed and seed > 0 then
        if DebugGetIsDevBuild() then
            Utils.Sleep(5) -- needed to be able to attach debugger again
        end

        local cpc1                  = customProfiler.start("ModSettingGet")
        local saveSlotMetaDirectory = ModSettingGet("noita-mp.saveSlotMetaDirectory")
        customProfiler.stop("ModSettingGet", cpc1)
        if saveSlotMetaDirectory then
            FileUtils.RemoveContentOfDirectory(saveSlotMetaDirectory)
        else
            error("Unable to emptying selected save slot!", 2)
        end

        SetWorldSeed(seed)
        _G.Client.connect(nil, nil, 1)
    end
end


--- Noita API callback functions

function OnModPreInit()
    setSeedIfConnectedSecondTime()
    print(("NoitaMP %s"):format(FileUtils.GetVersionByFile()))
    OnEntityLoaded()
end

function OnWorldInitialized()
    local cpc = customProfiler.start("init.OnWorldInitialized")
    Logger.debug(Logger.channels.initialize, "OnWorldInitialized()")
    OnEntityLoaded()

    local cpc1     = customProfiler.start("ModSettingGet")
    local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
    customProfiler.stop("ModSettingGet", cpc1)
    Logger.debug(Logger.channels.initialize, "make_zip = " .. tostring(make_zip))
    if make_zip then
        local archive_name    = "server_save06_" .. os.date("%Y-%m-%d_%H-%M-%S")
        local destination     = FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. pathSeparator .. "_"
        local archive_content = FileUtils.Create7zipArchive(archive_name .. "_from_server",
            FileUtils.GetAbsoluteDirectoryPathOfSave06(), destination)
        local msg             = ("init.lua | Server savegame [%s] was zipped with 7z to location [%s]."):format(
            archive_name, destination)
        Logger.debug(Logger.channels.initialize, msg)
        GamePrint(msg)
        local cpc1 = customProfiler.start("ModSettingSetNextValue")
        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", false, false) -- automatically start the server again
        customProfiler.stop("ModSettingSetNextValue", cpc1)
    end
    customProfiler.stop("init.OnWorldInitialized", cpc)
end

function OnPlayerSpawned(player_entity)
    local cpc = customProfiler.start("init.OnPlayerSpawned")
    Logger.info(Logger.channels.initialize, ("Player spawned with entityId = %s!"):format(player_entity))
    OnEntityLoaded()

    if Utils.IsEmpty(MinaUtils.getLocalMinaGuid()) then
        MinaUtils.setLocalMinaGuid(GuidUtils:getGuid())
    end

    MinaUtils.setLocalMinaName(NoitaMpSettings.get("noita-mp.nickname", "string"))
    MinaUtils.setLocalMinaGuid(NoitaMpSettings.get("noita-mp.guid", "string"))

    local spawnX, spawnY = EntityGetTransform(player_entity)
    NetworkVscUtils.addOrUpdateAllVscs(player_entity, MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(), nil, spawnX, spawnY)

    if not GameHasFlagRun("nameTags_script_applied") then
        GameAddFlagRun("nameTags_script_applied")
        EntityAddComponent2(player_entity,
            "LuaComponent",
            {
                script_source_file    = "mods/noita-mp/files/scripts/noita-components/name_tags.lua",
                execute_every_n_frame = 1,
            })
    end
    customProfiler.stop("init.OnPlayerSpawned", cpc)
end

function OnPausePreUpdate()
    local startFrameTime = GameGetRealWorldTimeSinceStarted()
    local cpc = customProfiler.start("init.OnPausePreUpdate")
    OnEntityLoaded()
    Server.update(startFrameTime)
    Client.update(startFrameTime)
    customProfiler.stop("init.OnPausePreUpdate", cpc)
end

--- PreUpdate of world
function OnWorldPreUpdate()
    local startFrameTime = GameGetRealWorldTimeSinceStarted()
    local cpc = customProfiler.start("init.OnWorldPreUpdate")
    OnEntityLoaded()

    if Utils.IsEmpty(MinaUtils.getLocalMinaName()) or Utils.IsEmpty(MinaUtils.getLocalMinaGuid()) then
        guiI.setShowMissingSettings(true)
    end

    guiI.update()

    --if profiler.isRunning() and os.clock() >= 120 then
    --    FileUtils.createProfilerLog()
    --end

    if not MinaUtils.getLocalMinaInformation().entityId then
        return
    end

    EntityUtils.addOrChangeDetectionRadiusDebug(MinaUtils.getLocalMinaInformation().entityId)

    if not _G.saveSlotMeta then
        local saveSlotsLastModifiedAfterWorldInit = FileUtils.GetLastModifiedSaveSlots()
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
                    local cpc1      = customProfiler.start("ModSettingSetNextValue")
                    ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta.dir, false)
                    customProfiler.stop("ModSettingSetNextValue", cpc1)
                    Logger.info(Logger.channels.initialize,
                        ("Save slot found in '%s'"):format(Utils.pformat(_G.saveSlotMeta)))
                end
            end
        end
    end

    Server.update(startFrameTime)
    Client.update(startFrameTime)
    --ui.update()

    local cpc1 = customProfiler.start("init.OnWorldPreUpdate.collectgarbage.count")
    if collectgarbage("count") >= 250000 then
        local cpc2 = customProfiler.start("init.OnWorldPreUpdate.collectgarbage.collect")
        -- if memory usage is above 250MB, force a garbage collection
        GamePrintImportant("Memory Usage", "Forcing garbage collection because memory usage is above 250MB.")
        customProfiler.stopAll()
        customProfiler.report()
        collectgarbage("collect")
        customProfiler.stop("init.OnWorldPreUpdate.collectgarbage.collect", cpc2)
    end

    customProfiler.stop("init.OnWorldPreUpdate.collectgarbage.count", cpc1)
    customProfiler.stop("init.OnWorldPreUpdate", cpc)
end

function OnWorldPostUpdate()
    local cpc = customProfiler.start("init.OnWorldPostUpdate")
    OnEntityLoaded()

    if EntityCache.size() >= 500 then
        -- TODO: add distance check to minas
        --for i = 1, #EntityCache.cache do
        EntityCache.delete(EntityCache.cache[1])
        --end
    end
    customProfiler.stop("init.OnWorldPostUpdate", cpc)
end
