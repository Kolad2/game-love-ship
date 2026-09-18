---@class SpriteSheet
---@field image love.Image
---@field frame_width number
---@field frame_height number
---@field columns number
---@field rows number
---@field frame_count number
---@field quads love.Quad[]
local SpriteSheet = {}
SpriteSheet.__index = SpriteSheet


---Создаёт sprite sheet.
---@param image love.Image
---@param frame_width number
---@param frame_height number
---@return SpriteSheet
function SpriteSheet.create(cls, image, frame_width, frame_height)
    local obj = setmetatable({}, cls)

    obj.image = image
    obj.frame_width = frame_width
    obj.frame_height = frame_height

    local image_width, image_height = image:getDimensions()

    obj.columns = math.floor(image_width / frame_width)
    obj.rows = math.floor(image_height / frame_height)

    obj.frame_count = obj.columns * obj.rows
    obj.quads = {}

    for index = 1, obj.frame_count do
        local column = (index - 1) % obj.columns
        local row = math.floor((index - 1) / obj.columns)

        local x = column * frame_width
        local y = row * frame_height

        obj.quads[index] = love.graphics.newQuad(
            x,
            y,
            frame_width,
            frame_height,
            image_width,
            image_height
        )
    end

    return obj
end


---Возвращает quad указанного кадра.
---@param index number
---@return love.Quad
function SpriteSheet:get_quad(index)
    assert(
        index >= 1 and index <= self.frame_count,
        "SpriteSheet frame index out of range: " .. tostring(index)
    )

    return self.quads[index]
end


---Рисует указанный кадр.
---@param index number
---@param x number
---@param y number
---@param rotation number|nil
---@param scale_x number|nil
---@param scale_y number|nil
function SpriteSheet:draw(index, x, y, rotation, scale_x, scale_y)
    love.graphics.draw(
        self.image,
        self:get_quad(index),
        x,
        y,
        rotation or 0,
        scale_x or 1,
        scale_y or scale_x or 1
    )
end


return SpriteSheet