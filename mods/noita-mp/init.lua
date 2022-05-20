dofile("mods/noita-mp/files/scripts/init/init_.lua")
local render_ezgui = dofile_once("mods/noita-mp/files/lib/external/ezgui/EZGUI.lua").init("mods/noita-mp/files/lib/external/ezgui")

local fu = require("file_util")

fu.SetAbsolutePathOfNoitaRootDirectory()

ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")
logger:debug(nil, "init.lua | loading world seed magic number xml file.")
local world_seed_magic_numbers_path = fu.GetAbsoluteDirectoryPathOfMods() .. "/files/tmp/magic_numbers/world_seed.xml"
if fu.Exists(world_seed_magic_numbers_path) then
    GamePrint("init.lua | Loading " .. world_seed_magic_numbers_path)
    ModMagicNumbersFileAdd(world_seed_magic_numbers_path)
else
    GamePrint("init.lua | Unable to load " .. world_seed_magic_numbers_path)
end

fu.Find7zipExecutable()

function OnModPreInit()
    fu.createCallbacksForSaveSlotWatcher()

    EntityUtils.modifyPhysicsEntities()

    --_G.cache = {}
    --_G.cache.nuids = {} -- _G.cache.nuids[nuid] = { entity_id, component_id_username, component_id_guid, component_id_nuid }
    --_G.cache.entity_ids_without_nuids = {} -- _G.cache.entity_ids_without_nuids[entity_id] = { entity_id, component_id_username, component_id_guid, component_id_nuid }

    _G.whoAmI = function()
        if _G.Server:amIServer() then
            return "SERVER"
        end
        if _G.Client:amIClient() then
            return "CLIENT"
        end
        return nil
    end

    -- the seed is set when first time connecting to a server, otherwise 0
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))

    if not seed and seed > 0 then
        SetWorldSeed(seed)
        _G.Client:connect()
    end
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
    -- local component_id = em:AddNetworkComponentToEntity(player_entity, util.getLocalOwner(), -1)

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

local function drawGui()
    local function playerList()
        local clients = {}
        if _G.Server.amIServer() then
            clients = _G.Server.clients
            for i = 1, #clients do
                clients[i].rtt = clients[i]:getRoundTripTime()
            end
        else
            clients = { name = _G.Client.name, rtt = _G.Client:getRoundTripTime() }
        end

        local playerListData = {
            version = "0.1.0 - alpha + 1", --fu.ReadFile(".version")
            ip = _G.Server:getAddress(),
            port = _G.Server:getPort(),
            start = function()
                _G.Server.start(nil, nil)
            end,
            clients = clients,
            kick = function(data, element, arg1)
                _G.Server.kick(arg1)
            end,
            ban = function(data, element, arg1)
                _G.Server.ban(arg1)
            end
        }
        render_ezgui(50, 50, "mods/noita-mp/files/data/ezgui/PlayerList.xml", playerListData)
    end

    if not show then
        show = false
    end

    local function drawShowGui()
        local showGuiData = {
            toggleShow = function(data, element)
                show = not show
            end,
            showText = ("[%s]"):format(show),
        }
        render_ezgui(50, 50, "mods/noita-mp/files/data/ezgui/PlayerList.xml", showGuiData)
    end

    drawShowGui()

    if show then
        playerList()
    end
end

function OnWorldPreUpdate()
    UpdateLogLevel()

    _G.Server.update()
    _G.Client.update()

    dofile("mods/noita-mp/files/scripts/ui.lua")

    drawGui()
end

function UpdateLogLevel()
    -- if _G.logger then
    --     local currentLogLevel = logger:getLevel()
    --     local setting_log_level = tostring(ModSettingGetNextValue("noita-mp.log_level")) -- "debug, warn, info, error" or "warn, info, error" or "info, error"
    --     local levels = setting_log_level:upper():split(",")
    --     local newLogLevel = levels[1]
    --     if currentLogLevel ~= newLogLevel then
    --         logger:setLevel(newLogLevel)
    --     end
    -- end
end
