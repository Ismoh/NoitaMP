dofile("mods/noita-mp/files/scripts/util/file_util.lua")

local sock = require "sock"


-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- Meta class
Client = {
    super   = nil,
    address = nil,
    port    = nil
}


-- Derived class method new
function Client:new(o, super, address, port)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.super = super
    self.address = tostring(address)
    self.port = tonumber(port)
    return o
end


function Client:setSettings()
    self.super:setTimeout(320, 50000, 100000)
    self.super:setSchema("worldFiles", { "relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles" })
    self.super:setSchema("worldFilesFinished", { "progress" })
    self.super:setSchema("seed", { "seed" })
    self.super:setSchema("playerState", { "index", "player" })
end


-- Derived class methods
function Client:createCallbacks()
    print("client_class.lua | Creating clients callback functions.")

    self.super:on("connect", function(data)
        print("client_class.lua | Client connected to the server.")
    end)

    self.super:on("worldFiles", function(data)
        if not data or next(data) == nil then
            GamePrint("client_class.lua | Receiving world files from server, but data is nil or empty. " .. tostring(data))
            return
        end

        local rel_dir_path = data.relDirPath
        local file_name = data.fileName
        local file_content = data.fileContent
        local file_index = data.fileIndex
        local amount_of_files = data.amountOfFiles

        local msg = ("client_class.lua | Receiving world file: dir:%s, file:%s, content:%s, index:%s, amount:%s"):format(rel_dir_path, file_name, file_content, file_index, amount_of_files)
        print(msg)
        GamePrint(msg)

        local save00_parent_directory_path = GetAbsoluteDirectoryPathOfParentSave00()

        -- if file_name ~= nil and file_name ~= ""
        -- then -- file in save00 | "" -> directory was sent
        --     WriteBinaryFile(save00_dir .. _G.path_separator .. file_name, file_content)
        -- elseif rel_dir_path ~= nil and file_name ~= ""
        -- then -- file in subdirectory was sent
        --     WriteBinaryFile(save00_dir .. _G.path_separator .. rel_dir_path .. _G.path_separator .. file_name, file_content)
        -- elseif rel_dir_path ~= nil and (file_name == nil or file_name == "")
        -- then -- directory name was sent
        --     MkDir(save00_dir .. _G.path_separator .. rel_dir_path)
        -- else
        --     GamePrint("client_class.lua | Unable to write file, because path and content aren't set.")
        -- end
        local archive_directory = GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. rel_dir_path
        WriteBinaryFile( archive_directory .. _G.path_separator .. file_name, file_content)

        if Exists(GetAbsoluteDirectoryPathOfSave00()) then -- Create backup if save00 exists
            os.execute('cd "' .. GetAbsoluteDirectoryPathOfParentSave00() .. '" && move save00 save00_backup')
        end
        
        Extract7zipArchive(archive_directory, file_name, save00_parent_directory_path)

        if file_index >= amount_of_files then
            self.super:send("worldFilesFinished", { "" .. file_index .. "/" .. amount_of_files })
        end
    end)

    self.super:on("seed", function(data)
        local server_seed = tonumber(data.seed)
        print("client_class.lua | Client got seed from the server. Seed = " .. server_seed)
        ModSettingSet("noita-mp.connect_server_seed", server_seed)

        print("client_class.lua | Creating magic numbers file to set clients world seed and restart the game.")
        WriteFile(GetAbsoluteDirectoryPathOfMods() .. "/files/tmp/magic_numbers/world_seed.xml",
                    [[<MagicNumbers WORLD_SEED="]] .. tostring(server_seed) .. [["/>]])
        --ModTextFileSetContent( GetRelativeDirectoryPathOfMods()
        --    .. "/files/data/magic_numbers.xml", )

        --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
    end)
    
    self.super:on("restart", function(data)
        ForceQuitAndStartNoita()
        --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
    end)

    -- Called when the client disconnects from the server
    self.super:on("disconnect", function(data)
        print("client_class.lua | Client disconnected from the server.")
    end)

    -- see lua-enet/enet.c
    self.super:on("receive", function(data, channel)
        print("client_class.lua | Client received: data = " .. tostring(data) .. ", channel = " .. tostring(channel))
    end)

    -- Custom callback, called whenever you send the event from the server
    self.super:on("hello", function(msg)
        print("client_class.lua | The server replied: " .. msg)
    end)
end


function Client:connect()
    if not self.super then
        print("client_class.lua | Clients super wasn't set. Also refreshing ip and port.")
        local ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        local port = tonumber(ModSettingGet("noita-mp.connect_server_port"))
        print("client_class.lua | Connecting to server on " .. ip .. ":" .. port)

        self.super = sock.newClient(ip, port)
    end

    self:setSettings()
    self:createCallbacks()

    GamePrintImportant( "Client is connecting..", "You are trying to connect to "
        .. self.super:getAddress() .. ":" .. self.super:getPort() .. "!")

    self.super:connect(0)

    --  You can send different types of data
    self.super:send("greeting", "Hello, my name is Inigo Montoya.")
    self.super:send("isShooting", true)
    self.super:send("bulletsLeft", 1)
    self.super:send("position", {
        x = 465.3,
        y = 50,
    })
end


function Client:update()
    if not self.super then
        return -- Client not established
    end

    self.super:update()
end


-- Create a new global object of the server
_G.Client = Client:new()