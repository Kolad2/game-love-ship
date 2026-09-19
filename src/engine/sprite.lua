Texture = require("src.engine.texture")

---@class Sprite
---@field image Texture
---@field width number
---@field height number
local Sprite = {}
Sprite.__index = Sprite


---Создаёт спрайт.
---@param source Texture|string
---@param x number
---@param y number
---@return Sprite
function Sprite.create(cls, source)
    local obj = setmetatable({}, cls)
    
    if type(source) == "string" then
        obj.image = Texture(source)
    else
        obj.image = source
    end
    obj.width, obj.height = obj.image.width, obj.image.height
    obj.x = 0
    obj.y = 0
    obj.sx = 1
    obj.sy = 1
    obj.angle = 0
    return obj
end

function Sprite:update(source)
	self.x = source.x
    self.y = source.y
    self.angle = source.face
end

---Рисует спрайт.
---@param x number
---@param y number
---@param rotation number|nil
---@param scale_x number|nil
---@param scale_y number|nil
function Sprite:draw()
    self.image:draw(
        self.x,
        self.y,
        self.angle,
        self.sx,
        self.sy
    )
end


return Sprite