local checks <const> = require 'checks'
local Protocol <const> = require 'utilities/Protocol'
local Performer <const> = require 'Performer'

--[[

    Class: S E Q U E N C E

    A sequence of events.

    This object represents a 'musical' part
    of the composition. It contains the music
    represented as a named sequence of events.

]]

local Sequence <const> = {
    __type = 'Sequence'
}
Sequence.__index = Sequence

function Sequence.new(id)
    checks('?string')
    local self <const> = setmetatable({}, Sequence)
    self.__type = 'Sequence'
    self.id = id           -- internal
    self.name = 'sequence' -- for user manipulation.
    self.duration = nil
    self.events = {}
    return self
end

function Sequence:record(event)
    checks('Sequence', 'Event')
    local time
    for i = #self.events, 0, -1 do
        time = i > 0 and self.events[i].time or 0
        if event.time >= time then
            table.insert(self.events, i + 1, event)
            break
        end
    end
    return self
end

function Sequence:remove(event_id)
    checks('Sequence', 'string')
    for i, e in ipairs(self.events) do
        if e.id == event_id then
            table.remove(self.events, i)
            break
        end
    end
    return self
end

function Sequence:is_empty()
    checks('Sequence')
    return #self.events == 0
end

Protocol.apply(Sequence, { 'registrable' })

return Sequence
