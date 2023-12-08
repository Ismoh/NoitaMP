-- Disable log channel testing in Noita
if BaabInstruction then
    ModSettingSet("noita-mp.log_level_testing", "off")
end

--- Imports by dofile, dofile_once and require
dofile("mods/noita-mp/files/scripts/init/init_.lua")

local np = {}
if not _G.isTestLuaContext then
    -- Need to be initialized before everything else, otherwise Noita will crash
    np = require("noitapatcher")
end

-- Check if we wan't to debug the mod
-- if DebugGetIsDevBuild() then
--     if not lldebugger then
--         lldebugger = require("lldebugger") --error("Unable to load debugger!", 2)
--     end
--     lldebugger.start()
--     lldebugger.pullBreakpoints()
-- end
lldebugger = nil

-- Initialize default server
local server = require("Server")
    .new(nil, nil, nil, nil, nil, nil, np)

-- Initialize default client
local client = require("Client")
    .new(nil, nil, nil, nil, server, np)
-- Update client reference
server.entityUtils.client = client
server.globalsUtils.client = client
server.nuidUtils.client = client

-- Cache other classes
local customProfiler = server.customProfiler or error("customProfiler is nil!")
local entityUtils = server.entityUtils or error("entityUtils is nil!")
local entityCache = server.entityCache or error("entityCache is nil!")
local fileUtils = server.fileUtils or error("fileUtils is nil!")
local guidUtils = server.guidUtils or error("guidUtils is nil!")
local minaUtils = server.minaUtils or error("minaUtils is nil!")
local networkVscUtils = server.networkVscUtils or error("networkVscUtils is nil!")
local noitaComponentUtils = server.noitaComponentUtils or error("noitaComponentUtils is nil!")
local noitaMpSettings = server.noitaMpSettings or error("noitaMpSettings is nil!")
local noitaPatcherUtils = server.noitaPatcherUtils or error("noitaPatcherUtils is nil!")
local nuidUtils = server.nuidUtils or error("nuidUtils is nil!")
local utils = server.utils or error("utils is nil!")
local logger = server.logger or error("logger is nil!")

---@type NativeEntityMap
local nativeEntityMap = require("lua_noitamp_native")

local gui = require("Gui"):new(nil, server, client, customProfiler, guidUtils, minaUtils, noitaMpSettings)
-- Update gui reference
server.noitaMpSettings.gui = gui
client.noitaMpSettings.gui = gui

if jit.version_num == 20100 then
    jit.p = require("jit.p")
    jit.p.outPath = ("%s/jit_profiler"):format(server.fileUtils:GetDesktopDirectory())
    jit.p.outFile = "jit.p"
    jit.p.mode = "af50si1"
    server.fileUtils:MkDir(("%s/jit_profiler"):format(server.fileUtils:GetAbsoluteDirectoryPathOfNoitaMP(server.noitaMpSettings)))
    --jit.p.start(jit.p.mode, ("%s/%s.log"):format(jit.p.outPath, jit.p.outFile))
end

logger:debug(logger.channels.initialize, "Starting to load noita-mp init.lua..")

--- Stuff needs to be executed before anything else
--fileUtils:SetAbsolutePathOfNoitaRootDirectory(noitaMpSettings)
noitaMpSettings:clearAndCreateSettings()

-- Is used to stop Noita pausing game, when focus is gone (tab out game)
ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")

local saveSlotsLastModifiedBeforeWorldInit = fileUtils:GetLastModifiedSaveSlots()


if not EntitiesGetMaxID then -- TODO: REMOVE when Noita main branch was updated!
    EntitiesGetMaxID = function()
        return entityUtils.previousHighestAliveEntityId + 1024
    end
end

--local guesses = 1
--- Make sure this is only be executed once in OnWorldPREUpdate!
local function OnEntityLoaded()
    --for guessEntityId = entityUtils:previousHighestAliveEntityId, entityUtils:previousHighestAliveEntityId + 1024, 1 do
    for guessEntityId = entityUtils.previousHighestAliveEntityId, EntitiesGetMaxID(), 1 do
        local entityId = guessEntityId
        local filename = nil
        if EntityGetIsAlive(entityId) then
            filename = EntityGetFilename(entityId)
        end
        while EntityGetIsAlive(entityId)
            and entityId > entityUtils.previousHighestAliveEntityId
            and not table.contains(entityUtils.exclude.byFilename, filename)
        do
            if entityId > entityUtils.previousHighestAliveEntityId then
                entityUtils.previousHighestAliveEntityId = entityId
            end

            local rootEntity = EntityGetRootEntity(entityId) or entityId

            if EntityGetIsAlive(rootEntity) then
                if rootEntity > entityUtils.previousHighestAliveEntityId then
                    entityUtils.previousHighestAliveEntityId = rootEntity
                end

                local serialisedString = np.SerializeEntity(rootEntity)
                if not nativeEntityMap.getEntityIdBySerializedString(serialisedString) then
                    nativeEntityMap.setMappingOfEntityIdToSerialisedString(serialisedString, rootEntity)
                    local hasNuid, nuid = networkVscUtils:hasNuidSet(rootEntity)
                    if not hasNuid and server:amIServer() then
                        nuid = nuidUtils:getNextNuid()
                    end
                    networkVscUtils:addOrUpdateAllVscs(rootEntity, minaUtils:getLocalMinaName(), minaUtils:getLocalMinaGuid(), nuid)
                    noitaComponentUtils:setNetworkSpriteIndicatorStatus(rootEntity, "processed")
                end
            end
            entityId = entityUtils.previousHighestAliveEntityId + 1
        end
    end
end

--- When connecting the first time to a server, the server will send the servers' seed to the client.
--- Then the client restarts, empties his selected save slot, to be able to generate the correct world,
--- with the servers seed.
local function setSeedIfConnectedSecondTime()
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))
    logger:debug(logger.channels.initialize, ("Servers world seed = %s"):format(seed))
    if seed and seed > 0 then
        if DebugGetIsDevBuild() then
            utils:sleep(5) -- needed to be able to attach debugger again
        end

        local saveSlotMetaDirectory = ModSettingGet("noita-mp.saveSlotMetaDirectory")
        if saveSlotMetaDirectory then
            fileUtils:RemoveContentOfDirectory(saveSlotMetaDirectory)
        else
            error("Unable to emptying selected save slot!", 2)
        end

        SetWorldSeed(seed)
        client:connect(nil, nil, 1)
    end
end


function OnModPreInit()
    setSeedIfConnectedSecondTime()
    print(("NoitaMP %s"):format(fileUtils:GetVersionByFile()))
    OnEntityLoaded()
end

function OnWorldInitialized()
    logger:debug(logger.channels.initialize, "OnWorldInitialized()")
    OnEntityLoaded()

    local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
    logger:debug(logger.channels.initialize, "make_zip = " .. tostring(make_zip))
    if make_zip then
        local archive_name    = "server_save06_" .. os.date("%Y-%m-%d_%H-%M-%S")
        local destination     = fileUtils:GetAbsoluteDirectoryPathOfNoitaMP() .. pathSeparator .. "_"
        local archive_content = fileUtils:Create7zipArchive(archive_name .. "_from_server",
            fileUtils:GetAbsoluteDirectoryPathOfSave06(), destination)
        local msg             = ("init.lua | Server savegame [%s] was zipped with 7z to location [%s]."):format(
            archive_name, destination)
        logger:debug(logger.channels.initialize, msg)
        GamePrint(msg)
        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", false, false) -- automatically start the server again
    end
end

function OnPlayerSpawned(player_entity)
    logger:info(logger.channels.initialize, ("Player spawned with entityId = %s!"):format(player_entity))
    OnEntityLoaded()

    if utils:isEmpty(minaUtils:getLocalMinaGuid()) then
        minaUtils:setLocalMinaGuid(guidUtils:generateNewGuid())
    end

    minaUtils:setLocalMinaName(tostring(noitaMpSettings:get("noita-mp.nickname", "string")))
    minaUtils:setLocalMinaGuid(tostring(noitaMpSettings:get("noita-mp.guid", "string")))

    local spawnX, spawnY = EntityGetTransform(player_entity)
    networkVscUtils:addOrUpdateAllVscs(player_entity, minaUtils:getLocalMinaName(), minaUtils:getLocalMinaGuid(), nil, spawnX, spawnY)

    if not GameHasFlagRun("nameTags_script_applied") then
        GameAddFlagRun("nameTags_script_applied")
        EntityAddComponent2(player_entity,
            "LuaComponent",
            {
                script_source_file    = "mods/noita-mp/files/scripts/noita-components/name_tags.lua",
                execute_every_n_frame = 1,
            })
    end
end

function OnPausePreUpdate()
    local startFrameTime = GameGetRealWorldTimeSinceStarted()
    OnEntityLoaded()
    server:preUpdate(startFrameTime)
    client:preUpdate(startFrameTime)
end

--- PreUpdate of world
function OnWorldPreUpdate()
    -- if not jit.p.isProfiling then
    if jit.version_num == 20100 then
        --jit.p.start(jit.p.mode, ("%s/%s.log"):format(jit.p.outPath, jit.p.outFile))
    end
    -- end

    local startFrameTime = GameGetRealWorldTimeSinceStarted()

    -- if DebugGetIsDevBuild() and lldebugger then
    --     lldebugger.pullBreakpoints()
    -- end

    OnEntityLoaded()

    if utils:isEmpty(minaUtils:getLocalMinaName()) or utils:isEmpty(minaUtils:getLocalMinaGuid()) then
        gui:setShowMissingSettings(true)
    end

    gui:update()

    local localMinaEntityId = minaUtils:getLocalMinaEntityId()
    if not localMinaEntityId or localMinaEntityId <= 0 then
        return
    end

    entityUtils:addOrChangeDetectionRadiusDebug(localMinaEntityId)

    if not _G.saveSlotMeta then
        local saveSlotsLastModifiedAfterWorldInit = fileUtils:GetLastModifiedSaveSlots()
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
                    ModSettingSetNextValue("noita-mp.saveSlotMetaDirectory", _G.saveSlotMeta.dir, false)
                    logger:info(logger.channels.initialize, ("Save slot found in '%s'"):format(utils:pformat(_G.saveSlotMeta)))
                end
            end
        end
    end

    server:preUpdate(startFrameTime)
    client:preUpdate(startFrameTime)

    if collectgarbage("count") >= 102412345.0 then
        GamePrintImportant("Memory Usage", ("Forcing garbage collection because memory usage is above %sMB."):format(collectgarbage("count") / 1024))
        collectgarbage("collect")
    end
    GamePrint("MemUsage " .. collectgarbage("count") / 1024 .. " MB")

    --print("jit.profile " .. jit.profile.dumpstack("l\n", 10))
end

function OnWorldPostUpdate()
    OnEntityLoaded()

    if entityCache:size() >= 500 then
        -- TODO: add distance check to minas
        --for i = 1, #EntityCache.cache do
        entityCache:delete(entityCache.cache[1])
        --end
    end
    if jit.version_num == 20100 then
        -- if jit.p.isProfiling then
        --jit.p.stop()
        -- end
    end
end
