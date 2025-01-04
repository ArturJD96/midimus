local checks <const> = require 'checks'

local Protocol = {
    __type = 'Protocol',
    _default_constructor_name = 'new'
}
Protocol.__index = Protocol

function Protocol.new(id, priority, property_creators)
    checks('string', 'number', 'table')
    local self <const> = setmetatable({}, Protocol)
    self.constructor_name = Protocol._default_constructor_name
    self.priority = priority
    return self
end

function Protocol._sort_by_priority(protocols) -- IN PLACE!
    checks('table')
    local by_priority <const> = function(p1, p2)
        return p1.priority < p2.priority
    end
    table.sort(protocols, by_priority)
end

function Protocol.apply(class, protocols, statics)
    checks('table', 'table', '?table')
    --[[
        This function wraps 'class.new' with a decorator
        resulting in a chain of protocols' constructor calls.
    ]]
    if class.__protocols then
        --[[ __protocol cannot be defined. ]]
        error('This class already applies protocols.')
        -- COMMENT: is this indeed desired?
    end
    for _, protocol in ipairs(protocols) do
        --[[ "protocols" must be a table of Protocols ]]
        if protocol.__type ~= 'Protocol' then
            error('"protocols" argument must be a table of Protocols.')
        end
    end

    Protocol._sort_by_priority(protocols)
    class.__protocols = protocols

    --[[ Wrap default constructor. ]]
    local constructor <const> = class.new or function() return {} end
    class.new = function(...)
        local self <const> = constructor(...)
        setmetatable(self, class)
        for _, protocol in ipairs(protocols) do
            protocol:apply(self)
        end
        return self
    end
end

return Protocol
