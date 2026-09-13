local Game = require("src.game")
local UI = require("src.ui.ui")

function love.load()
    ui = UI:create()
    game = Game:create(ui)
end

function love.touchmoved(id, x, y)
    ui.joystick:touchmoved(id, x, y)
end

function love.touchpressed(id, x, y)
    ui:touchpressed(id, x, y)
end

function love.touchreleased(id, x, y)
    ui:touchreleased(id, x, y)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
    ui:draw()
    love.graphics.print("LÖVE работает!", 30, 30)
end

