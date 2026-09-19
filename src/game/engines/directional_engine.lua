local require = require("src.tools.require_relative")
local ObjectEngine = require(".engine")


---@class DirectionalEngine : ObjectEngine
local DirectionalEngine = setmetatable({}, ObjectEngine)
DirectionalEngine.__index = DirectionalEngine

---Создаёт абстрактный двигатель
---@return DirectionalEngine
function DirectionalEngine.create(cls, sx, sy)
    local obj = setmetatable({},  cls)
    obj.sx = sx
    obj.sy = sy
    return obj
end

function DirectionalEngine:update(...)
	---pass
end

---Вычисляет текущую скорость объекта.
---@param face number Текущее направление объекта в радианах.
---@return number vx dx/dt
---@return number vy dy/dt
---@return number omega angular_velocity dface/dt
function DirectionalEngine:get_velocity(...)
    local vx = self.sx
    local vy = self.sy
    local omega = 0
    return vx, vy, omega
end


return DirectionalEngine