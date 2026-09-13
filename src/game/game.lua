local Game = require("src.game.init")
local GameObject = require("src.game.object")

---@class Game
---@field ui UI
Game = Game or {}
Game.__index = Game

function Game:update(dt)
    self.ship:update(dt)
end

function Game:_on_button_pressed()
	self.ship.x = 0
    self.ship.y = 250
end

function Game:__init(ui)
    self.ui = ui
    self.speed = 120
    self.ui.button.pressed:subscribe(function()
    	self:_on_button_pressed()
    end)
    local image = love.graphics.newImage("assets/spaceship_ant.png")
    self.ship = GameObject:create(250, 250, image, 128, 128, ui.joystick)
end

function Game.create(cls, ...)
    local obj = setmetatable({},cls)
    obj:__init(...)
    return obj
end

function Game:draw()
    self.ship:draw()
end

return Game