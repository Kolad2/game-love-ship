local require = require("src.tools.require_relative")
local Game = require(".init")

local TextureAtlas = require("src.engine.texture_atlas")
local Sprite = require("src.engine.sprite")
local ShipEngine = require(".engines.ship_engine")
local DirectionalEngine = require(".engines.directional_engine")
local Texture = require("src.engine.texture")
local GameObject = require(".object")
local AnimationTrack = require("src.engine.animation.animation_track")
local Animation = require("src.engine.animation.animation")
local AnimationPlayer = require("src.engine.animation.animation_player")

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
    
    local sprite_sheet = TextureAtlas:create("assets/plasma_bullet.png", 80, 64)
    local quad_texture = sprite_sheet:get_texture(2)
    local sprite = Sprite:create(quad_texture)
    local engine = DirectionalEngine:create(10, 0)

    local animation = {}
    do
        animation["birth"] = Animation:create(0.25, true)
        local track = AnimationTrack:create({"sprite", "texture"})
        track:insert_key(sprite_sheet:get_texture(1), 0)
        track:insert_key(sprite_sheet:get_texture(2), 0.05)
        track:insert_key(sprite_sheet:get_texture(3), 0.10)
        track:insert_key(sprite_sheet:get_texture(4), 0.15)
        track:insert_key(sprite_sheet:get_texture(5), 0.20)
        animation["birth"]:add_track(track)
    end

    do
        animation["fly"] = Animation:create(0.25, true)
        local track = AnimationTrack:create({"sprite", "texture"})
        track:insert_key(sprite_sheet:get_texture(6), 0)
        track:insert_key(sprite_sheet:get_texture(7), 0.05)
        track:insert_key(sprite_sheet:get_texture(8), 0.10)
        track:insert_key(sprite_sheet:get_texture(9), 0.15)
        track:insert_key(sprite_sheet:get_texture(10), 0.20)
        animation["fly"]:add_track(track)
    end

    do
        animation["death"] = Animation:create(0.25, true)
        local track = AnimationTrack:create({"sprite", "texture"})
        track:insert_key(sprite_sheet:get_texture(11), 0)
        track:insert_key(sprite_sheet:get_texture(12), 0.05)
        track:insert_key(sprite_sheet:get_texture(13), 0.10)
        track:insert_key(sprite_sheet:get_texture(14), 0.15)
        track:insert_key(sprite_sheet:get_texture(15), 0.20)
        animation["death"]:add_track(track)
    end

    local animation_player = AnimationPlayer:create()
    local bullet = GameObject:create(250, 250, sprite, engine)

    animation_player:play(bullet, animation["death"])
    
    table.insert(self.objects, ship)
    table.insert(self.objects, bullet)
    table.insert(self.objects, animation_player)
end

function Game.create(cls, ...)
    local obj = setmetatable({},cls)
    obj:init(...)
    return obj
end

return Game