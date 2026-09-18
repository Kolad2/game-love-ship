local function normalize_path(_path)
    local parts = {}

    for part in _path:gmatch("[^/]+") do
        if part == ".." then
            table.remove(parts)
        elseif part ~= "." and part ~= "" then
            table.insert(parts, part)
        end
    end

    return table.concat(parts, "/")
end


local function resolve_relative(module_name, source)
    -- Абсолютный импорт.
    if module_name:sub(1, 1) ~= "." then
        return module_name
    end

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

    local _path = normalize_path(dir .. relative)

    return _path
        :gsub("%.lua$", "")
        :gsub("/", ".")
end


---@class RelativeRequire
---@overload fun(module_name: string): any
local Require = {
    ---Преобразует относительное имя модуля в абсолютное.
    ---@param module_name string
    ---@return string
    path = function(module_name)
        local caller = assert(debug.getinfo(2, "S"), "cannot determine require caller")
        return resolve_relative(module_name, caller.source)
    end,

    ---Записывает значение в package.loaded по относительному пути.
    ---@param module_name string
    ---@param value any
    set_loaded = function(module_name, value)
        local caller = assert(debug.getinfo(2, "S"), "cannot determine require caller")
        local require_path = resolve_relative(module_name, caller.source)
        package.loaded[require_path] = value
    end
}


setmetatable(Require, {
    __call = function(_, module_name)
        local caller = assert(debug.getinfo(2, "S"), "cannot determine require caller")
        local require_path = resolve_relative(module_name, caller.source)
        return require(require_path)
    end
})


return Require
