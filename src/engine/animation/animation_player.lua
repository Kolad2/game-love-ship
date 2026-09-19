---@class AnimationPlayer
---@field animation Animation|nil
---@field time number
---@field playing boolean
local AnimationPlayer = {}
AnimationPlayer.__index = AnimationPlayer


---@return AnimationPlayer
function AnimationPlayer.create(cls)
    ---@type AnimationPlayer
    local obj = setmetatable({}, cls)

    obj.animation = nil
    obj.time = 0
    obj.playing = false

    return obj
end


---@param animation Animation
function AnimationPlayer:play(animation)
    self.animation = animation
    self.time = 0
    self.playing = true

    animation:apply(0)
end


function AnimationPlayer:stop()
    self.playing = false
end


---@param dt number
function AnimationPlayer:update(dt)
    if not self.playing then
        return
    end

    local animation = self.animation

    if not animation then
        return
    end

    self.time = self.time + dt

    if self.time >= animation.duration then
        if animation.loop then
            self.time = self.time % animation.duration
        else
            self.time = animation.duration
            self.playing = false
        end
    end

    animation:apply(self.time)
end


return AnimationPlayer