local require = require("src.tools.require_relative")
local set = require("src.tools.set")
local Game = require(".init")
local GameObject = require(".object")
local init_objects = require(".init_game")

---@class Game
---@field ui UI
---@field objects set
local Game = Game or {}
Game.__index = Game

function Game:update(dt)
    for i, obj in ipairs(self.objects) do
        obj:update(dt)
    end
    if #self.remove_objects == 0 then return end
    for _, obj in ipairs(self.remove_objects) do
        --error("1")
        self.objects:remove(obj)
    end
    self.remove_objects = {}
end

function Game:draw()
    for i, obj in ipairs(self.objects) do
        if obj["draw"] then
            obj:draw()
        end
    end
end

function Game:_on_button_pressed()
	self.objects[1].x = 0
    self.objects[1].y = 250
end

function Game:init(ui)
    self.ui = ui
    self.ui.button.pressed:subscribe(function()
    	self:_on_button_pressed()
    end)
    self.objects = set:create()
    self.remove_objects = {}
    GameObject.request_destroy:subscribe(function(game_object)
        table.insert(self.remove_objects, game_object)
    end)
    self:init_objects()
    
end

function Game:init_objects()
	local objects = init_objects(ui)
    for i, object in ipairs(objects) do
        table.insert(self.objects, object)
    end
end

function Game.create(cls, ...)
    local obj = setmetatable({},cls)
    obj:init(...)
    return obj
end

return Game