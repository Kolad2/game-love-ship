---@class Texture
---@field image love.Image
---@field quad love.Quad
---@field width number
---@field height number
---@field ox number
---@field oy number
---@field angle number
local Texture = {}
Texture.__index = Texture

---@param source love.Image|string
---@param quad love.Quad|nil
---@return Texture
function Texture.create(cls, source, quad)
    ---@type Texture
    local obj = setmetatable({}, cls)

    if type(source) == "string" then
        obj.image = love.graphics.newImage(source)
    else
        obj.image = source
    end
    
    local image_width, image_height = obj.image:getDimensions()

    if quad then
        obj.quad = quad
    else
        obj.quad = love.graphics.newQuad(
            0,
            0,
            image_width,
            image_height,
            image_width,
            image_height
        )
    end
    
    local _, _, width, height = obj.quad:getViewport()
    obj.width = width + 1
    obj.height = height + 1
    obj.ox = obj.width / 2
    obj.oy = obj.height / 2
    obj.angle = 0
    return obj
end

function Texture:draw(x, y, angle, sx, sy, ox, oy)
    love.graphics.draw(
        self.image,
        self.quad,
        x,
        y,
        angle+self.angle,
        sx or 1,
        sy or sx or 1,
        ox or self.ox,
        oy or self.oy
    )
end

return Texture