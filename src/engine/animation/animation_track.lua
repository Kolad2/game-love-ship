local Keyframe = require(".keyframe")


---@class AnimationTrack
---@field target table
---@field key any
---@field keyframes Keyframe[]
---@field interpolation string
local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack


---Создаёт трек свойства.
---@param target table Объект, свойство которого меняется.
---@param key any Ключ свойства.
---@param interpolation string|nil "step" или "linear".
---@return AnimationTrack
function AnimationTrack.create(cls, target, key, interpolation)
    ---@type AnimationTrack
    local obj = setmetatable({}, cls)

    obj.target = target
    obj.key = key
    obj.interpolation = interpolation or "step"
    obj.keyframes = {}

    return obj
end


---Добавляет ключевой кадр.
---@param time number
---@param value any
---@return AnimationTrack
function AnimationTrack:insert_key(value, time)
    table.insert(
        Keyframe:create(value, time)
    )
    return self
end


---Вычисляет значение трека в указанный момент.
---@param time number
---@return any
function AnimationTrack:evaluate(time)
    local frames = self.keyframes

    if #frames == 0 then
        return nil
    end

    if time <= frames[1].time then
        return frames[1].value
    end

    for i = 1, #frames - 1 do
        local current = frames[i]
        local next_frame = frames[i + 1]

        if time < next_frame.time then
            if self.interpolation == "step" then
                return current.value
            end

            if self.interpolation == "linear" then
                local t =
                    (time - current.time) /
                    (next_frame.time - current.time)

                return current.value +
                    (next_frame.value - current.value) * t
            end

            return current.value
        end
    end

    return frames[#frames].value
end


---Применяет состояние трека к target.
---@param time number
function AnimationTrack:apply(time)
    local value = self:evaluate(time)

    if value ~= nil then
        self.target[self.key] = value
    end
end


return AnimationTrack