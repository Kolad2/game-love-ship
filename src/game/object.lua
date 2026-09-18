local require = require("src.tools.require_relative")
local ShipEngine = require("src.game.ship_engine")
local Sprite = require("src.engine.sprite")


---@class GameObject
---@field x number
---@field y number
---@field width number
---@field height number
---@field image love.Image|nil
---@field face number
local GameObject = {}
GameObject.__index = GameObject


---Создаёт игровой объект.
---@param x number
---@param y number
---@param image Sprite|nil
---@param width number|nil
---@param height number|nil
---@param controller Controller
---@return GameObject
function GameObject:create(x, y, sprite, width, height , controller)
    local obj = setmetatable({}, self)

    obj.x = x or 0
    obj.y = y or 0
    obj.speed = 120
    obj.face = 0
    obj.controller = controller
    obj.engine = ShipEngine:create(controller)
    obj.sprite = sprite
    return obj
end


---Обновление объекта.
---@param dt number
function GameObject:update(dt)
    local vx, vy, omega =
        self.engine:get_velocity(self.face)

    -- Интегрирование скорости.
    self.x = self.x + vx * dt
    self.y = self.y + vy * dt

    self.face = self.face + omega * dt

    -- Переход через правую границу.
    if self.x > love.graphics.getWidth() then
        self.x = -50
    end
    self.sprite:update(self)
end


---Отрисовка объекта.
function GameObject:draw()
    if not self.sprite then
        return
    end
    self.sprite:draw()
end


return GameObject



