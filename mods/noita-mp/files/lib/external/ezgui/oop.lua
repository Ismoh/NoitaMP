function make_prototype(superclass, class)
  return {
    __index = function(self, key)
      if key == "InstanceOf" then
        return function(self, instance_of_what)
          if class == instance_of_what then
            return true
          end
          local current_class = class
          while current_class and current_class.__superclass do
            if current_class.__superclass == instance_of_what then
              return true
            else
              current_class = current_class.__superclass
            end
          end
          return current_class == instance_of_what
        end
      elseif rawget(self, key) then
        return rawget(self, key)
      elseif class[key] then
        return class[key]
      else
        -- Walk up the superclass chain until it can't find anymore
        local current_class = class.__superclass
        while current_class do
          if current_class[key] then
            return current_class[key]
          else
            current_class = current_class.__superclass
          end
        end
      end
    end
  }
end

function new_class(name, constructor, superclass)
  local class = {}
  class.__class = class
  class.__classname = name
  class.__superclass = superclass
  class.__call = function(self, ...)
    -- self should always be an instance of the most derived class
    local instance = self
    if self == class then
       -- Create a new instance if it's the top "level"
      instance = {}
      setmetatable(instance, make_prototype(self.__superclass, self.__class))
    end
    if superclass then
      setfenv(constructor, setmetatable({
        super = function(...)
          getmetatable(superclass).__call(instance, ...) -- We want 'self' inside the constructor to be 'instance'
        end,
      }, { __index = _G }))
    end
    constructor(instance, ...)
    -- TODO: Force call of super constructor?
    return instance
  end
  setmetatable(class, class)
  return class
end
