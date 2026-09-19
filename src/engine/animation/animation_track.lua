local Keyframe = require("src.engine.animation.keyframe")

---@class AnimationTrack
---@field target table
---@field key any
---@field frames Keyframe[]
---@field last_keyframe integer
---@field interpolation string
local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack


---Создаёт трек свойства.
---@param target table
---@param key any
---@param interpolation string|nil
---@return AnimationTrack
function AnimationTrack.create(cls, target, key, interpolation)
    ---@type AnimationTrack
    local obj = setmetatable({}, cls)

    obj.target = target
    obj.key = key
    obj.interpolation = interpolation or "step"
    obj.frames = {}

    -- 0 означает, что ключ ещё не находили.
    obj.last_keyframe = nil

    return obj
end


---Добавляет ключевой кадр.
---@param value any
---@param time number
---@return AnimationTrack
function AnimationTrack:insert_key(value, time)
    table.insert(
        self.frames,
        Keyframe:create(value, time)
    )
    return self
end

function AnimationTrack:get_pre_key()
    return self.frames[1]
end


function AnimationTrack:is_future(time)
    return time > self.frames[self.last_keyframe].time
end


function AnimationTrack:apply(time)
    local frame = self:get_left_keyframe_by_time(time)
    if not frame then return nil end
    self.target[self.key] = frame.value
end

--Возвращает левый ключевой кадр для заданного времени.
---@param time number
---@return Keyframe|nil
function AnimationTrack:get_left_keyframe_by_time(time)
    local frames = self.frames
    local count = #frames

    if count == 0 then
        return nil
    end

    -- До первого ключа.
    if time < frames[1].time then
        return self:get_pre_key()
    end

    local left_keyframe = frames[1]

    for i = 2, count do
        local frame = frames[i]

        if frame.time > time then
            break
        end

        left_keyframe = frame
    end

    return left_keyframe
end

return AnimationTrack