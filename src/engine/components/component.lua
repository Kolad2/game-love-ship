---@class Component
---@field root GameObject|nil
local Component = {}
Component.__index = Component


---Создаёт компонент.
---@return Component
function Component.create(cls)
    ---@type Component
    local obj = setmetatable({}, cls)

    obj.root = nil

    return obj
end


---Обновляет компонент.
---@param dt number
function Component:update(dt)
end


return Component