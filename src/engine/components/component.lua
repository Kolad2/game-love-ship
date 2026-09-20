---@class Component
---@field root GameObject|nil
local Component = {}
Component.__index = Component


function Component:init()
    self.root = nil
end


---Обновляет компонент.
---@param dt number
function Component:update(dt) end

---@generic T : Component
---@param cls T
---@return T
function Component.create(cls, ...)
    local obj = setmetatable({}, cls)
    obj:init(...)
    return obj
end


return Component