local ADDON_NAME, Addon = ...

Addon = Addon or {}
Addon.name = ADDON_NAME or "CalmChat"
Addon.util = Addon.util or {}

local util = Addon.util

function util.Trim(value)
    if type(value) ~= "string" then
        return ""
    end

    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

function util.ToBoolean(value, default)
    if type(value) == "boolean" then
        return value
    end

    if value == nil then
        return default
    end

    return not not value
end

local function DeepCopy(source)
    if type(source) ~= "table" then
        return source
    end

    local copy = {}
    for key, value in pairs(source) do
        copy[key] = DeepCopy(value)
    end

    return copy
end

util.DeepCopy = DeepCopy

function util.DeepMergeDefaults(target, defaults)
    if type(target) ~= "table" then
        target = {}
    end

    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = DeepCopy(value)
            else
                util.DeepMergeDefaults(target[key], value)
            end
        elseif target[key] == nil then
            target[key] = value
        end
    end

    return target
end

function util.CallGlobal(name, ...)
    local func = _G[name]
    if type(func) == "function" then
        return func(...)
    end
end

function util.CallFrame(frame, method, ...)
    local func = frame and frame[method]
    if type(func) == "function" then
        return func(frame, ...)
    end
end

function util.SetCVarIfAvailable(name, value)
    if type(SetCVar) == "function" then
        pcall(SetCVar, name, value)
    end
end
