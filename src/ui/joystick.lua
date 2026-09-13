---@class Joystick
---@field x number
---@field y number
---@field radius number
---@field dx number
---@field dy number
---@field touch_id any|nil
local Joystick = {}

Joystick._meta = {
    __index = Joystick
}


---Создаёт новый виртуальный джойстик.
---@param x number Координата центра по X.
---@param y number Координата центра по Y.
---@param radius number Радиус джойстика.
---@return Joystick
function Joystick:create(x, y, radius)
    ---@type Joystick
    local obj = setmetatable({}, self._meta)

    obj.x = x
    obj.y = y
    obj.radius = radius

    obj.dx = 0
    obj.dy = 0

    obj.touch_id = nil

    return obj
end


---Проверяет, находится ли точка внутри джойстика.
---@param x number
---@param y number
---@return boolean
function Joystick:contains(x, y)
    local dx = x - self.x
    local dy = y - self.y

    return dx * dx + dy * dy <= self.radius * self.radius
end


---Обрабатывает начало касания.
---@param id any Идентификатор пальца LÖVE.
---@param x number
---@param y number
---@return boolean handled
function Joystick:touchpressed(id, x, y)
    -- Джойстик уже занят другим пальцем.
    if self.touch_id ~= nil then
        return false
    end

    if not self:contains(x, y) then
        return false
    end

    self.touch_id = id
    self:update_position(x, y)

    return true
end


---Обрабатывает движение пальца.
---@param id any
---@param x number
---@param y number
---@return boolean handled
function Joystick:touchmoved(id, x, y)
    if self.touch_id ~= id then
        return false
    end

    self:update_position(x, y)

    return true
end


---Обрабатывает отпускание пальца.
---@param id any
---@param x number
---@param y number
---@return boolean handled
function Joystick:touchreleased(id, x, y)
    if self.touch_id ~= id then
        return false
    end

    self.touch_id = nil
    self.dx = 0
    self.dy = 0

    return true
end


---Обновляет положение ручки джойстика.
---Если палец находится за пределами радиуса,
---смещение ограничивается окружностью джойстика.
---@param x number
---@param y number
function Joystick:update_position(x, y)
    local dx = x - self.x
    local dy = y - self.y

    local length = math.sqrt(dx * dx + dy * dy)

    if length > self.radius then
        dx = dx / length * self.radius
        dy = dy / length * self.radius
    end

    self.dx = dx
    self.dy = dy
end


---Возвращает нормализованное отклонение по X.
---Диапазон примерно от -1 до 1.
---@return number
function Joystick:get_input_x()
    return self.dx / self.radius
end


---Возвращает нормализованное отклонение по Y.
---Диапазон примерно от -1 до 1.
---@return number
function Joystick:get_input_y()
    return self.dy / self.radius
end


---Возвращает нормализованное направление джойстика.
---@return number x Значение от -1 до 1.
---@return number y Значение от -1 до 1.
function Joystick:get_input()
    return self.dx / self.radius,
           self.dy / self.radius
end


---Возвращает true, если джойстик сейчас удерживается пальцем.
---@return boolean
function Joystick:is_pressed()
    return self.touch_id ~= nil
end


---Сбрасывает состояние джойстика.
function Joystick:reset()
    self.touch_id = nil
    self.dx = 0
    self.dy = 0
end


---Рисует джойстик.
function Joystick:draw()
    -- Внешняя окружность
    love.graphics.circle(
        "line",
        self.x,
        self.y,
        self.radius
    )

    -- Ручка
    love.graphics.circle(
        "fill",
        self.x + self.dx,
        self.y + self.dy,
        self.radius * 0.35
    )
end


return Joystick