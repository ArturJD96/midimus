local lu <const> = require 'luaunit'
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

function TestPerformer:test_pd_clock_registration()
    local performer = self.sequence:perform()
    local pdlua_obj = performer.pdlua_obj -- achieve using new protocol.
    local callback_name = 'callback_' .. performer.id
    lu.assertNotNil(pdlua_obj[callback_name])
    performer:free() -- deregister clock and remove callback.
    lu.assertNil(pdlua_obj[callback_name])
    --[[
    Based on legacy Seq (=self):
        self.clock = self.pd.Clock:new():register(self.pdlua_obj, self.clock_callback_id)
        self.pdlua_obj[self.clock_callback_id] = function() seq_self:play_event_callback() end
    ]]
end

-- function TestTrack:test_
