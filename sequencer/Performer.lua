package.path = package.path .. ';./../utilities/protocols/?.lua'

local checks <const> = require 'checks'
local Registrable <const> = require 'Registrable'

--[[

    Class: T R A C K

    A performer able to play out sequence.

    This object is responsible for correctly performing
    a sequence by progressing it's events through time
    by correct time intervals in a chosen manner
    (forwards, backwards etc). It remembers the previously
    played event so it can resume playing after being stopped.

]]

local Performer <const> = {
    __type = 'Performer'
}
Performer.__index = Performer

function Performer.new()
    --[[
        Create a new instance of Track.
    ]]
    local self <const> = setmetatable({}, Performer)
    self.__type = 'Performer'
    self._current_time = 0
    self._lasting_events = {}
    self._next_event = nil
    self._total_duration = 0
    self.sequence = nil
    return self
end

function Performer:set_sequence(sequence)
    checks('Performer', 'Sequence')
    self._current_time = 0 -- TO DO: if other sequence was already set, leave time as is
    self._lasting_event = nil
    self._next_event = sequence.events[0]
    self._total_duration = sequence:_calc_duration() -- [ms]
    self.sequence = sequence
end

function Performer:set_time(time)
    checks('Performer', 'number')
    if time < 0 then time = 0 end
    self._current_time = math.min(time, self._total_duration)
    self._lasting_events = {}
    self._next_event = nil
    -- set current event
    for _, event in ipairs(self.sequence.events) do
        -- TO DO: this needs to be elaborated
        -- if the performer plays BACKWARDS
        -- or different event launching speed
        -- or played slowed down.
        -- Most likely, conditions needs to be
        -- dependent on the performing mode.
        local event_stop_time = event.time + event.duration
        if event.time < self._current_time then
            if event_stop_time > self._current_time then
                table.insert(self._lasting_events, event)
            end
        elseif not self._next_event then
            self._next_event = event
            break
        end
    end
end

function Performer:play()
    for i, event in ipairs(self.sequence.events) do
        event:callback()
    end
end

Registrable:conform(Performer)

return Performer
