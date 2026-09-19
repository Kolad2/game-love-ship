Texture = require("src.engine.texture")

---@class Sprite
---@field texture Texture
---@field width number
---@field height number
---@field sx number
---@field sy number
local Sprite = {}
Sprite.__index = Sprite


---Создаёт спрайт.
---@param source Texture|string
---@return Sprite
function Sprite.create(cls, source)
     ---@type Sprite
    local obj = setmetatable({}, cls)
    
    if type(source) == "string" then
        obj.texture = Texture(source)
    else
        obj.texture = source
    end
    obj.width, obj.height = obj.texture.width, obj.texture.height
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
function Sprite:draw()
    self.texture:draw(
        self.x,
        self.y,
        self.angle,
        self.sx,
        self.sy
    )
end


return Sprite