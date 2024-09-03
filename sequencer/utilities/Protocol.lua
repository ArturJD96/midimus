local checks <const> = require 'checks'

local Protocol = {
    __type = 'Protocol',
    _default_constructor_name = 'new'
}
Protocol.__index = Protocol

function Protocol.new(id, property_creators)
    checks('string', 'table')
    local self <const> = setmetatable({}, Protocol)
    self.id = id
    self.property_creators = property_creators
    self.constructor_name = Protocol._default_constructor_name
    return self
end

function Protocol.apply(class, protocols)
    checks('table', 'table')
    for _, protocol in ipairs(protocols) do
        if protocol.__type == 'Protocol' then
            protocol:conform(class)
        elseif type(protocol) == 'string' then
            if not Protocol._register[protocol] then
                error('Protocol not yet implemented: ' .. protocol)
            end
            Protocol._register[protocol]:conform(class)
        else
            error('Wrong type of protocol representation (must be string or Protocol).')
        end
    end
end

function Protocol:conform(class)
    checks('Protocol', 'table')
    assert(class.__type, 'Class conforming to a protocol "' .. self.id .. '" must have defined .__type property')
    for property_name, create_property in pairs(self.property_creators) do
        -- if class[property_name] then
        --     error('Class' .. (class.__type or '') .. ' already has the property ' .. property_name)
        if not class[self.constructor_name] then
            error(class.__type .. ' constructor conforming to "' .. self.id .. '" protocol should be named "' ..
                self.constructor_name ..
                '". Change class constructor method name or modify protocol\'s .default_constructor_name string property.')
        end
        if type(create_property) == 'function' then
            class[property_name] = create_property(class, class[self.constructor_name])
        else
            error('IMPLEMENT')
        end
    end
end

local registrable = Protocol.new('registrable',
    --[[
        Registrable class stores its each new instance
        in its static "_register"" and assigns it
        a unique ".id" property
        (see "_get_default_id" static method).
    ]]
    {
        _register = function(class)
            checks('table')
            local tab = {}
            return tab
        end,

        _default_id = function(class)
            checks('table')
            return class.__type
        end,

        new = function(class, constructor)
            checks('table', 'function')
            return function(...)
                local obj <const> = constructor(...)
                if not obj['id'] then
                    obj.id = class._get_default_id()
                end
                -- assert(obj.id, 'Protocol "registrable" requires and id property in object instance.')
                class._register[obj.id] = obj
                return obj
                -- local new_instance = class.new(id, ...)
                -- class._register[id] = new_instance
                -- return new_instance
            end
        end,

        return_register = function(class)
            return function()
                return class._register
            end
        end,

        remove = function(class)
            return function(id)
                checks('string')
                assert(class._register[id], 'Cannot remove' .. id .. '. Object not present in register.')
                class._register[id] = nil
            end
        end,

        register_count = function(class)
            return function()
                local c = 0
                for id, _ in pairs(class._register) do c = c + 1 end
                return c
            end
        end,

        reset_register = function(class)
            return function()
                class._register = {}
                collectgarbage()
            end
        end,

        _get_default_id = function(class)
            return function()
                checks()
                --[[
                    Get the next default name for a new registrable object
                    (if it's id is not provided).

                    When creating a new registrable object without giving it
                    an explicit id, a default ID is assigned.

                    This default ID consists of registrable object class name
                    (in ._default_id property) and an index number.

                    Continuity of numbers is strived to be preserved.
                    Thus, next id will end with the highest number
                    UNLESS there is a gap between numbers – then,
                    the missing id will be chosen.

                    Examples:
                    1) Sequence_1, Sequence_2, Sequence_3 -> Sequence_4
                    2) Sequence_1, Sequence_3, Sequence_5 -> Sequence_2 (between 1 and 3)
                ]]
                local ids <const>, id_num = {}, nil
                local separator <const> = '_'
                local _join <const> = function(id, sep, num)
                    checks('string', 'string', 'string')
                    return id .. sep .. num
                end
                for id, _ in pairs(class._register) do
                    id_num = id:match('^' .. _join(class._default_id, separator, '(%d+)$'))
                    if id_num and (id_num:sub(0, 1) ~= 0) then
                        table.insert(ids, tonumber(id_num))
                    end
                end
                if #ids == 0 then return _join(class._default_id, separator, '1') end
                table.sort(ids)
                local id = 0
                for _, n in ipairs(ids) do
                    if n - id == 1 then id = n else break end
                end
                local default_id <const> = _join(class._default_id, separator, tostring(id + 1))
                return default_id
            end
        end

    })

--[[
    Make Protocol class registrable.
    (Manually, because Protocol.register
    is not present yet due to lack of, well,
    conforming to registrable protocol).
]]
registrable:conform(Protocol)
Protocol._register[registrable.id] = registrable

-- -- *EXAMPLE:* Mock class
-- local C = { __type = 'C' }
-- C.__index = C
-- function C.new()
--     return setmetatable({}, C)
-- end

-- Protocol.apply(C, { 'registrable' })
-- local t = C.new()
-- print(t.id)

--[[
    From now on, to create protocols
    use Protocol.register(id, ...)
]]

return Protocol
