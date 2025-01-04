local lu <const> = require 'luaunit'
local Protocol <const> = require 'Protocol'

local function shuffle(t) -- in place
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

TestProtocol = {}
function TestProtocol:test_priority()
    local name0, priority0 = 'test-0', -1
    local name2, priority2 = 'test-2', 2
    local name1a, priority1 = 'test-1a', 1
    local name1b = 'test-1b'

    local protocol0 = Protocol.new(name0, priority0, {})
    local protocol2 = Protocol.new(name2, priority2, {})
    local protocol1a = Protocol.new(name1a, priority1, {})
    local protocol1b = Protocol.new(name1b, priority1, {})

    local protocols = { protocol0, protocol2, protocol1a, protocol1b }
    shuffle(protocols)

    local class <const> = { __type = 'class' }
    class.__index = class
    class.new = function() return setmetatable({}, class) end
    Protocol.apply(class, protocols)

    local expected_protocol_order <const> = {
        protocol0,
        protocol1a,
        protocol1b,
        protocol2
    }

    lu.assertEquals(class.__protocols, expected_protocol_order)
end
