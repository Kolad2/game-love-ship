local require = require("src.tools.require_relative")
local Game = require(".init")

local SpriteSheet = require("src.engine.texture_atlas")
local Sprite = require("src.engine.sprite")
local ShipEngine = require(".engines.ship_engine")
local DirectionalEngine = require(".engines.directional_engine")
local Texture = require("src.engine.texture")
local GameObject = require(".object")


---@class Game
---@field ui UI
Game = Game or {}
Game.__index = Game

function Game:update(dt)
    for i, obj in ipairs(self.objects) do
        obj:update(dt)
    end
end

function Game:draw()
    for i, obj in ipairs(self.objects) do
        obj:draw()
    end
end

function Game:_on_button_pressed()
	self.objects[1].x = 0
    self.objects[1].y = 250
end

function Game:init(ui)
    self.ui = ui
    self.speed = 120
    self.ui.button.pressed:subscribe(function()
    	self:_on_button_pressed()
    end)
    self.objects = {}
    
    self:init_objects()
    
end

function Game:init_objects()
	local image = love.graphics.newImage("assets/spaceship_ant.png")
    local texture = Texture:create(image)
    texture.angle = math.pi / 2
    local sprite = Sprite:create(texture)
    sprite.sx = 0.5
    sprite.sy = 0.5
    local ship_engine = ShipEngine:create(ui.joystick)
    local ship = GameObject:create(250, 250, sprite, ship_engine)
    
    local sprite_sheet = SpriteSheet:create("assets/plasma_bullet.png", 80, 64)
    local quad_texture = sprite_sheet:get_texture(2)
    local sprite = Sprite:create(quad_texture)
    local engine = DirectionalEngine:create(10, 0)
    local track = {
        {
            {
                target = sprite,
                key = "texture",
                value = sprite_sheet:get_texture(1)
            }
        },
        {
            {
                target = sprite,
                key = "texture",
                value = sprite_sheet:get_texture(2)
            }
        },
        {
            {
                target = sprite,
                key = "texture",
                value = sprite_sheet:get_texture(2)
            }
        },
    }
    local bullet = GameObject:create(250, 250, sprite, engine)
    
    table.insert(self.objects, ship)
    table.insert(self.objects, bullet)
end

function Game.create(cls, ...)
    local obj = setmetatable({},cls)
    obj:init(...)
    return obj
end

return Game