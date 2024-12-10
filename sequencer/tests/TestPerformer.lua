local lu <const> = require 'luaunit'
-- local lp = require 'luaproc' -- multithreading
local Event <const> = require 'Event'
local Sequence <const> = require 'Sequence'
local Performer <const> = require 'Performer'

TestPerformer = {}
function TestPerformer:setup()
    self.events = {}
    self.times = { 20, 40, 80, 100 }
    self.durations = { 50, 40, 10, nil }
    self.last_event = nil
    self.callback = function(event) self.last_event = event.id end
    self.sequence = Sequence.new()

    -- create events
    for i = 1, #self.times, 1 do
        local time, dur = self.times[i], self.durations[i]
        local event = Event.new(time, dur, self.callback)
        table.insert(self.events, event)
    end

    -- add events to sequence
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

function TestPerformer:test_play()
    local performer = self.sequence:perform()
    --[ Those two processes should run concurrently. ]
    performer:play() -- sets the self.last_event
    for i = 1, #self.times, 1 do
        local time_prev = self.times[i] or 0
        local time_curr = self.times[i]
        local ms = time_curr - time_prev
        os.execute('sleep ' .. tonumber(ms / 1000))
        lu.assertEquals(self.last_event, self.events[i].id)
    end
end

-- function TestTrack:test_
