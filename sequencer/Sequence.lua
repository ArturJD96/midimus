local checks <const> = require 'checks'
local Protocol <const> = require 'utilities/Protocol'
local Track <const> = require 'Track'

local Sequence <const> = {
    __type = 'Sequence'
}
Sequence.__index = Sequence

function Sequence.new(id)
    checks('?string')
    local self <const> = setmetatable({}, Sequence)
    self.id = id           -- internal
    self.name = 'sequence' -- for user manipulation.
    self.duration = nil
    self.events = {}
    return self
end

function Sequence:record(event, time)
    checks('table', 'table', 'number') -- why not 'Sequence', 'Event' instead of 'table'?
    if self.events[time] then
        table.insert(self.events[time], event)
    else
        self.events[time] = { event }
    end
    return self
end

Protocol.apply(Sequence, { 'registrable' })

return Sequence
