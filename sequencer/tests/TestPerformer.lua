local lu <const> = require 'luaunit'
local Event <const> = require 'Event'
local Sequence <const> = require 'Sequence'
local Performer <const> = require 'Performer'

TestPerformer = {}
function TestPerformer:setup()
    self.sequence = Sequence.new()
    self.events = {
        Event.new(20, 50), -- time, duration
        Event.new(40, 40),
        Event.new(80, 10),
        Event.new(100)
    }
    for _, event in ipairs(self.events) do
        self.sequence:record(event)
    end
end

function TestPerformer:test_set_time()
    local performer = self.sequence:perform()
    -- set negative time
    performer:set_time(-20)
    lu.assertEquals(performer._current_time, 0)
    lu.assertEquals(#performer._lasting_events, 0)
    lu.assertEquals(performer._next_event, self.events[1])
    -- set time for lasting event
    local time_two_events_lasting = 45
    performer:set_time(time_two_events_lasting)
    lu.assertEquals(performer._current_time, time_two_events_lasting)
    lu.assertEquals(#performer._lasting_events, 2)
    lu.assertEquals(performer._lasting_events[1], self.events[1])
    lu.assertEquals(performer._lasting_events[2], self.events[2])
    lu.assertEquals(performer._next_event, self.events[3])
    -- set time for an empty moment in between events
    performer:set_time(92)
    lu.assertEquals(#performer._lasting_events, 0)
    lu.assertEquals(performer._next_event, self.events[#self.events])
    -- check time overflow
    local time_overflowing = performer._total_duration + 20
    performer:set_time(time_overflowing)
    lu.assertEquals(performer._current_time, performer._total_duration)
    lu.assertEquals(#performer._lasting_events, 0)
    lu.assertNil(performer._next_event)
end

-- function TestTrack:test_
