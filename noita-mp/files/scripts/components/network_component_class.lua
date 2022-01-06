
-- Meta class
NetworkComponent = {
    noita_component_id = nil,
    owner = nil,
    position = {},
    health = nil,
}

--- Creates a new table of NetworkComponent
--- @param o table Used for inheritance.
--- @param noita_component_id number Component ID used by Noita API
--- @param owner string GUID of server OR client, to be able to check, if this entity needs to be 'destroyed' or respawned.
--- @param postion table { x = 1, y = 2 }
--- @param health number 38 hp left
--- @return table NetworkComponent Returns a new 'instance' of NetworkComponent. It's only a table :)
function NetworkComponent:new(o, noita_component_id, owner, postion, health)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.noita_component_id = noita_component_id or nil
    self.owner = owner or nil
    self.position = postion or nil
    self.health = health or nil
    return o
end

--- Provides a serialisable table by its own fields
--- @return table t Returns itself as a data table, without any functions, to be able to be de-/serialised.
function NetworkComponent:toSerialisableTable()
    local t = {
        noita_component_id = self.noita_component_id,
        owner = self.owner,
        position = self.position,
        health = self.health
    }
    return t
end

return NetworkComponent