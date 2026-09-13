local GameObject = require("src.game.object")

---@class Controller
Controller = {}
Controller.__index = Controller

function Controller:create()
    local obj = setmetatable({}, self)
    
    return obj
end

function Controller:get_input_x()
    return 0
end

function Controller:get_input_y()
    return 0
end