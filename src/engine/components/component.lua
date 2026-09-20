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
    local init = rawget(cls, "init")
    if init then init(obj, ...) end
    return obj
end


return Component