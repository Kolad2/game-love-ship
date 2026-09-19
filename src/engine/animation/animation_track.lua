local Keyframe = require("src.engine.animation.keyframe")


---@class AnimationTrack
---@field path string[]
---@field frames Keyframe[]
local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack


---Создаёт трек.
---@param path string[] Путь к анимируемому свойству.
---@return AnimationTrack
function AnimationTrack.create(cls, path)
    ---@type AnimationTrack
    local obj = setmetatable({}, cls)

    obj.path = path
    obj.frames = {}

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


---Значение до первого ключевого кадра.
---@return Keyframe|nil
function AnimationTrack:get_pre_key()
    return self.frames[1]
end


---Возвращает левый ключевой кадр для заданного времени.
---@param time number
---@return Keyframe|nil
function AnimationTrack:get_left_keyframe_by_time(time)
    local frames = self.frames
    local count = #frames

    if count == 0 then
        return nil
    end

    if time < frames[1].time then
        return self:get_pre_key()
    end

    local left_keyframe = frames[1]

    for i = 2, count do
        if frames[i].time > time then
            break
        end

        left_keyframe = frames[i]
    end

    return left_keyframe
end


---Вычисляет значение трека в заданный момент.
---@param time number
---@return any
function AnimationTrack:evaluate(time)
    local frame = self:get_left_keyframe_by_time(time)

    if not frame then
        return nil
    end

    return frame.value
end


return AnimationTrack