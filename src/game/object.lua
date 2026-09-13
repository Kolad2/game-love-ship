
---@class GameObject
---@field x number
---@field y number
---@field width number
---@field height number
---@field image love.Image|nil
local GameObject = {}
GameObject.__index = GameObject


---Создаёт игровой объект.
---@param x number
---@param y number
---@param image love.Image|nil
---@param width number|nil
---@param height number|nil
---@param controller Controller
---@return GameObject
function GameObject:create(x, y, image, width, height , controller)
    local obj = setmetatable({}, self)

    obj.x = x or 0
    obj.y = y or 0
    obj.speed = 120
    obj.face = -math.pi / 2
    obj.controller = controller

    obj.image = image

    if image then
        local image_width, image_height = image:getDimensions()

        obj.width = width or image_width
        obj.height = height or image_height
    else
        obj.width = width or 0
        obj.height = height or 0
    end

    return obj
end


---Обновление объекта.
---@param dt number
function GameObject:update(dt)
    local input_x = self.controller:get_input_x()
    local input_y = self.controller:get_input_y()

    -- Ограничиваем длину входного вектора до 1
    local input_length = math.sqrt(input_x ^ 2 + input_y ^ 2)

    if input_length > 1 then
        input_x = input_x / input_length
        input_y = input_y / input_length
    end

    -- Направление, куда смотрит объект
    local forward_x = math.cos(self.face)
    local forward_y = math.sin(self.face)

    -- Проекция input на направление объекта.
    --  1 = полностью вперёд
    --  0 = перпендикулярно
    -- -1 = полностью назад
    local forward_input =
        input_x * forward_x +
        input_y * forward_y

    -- Перпендикулярная составляющая.
    -- Определяет направление и силу поворота.
    local turn_input =
        forward_x * input_y -
        forward_y * input_x

    local rotation_speed = math.pi

    -- Поворот
    self.face = self.face + turn_input * rotation_speed * dt

    -- Движение вдоль текущего направления
    self.x = self.x +
        forward_x * self.speed * forward_input * dt

    self.y = self.y +
        forward_y * self.speed * forward_input * dt

    -- Переход через правую границу
    if self.x > love.graphics.getWidth() then
        self.x = -50
    end
end


---Отрисовка объекта.
function GameObject:draw()
    if not self.image then
        return
    end

    local image_width, image_height = self.image:getDimensions()

    local scale_x = self.width / image_width
    local scale_y = self.height / image_height
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.face + math.pi / 2,
        scale_x,
        scale_y
    )
end


return GameObject



