local lu <const> = require 'luaunit'
local Sequence <const> = require 'Sequence'
local Event <const> = require 'Event'

TestSequence = {}
function TestSequence:setup()
    Sequence.reset_register()
    Event.reset_register()
end

function TestSequence:test_record()
    local sequence = Sequence.new()
    -- consequent & simultaneous events
    local time1, time2 = 123, 456
    local event1 = Event.new(time1)
    local event2 = Event.new(time2)
    local event3 = Event.new(time2)
    sequence
        :record(event1)
        :record(event2)
        :record(event3)
    -- put in the middle of two events
    local time_inserted = 300
    lu.assertTrue(time1 < time_inserted and time_inserted < time2)
    local event_inserted = Event.new(time_inserted)
    sequence:record(event_inserted)
    -- test
    lu.assertEquals(#sequence.events, 4)
    lu.assertEquals(sequence.events[1], event1)
    lu.assertEquals(sequence.events[2], event_inserted)
    lu.assertEquals(sequence.events[3], event2)
    lu.assertEquals(sequence.events[4], event3)
end

function TestSequence:test_remove()
    local sequence = Sequence.new()
    local time1, time2, time3 = 123, 456, 789
    local event1 = Event.new(time1)
    local event2 = Event.new(time2)
    local event3 = Event.new(time3)
    sequence
        :record(event1)
        :record(event2)
        :record(event3)
        :remove(event2.id)
    lu.assertEquals(#sequence.events, 2)
    lu.assertEquals(sequence.events[1], event1)
    lu.assertEquals(sequence.events[2], event3)
end

function TestSequence:test_is_empty() -- clear sequence?
    local sequence = Sequence.new()
    lu.assertTrue(sequence:is_empty())
    local event = Event.new()
    sequence:record(event)
    lu.assertFalse(sequence:is_empty())
    sequence:remove(event.id)
    lu.assertTrue(sequence:is_empty())
end
