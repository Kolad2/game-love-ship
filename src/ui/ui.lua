local require = require("src.tools.require_relative")
local Button = require("src.ui.button")
local Joystick = require("src.ui.joystick")

---@class UI
local UI = {}
UI._meta = {
    __index = UI
}


function UI.create(cls)
	local obj = setmetatable({}, cls._meta)
    obj.button = Button:create(100,100,100, 50, "Жми меня")
    local w, h = love.graphics.getDimensions()
    local r = math.min(w, h) * 0.15
    obj.joystick = Joystick:create(r*2.0, h - r, r)
    return obj
end

function UI:touchpressed(id, x, y)
    self.button:touchpressed(id, x, y)
    self.joystick:touchpressed(id, x, y)
end

function UI:touchreleased(id, x, y)
    self.joystick:touchreleased(id, x, y)
end

function UI:touchmoved(id, x, y)
    self.joystick:touchmoved(id, x, y)
end

function UI:draw()
	self.button:draw()
    self.joystick:draw()
end

return UI