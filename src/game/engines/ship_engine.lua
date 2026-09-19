local require = require("src.tools.require_relative")
local Engine = require(".engine")

---@class ShipEngine : ObjectEngine
---@field controller Controller
---@field speed number
---@field rotation_speed number
local ShipEngine = setmetatable({},Engine)
ShipEngine.__index = ShipEngine


---Создаёт двигатель корабля.
---@param controller Controller
---@return ShipEngine
function ShipEngine.create(cls, controller)
    local obj = setmetatable({},  cls)
    
    obj.controller = controller
    obj.speed = 120
    obj.rotation_speed = math.pi /2
    obj.face = nil
    obj.face_x = nil
    obj.face_y = nil
    
    return obj
end

function ShipEngine:update(face)
	self.face = face
    self.face_x = math.cos(face)
    self.face_y = math.sin(face)
end

---Вычисляет текущую скорость объекта.
---Сам объект не перемещает.
---@param face number Текущее направление объекта в радианах.
---@return number velocity_x dx/dt
---@return number velocity_y dy/dt
---@return number angular_velocity dface/dt
function ShipEngine:get_velocity(face)
    self:update(face)
    
    -- Насколько ввод направлен вперёд и назад.
    local forward_input, turn_input = self:get_frenet_input()
    
    -- Если управление направлено назад,
    -- корабль не летит назад, а разворачивается.
    if forward_input < 0 then
        forward_input = 0

        if turn_input > 0 then
            turn_input = 1
        else
            turn_input = -1
        end
    end
    local alpha_max = math.pi / 6
    local turn_vt = math.abs(turn_input) * math.cos(alpha_max) * 120
    local turn_vn = - turn_input * math.sin(alpha_max) * 120
    
    local vt = forward_input * self.speed + turn_vt
    local vn = turn_vn
    
    local vx, vy = self:to_local(vt, vn)
    local omega = turn_input * self.rotation_speed
    return vx, vy, omega
end


function ShipEngine:get_frenet_input()
    local input_x = self.controller:get_input_x()
    local input_y = self.controller:get_input_y()

    -- Ограничиваем длину входного вектора до 1.
    local input_length = math.sqrt(
        input_x ^ 2 + input_y ^ 2
    )

    if input_length > 1 then
        input_x = input_x / input_length
        input_y = input_y / input_length
    end

    -- Насколько ввод направлен вперёд.
    local input_t, input_n = self:to_frenet(input_x, input_y)
        
    return input_t, input_n
end

function ShipEngine:to_local(t, n)
	local x = self.face_x * t - self.face_y * n
    local y = self.face_y * t + self.face_x * n
    return x, y
end

function ShipEngine:to_frenet(x, y)
    local t = x * self.face_x + y * self.face_y
    local n = -x * self.face_y + y * self.face_x
    return t, n
end

return ShipEngine