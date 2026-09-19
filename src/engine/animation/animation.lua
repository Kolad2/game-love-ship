---@class Animation
---@field tracks AnimationTrack[]
---@field duration number
---@field loop boolean
local Animation = {}
Animation.__index = Animation


---@param duration number
---@param loop boolean|nil
---@return Animation
function Animation.create(cls, duration, loop)
    ---@type Animation
    local obj = setmetatable({}, cls)

    obj.duration = duration
    obj.loop = loop or false
    obj.tracks = {}

    return obj
end


---@param track AnimationTrack
---@return Animation
function Animation:add_track(track)
    table.insert(self.tracks, track)
    return self
end


return Animation