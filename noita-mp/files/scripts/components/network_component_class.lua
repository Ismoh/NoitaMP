-- Meta class
NetworkComponent = {
    owner = {}, -- this is { username, guid } for each specific client/server
    nuid = nil, -- network unique identifier to find an entity by nuid
    local_entity_id = nil, -- noitas entity id of the owner who created this network component
    component_id = nil, -- noitas component_id only valid for the owner who created the component    
}

-- statics
NetworkComponent.name = "network_component_class"
NetworkComponent.field_name = "value_string"

----------- Constructor

--- Creates a new table of NetworkComponent
--- @param owner table { username, guid } GUID of server OR client, to be able to check, if this entity needs to be 'destroyed' or respawned.
--- @param nuid number NUID to find entity by network component id
--- @param local_entity_id number Noitas entity ID, which is the id of the owner, who created this entity
--- @param component_id number Noitas component ID, which is the id of the network component
--- @return table NetworkComponent Returns a new 'instance' of NetworkComponent. It's only a table :)
function NetworkComponent:new(owner, nuid, local_entity_id, component_id)
    local network_component = {}
    setmetatable(network_component, self)
    self.__index = self
    self.owner = owner or nil
    self.nuid = nuid or nil
    self.local_entity_id = local_entity_id or nil
    self.component_id = component_id or nil
    return network_component
end

----------- Getter / Setter

function NetworkComponent:getNoitaComponentId()
    return self.component_id
end

---@return string self.owner Returns the guid of the owner.
function NetworkComponent:getOwner()
    return self.owner
end

function NetworkComponent:getNuid()
    return self.nuid
end

-----------

--- Provides a serialisable table by its own fields
--- @return table t Returns itself as a data table, without any functions, to be able to be de-/serialised.
function NetworkComponent:toSerialisableTable()
    local t = {
        owner = {
            self.owner.username,
            self.owner.guid
        },
        nuid = self.nuid,
        local_entity_id = self.local_entity_id,
        component_id = self.component_id
    }
    return t
end

return NetworkComponent
