---NuidUtils for getting the current network unique identifier
---@class NuidUtils
local NuidUtils = {

    --[[ Attributes ]]

    counter   = 0,
    xmlParsed = false,
}

function NuidUtils:getNextNuid()
    if self.client:amIClient() then
        error("Unable to get next nuid, because looks like you aren't a server?!", 2)
    end

    -- Are there any nuids saved in globals, if so get the highest nuid?
    if not self.xmlParsed then
        local worldStateXmlAbsPath = self.fileUtils:GetAbsDirPathOfWorldStateXml(_G.saveSlotMeta.dir)
        if not self.worldStateXmlFileExists then
            self.worldStateXmlFileExists = self.fileUtils:Exists(worldStateXmlAbsPath)
            local f                      = io.open(worldStateXmlAbsPath, "r")
            if f then
                local xml = self.nxml.parse(f:read("*a"))
                f:close()

                for v in xml:first_of("WorldStateComponent"):first_of("lua_globals"):each_of("E") do
                    if string.contains(v.attr.key, "nuid") then
                        local nuid = self.globalUtils:parseXmlValueToNuidAndEntityId(v.attr.key, v.attr.value)
                        if nuid ~= nil then
                            nuid = tonumber(nuid) or -1
                            if nuid > self.counter then
                                self.counter = nuid
                            end
                        end
                    end
                end
                self.logger:info(self.logger.channels.nuid,
                    ("Loaded nuids after loading a savegame. Latest nuid from world_state.xml aka Globals = %s."):format(self.counter))
            end
        end
        self.xmlParsed = true
    end
    self.counter = self.counter + 1
    return self.counter
end

---If an entity died, the associated nuid-entityId-set will be updated with entityId multiplied by -1.
---If this happens, KillEntityMsg has to be send by network.
---@return table<number, number>
function NuidUtils:getEntityIdsByKillIndicator()
    local deadNuids            = self.globalUtils:getDeadNuids()
    local worldStateXmlAbsPath = self.fileUtils:GetAbsDirPathOfWorldStateXml(_G.saveSlotMeta.dir)
    if not self.worldStateXmlFileExists then
        self.worldStateXmlFileExists = self.fileUtils:Exists(worldStateXmlAbsPath)
    end
    if self.worldStateXmlFileExists then
        local fileContent = self.fileUtils:ReadFile(worldStateXmlAbsPath, "*a")
        local xml         = self.nxml.parse(fileContent)

        for v in xml:first_of("WorldStateComponent"):first_of("lua_globals"):each_of("E") do
            if string.contains(v.attr.key, "nuid") then
                local nuid, entityId = self.globalUtils:parseXmlValueToNuidAndEntityId(v.attr.key, v.attr.value)
                if not entityId or math.sign(entityId) <= 0 then
                    table.insertIfNotExist(deadNuids, nuid)
                end
            end
        end
    end
    return deadNuids
end

---NuidUtils constructor
---@param nuidUitlsObject NuidUtils|nil optional
---@param client Client required
---@param customProfiler CustomProfiler required
---@param fileUtils FileUtils|nil optional
---@param globalsUtils GlobalsUtils|nil optional
---@param logger Logger|nil optional
---@param nxml nxml|nil optional
---@return NuidUtils
function NuidUtils:new(nuidUitlsObject, client, customProfiler, fileUtils, globalsUtils, logger, nxml)
    ---@class NuidUtils
    nuidUitlsObject = setmetatable(nuidUitlsObject or self, NuidUtils)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not nuidUitlsObject.client then
        ---@type Client
        nuidUitlsObject.client = client or error("NuidUtils:new requires a Client object", 2)
    end

    if not nuidUitlsObject.customProfiler then
        ---@type CustomProfiler
        nuidUitlsObject.customProfiler = customProfiler or error("NuidUtils:new requires a CustomProfiler object", 2)
    end

    if not nuidUitlsObject.logger then
        ---@type Logger
        nuidUitlsObject.logger = logger or require("Logger"):new(nil, nuidUitlsObject.customProfiler)
    end

    if not nuidUitlsObject.fileUtils then
        ---@type FileUtils
        nuidUitlsObject.fileUtils = fileUtils or
            require("FileUtils"):new(nil, nuidUitlsObject.customProfiler, nuidUitlsObject.logger,
                nuidUitlsObject.customProfiler.noitaMpSettings, nil, nuidUitlsObject.customProfiler.utils)
    end

    if not nuidUitlsObject.globalUtils then
        ---@type GlobalsUtils
        nuidUitlsObject.globalUtils = globalsUtils or
            require("GlobalsUtils"):new(nil, nuidUitlsObject.customProfiler, nuidUitlsObject.logger,
                client, nuidUitlsObject.customProfiler.utils)
    end

    if not nuidUitlsObject.nxml then
        nuidUitlsObject.nxml = nxml or require("nxml")
    end

    --[[ Attributes ]]

    return nuidUitlsObject
end

return NuidUtils
