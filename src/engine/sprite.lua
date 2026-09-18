---@class Sprite
---@field image love.Image
---@field width number
---@field height number
local Sprite = {}
Sprite.__index = Sprite


---Создаёт спрайт.
---@param source love.Image|string
---@param x number
---@param y number
---@return Sprite
function Sprite.create(cls, source)
    local obj = setmetatable({}, cls)
    print("111")
    if type(source) == "string" then
        obj.image = love.graphics.newImage(source)
    else
        obj.image = source
    end
    obj.width, obj.height = obj.image:getDimensions()
    obj.x = 0
    obj.y = 0
    obj.sx = 1
    obj.sy = 1
    obj.ox = obj.width / 2
    obj.oy = obj.height / 2
    obj.angle = 0
    obj.angle_0 = math.pi / 2
    return obj
end

function Sprite:update(source)
	self.x = source.x
    self.y = source.y
    self.angle = source.face + self.angle_0
end

---Рисует спрайт.
---@param x number
---@param y number
---@param rotation number|nil
---@param scale_x number|nil
---@param scale_y number|nil
function Sprite:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.angle,
        self.sx,
        self.sy,
        self.ox,
        self.oy
    )
end


return Sprite