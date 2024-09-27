local lu <const> = require 'luaunit'
local Sequence <const> = require 'Sequence'
local Event <const> = require 'Event'

TestSequence = {}
function TestSequence:setup()
    Sequence.reset_register()
    -- self.sequence = Sequence.new()
end

function TestSequence:test_record()
    local sequence = Sequence.new()
    local event1, time1 = Event.new(), 123
    local event2, time2 = Event.new(), 456
    local event3 = Event.new()
    sequence:record(event1, time1)
    sequence:record(event2, time2)
    sequence:record(event3, time2)
    lu.assertEquals(#sequence.events[123], 1)
    lu.assertEquals(#sequence.events[456], 2)
end

function TestSequence:test_clear() -- clear sequence?
    local sequence = Sequence.new()
end

os.exit(lu.LuaUnit.run())
