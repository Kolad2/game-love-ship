local function normalize_path(path)
    local parts = {}

    for part in path:gmatch("[^/]+") do
        if part == ".." then
            table.remove(parts)
        elseif part ~= "." and part ~= "" then
            table.insert(parts, part)
        end
    end

    return table.concat(parts, "/")
end


local function resolve_relative(module_name, stack_level)
    -- Абсолютный импорт.
    if module_name:sub(1, 1) ~= "." then
        return module_name
    end

    -- Файл, из которого вызван require/resolve.
    local source = debug.getinfo(stack_level, "S").source

    if source:sub(1, 1) == "@" then
        source = source:sub(2)
    end

    -- Директория текущего файла.
    local dir = source:match("(.*/)") or ""

    local relative = module_name

    -- "./engine" -> "engine"
    if relative:sub(1, 2) == "./" then
        relative = relative:sub(3)

    -- ".engine" -> "engine"
    elseif relative:sub(1, 1) == "." and relative:sub(2, 2) ~= "." then
        relative = relative:sub(2)
    end

    local path = normalize_path(dir .. relative)

    return path
        :gsub("%.lua$", "")
        :gsub("/", ".")
end


---@class RelativeRequire
---@overload fun(module_name: string): any
local Require = {}


---Преобразует относительное имя модуля в абсолютное.
---@param module_name string
---@return string
function Require.path(module_name)
    return resolve_relative(module_name, 3)
end


setmetatable(Require, {
    __call = function(_, module_name)
        local require_path = resolve_relative(module_name, 3)
        return require(require_path)
    end
})


return Require
