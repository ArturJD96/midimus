local function _stringify(object, nesting_level)
    local INTENDATION = 2 -- spaces.

    local tab = nesting_level or 0
    local str = ''
    local first = true

    local object_keys = {}
    for k, v in pairs(object) do
        if type(k) == "boolean" then
            --error("Key is a boolean in "..tostring(object)) end
            k = (k and 'true') or 'false'
        end
        table.insert(object_keys, k)
    end -- populate the table that holds the keys

    -- table.sort(object_keys)

    for _, k in ipairs(object_keys) do
        v = object[k]

        for i = 1, tab, 1 do str = str .. ' ' end

        if type(v) == 'table' then
            str = str .. k .. ":\n" .. _stringify(v, tab + INTENDATION)
        else
            str = str .. k .. ": " .. tostring(v) .. '\n'
        end
    end

    return str
end


local function display(item)
    if type(item) == 'table' then
        item = _stringify(item)
    end

    print(item)
end

return display
