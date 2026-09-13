local Observer = require("src.tools.observer")

---@class Button
---@field pressed Observer
local Button = {}

Button._meta = {
    __index = Button
}

function Button:create(x, y, dx, dy, text)
    local obj = setmetatable({}, self._meta)

    obj.x = x
    obj.y = y
    obj.dx = dx
    obj.dy = dy
    obj.text = text or ""
    obj.pressed = Observer()
    return obj
end

function Button:touchpressed(id, x, y)
    if self:contains(x, y) then
        self:press()
        return true
    end
    return false
end


function Button:contains(x, y)
    return x >= self.x
       and x <= self.x + self.dx
       and y >= self.y
       and y <= self.y + self.dy
end

function Button:press()
    self.pressed:publish(self)
end

function Button:draw()
    love.graphics.rectangle(
        "line",
        self.x,
        self.y,
        self.dx,
        self.dy
    )

    love.graphics.print(
        self.text,
        self.x + 10,
        self.y + 10
    )
end

return Button