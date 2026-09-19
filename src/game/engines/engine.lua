local require = require("src.tools.require_relative")

---@class ObjectEngine
local ObjectEngine = {}
ObjectEngine.__index = ObjectEngine

---Создаёт абстрактный двигатель
---@return ObjectEngine
function ObjectEngine.create(cls,...)
    local obj = setmetatable({},  cls)
    
    return obj
end

function ObjectEngine:update(...)
	
end

---Вычисляет текущую скорость объекта.
---@param face number Текущее направление объекта в радианах.
---@return number vx dx/dt
---@return number vy dy/dt
---@return number omega angular_velocity dface/dt
function ObjectEngine:get_velocity(...)
    local vx = 0
    local vy = 0
    local omega = 0
    return vx, vy, omega
end


return ObjectEngine