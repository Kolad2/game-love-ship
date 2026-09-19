---@class Keyframe
---@field time number
---@field value any
local Keyframe = {}
Keyframe.__index = Keyframe


---@param value any
---@param time number
---@return Keyframe
function Keyframe.create(cls, value, time)
    local obj = setmetatable({}, cls)
    obj.time = time
    obj.value = value
    return obj
end


return Keyframe