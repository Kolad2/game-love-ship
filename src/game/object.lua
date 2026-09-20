local require = require("src.tools.require_relative")
local ShipEngine = require(".engines.ship_engine")
local Sprite = require("src.engine.sprite")


---@class GameObject
---@field x number
---@field y number
---@field width number
---@field height number
---@field image love.Image|nil
---@field face number
---@field components Component[]
local GameObject = {}
GameObject.__index = GameObject


---Создаёт игровой объект.
---@param x number
---@param y number
---@param sprite Sprite
---@param engine ObjectEngine
---@return GameObject
function GameObject:create(x, y, sprite, engine)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.speed = 120
    obj.face = 0
    obj.engine = engine
    obj.sprite = sprite
    obj.components = {}
    return obj
end

---@param component Component
---@param key string|nil
function GameObject:add_component(component, key)
    component.root = self
    table.insert(self.components, component)
    if key then
        self[key] = component
    end
    return self
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
    for _, component in ipairs(self.components) do
        component:update(dt)
    end
end


---Отрисовка объекта.
function GameObject:draw()
    if not self.sprite then
        return
    end
    self.sprite:draw()
end


return GameObject



