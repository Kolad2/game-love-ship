---@class BoundAnimationTrack
---@field track AnimationTrack
---@field target table
---@field key any
---@field last_keyframe integer|nil


---@class AnimationPlayer
---@field animation Animation|nil
---@field bound_tracks BoundAnimationTrack[]
---@field time number
---@field playing boolean
local AnimationPlayer = {}
AnimationPlayer.__index = AnimationPlayer


---@return AnimationPlayer
function AnimationPlayer.create(cls)
    ---@type AnimationPlayer
    local obj = setmetatable({}, cls)

    obj.animation = nil
    obj.bound_tracks = {}
    obj.time = 0
    obj.playing = false

    return obj
end


---Разрешает путь трека относительно root.
---@param root table
---@param track AnimationTrack
---@return BoundAnimationTrack
function AnimationPlayer:bind_track(root, track)
    local target = root
    local path = track.path

    for i = 1, #path - 1 do
        target = target[path[i]]
    end

    return {
        track = track,
        target = target,
        key = path[#path],
        last_keyframe = nil,
    }
end


---@param root table
---@param animation Animation
function AnimationPlayer:play(root, animation)
    self.animation = animation
    self.time = 0
    self.playing = true
    self.bound_tracks = {}

    for _, track in ipairs(animation.tracks) do
        table.insert(
            self.bound_tracks,
            self:bind_track(root, track)
        )
    end

    self:apply()
end


function AnimationPlayer:stop()
    self.playing = false
end


function AnimationPlayer:apply()
    for _, bound in ipairs(self.bound_tracks) do
        local value = bound.track:evaluate(self.time)

        if value ~= nil then
            bound.target[bound.key] = value
        end
    end
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

    self:apply()
end


return AnimationPlayer