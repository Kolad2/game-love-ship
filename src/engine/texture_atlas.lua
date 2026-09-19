Texture = require("src.engine.texture")

---@class TextureAtlas
---@field image love.Image
---@field frame_width number
---@field frame_height number
---@field columns number
---@field rows number
---@field frame_count number
---@field textures Texture[]
local TextureAtlas = {}
TextureAtlas.__index = TextureAtlas


---Создаёт sprite sheet.
---@param cls TextureAtlas
---@param image love.Image|string Изображение или путь к файлу.
---@param frame_width number
---@param frame_height number
---@return TextureAtlas
function TextureAtlas.create(cls, image, frame_width, frame_height)
    local obj = setmetatable({}, cls)

    if type(image) == "string" then
        image = love.graphics.newImage(image)
    end

    obj.image = image
    obj.frame_width = frame_width
    obj.frame_height = frame_height

    local image_width, image_height = image:getDimensions()

    obj.columns = math.floor(image_width / frame_width)
    obj.rows = math.floor(image_height / frame_height)

    obj.frame_count = obj.columns * obj.rows
    obj.textures = {}

    for index = 1, obj.frame_count do
        local column = (index - 1) % obj.columns
        local row = math.floor((index - 1) / obj.columns)

        local x = column * frame_width
        local y = row * frame_height

        local quad = love.graphics.newQuad(
            x,
            y,
            frame_width,
            frame_height,
            image_width,
            image_height
        )
        obj.textures[index] = Texture:create(obj.image, quad)
    end

    return obj
end


---Возвращает quad указанного кадра.
---@param index number
---@return Texture
function TextureAtlas:get_texture(index)
    assert(
        index >= 1 and index <= self.frame_count,
        "SpriteSheet frame index out of range: " .. tostring(index)
    )

    return self.textures[index]
end


return TextureAtlas