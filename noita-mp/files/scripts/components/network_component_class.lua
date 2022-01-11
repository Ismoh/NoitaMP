-- Meta class
NetworkComponent = {
    noita_component_id = nil, -- peer(locally) used component id
    owner = nil, -- this is guid for each specific client/server
    nuid = nil, -- network unique identifier to find an entity by nuid
    transform = {x = 1, y = 1, rot = 123},
    health = nil
}

--- Creates a new table of NetworkComponent
--- @param o table Used for inheritance.
--- @param noita_component_id number Component ID used by Noita API
--- @param owner string GUID of server OR client, to be able to check, if this entity needs to be 'destroyed' or respawned.
--- @param nuid number NUID to find entity by network component id
--- @param transform table { x = 1, y = 2, rot = 123 }
--- @param health number 38 hp left
--- @return table NetworkComponent Returns a new 'instance' of NetworkComponent. It's only a table :)
function NetworkComponent:new(o, noita_component_id, owner, nuid, transform, health)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.noita_component_id = noita_component_id or nil
    self.owner = owner or nil
    self.nuid = nuid or nil
    self.transform = transform or nil
    self.health = health or nil
    return o
end

--- Provides a serialisable table by its own fields
--- @return table t Returns itself as a data table, without any functions, to be able to be de-/serialised.
function NetworkComponent:toSerialisableTable()
    local t = {
        noita_component_id = self.noita_component_id,
        owner = self.owner,
        nuid = self.nuid,
        transform = self.transform,
        health = self.health
    }
    return t
end

function NetworkComponent:getNuid()
    return self.nuid
end

return NetworkComponent
