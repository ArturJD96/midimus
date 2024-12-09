local checks <const> = require 'checks'
local Protocol <const> = require 'utilities/Protocol'

local Event <const> = {
    __type = 'Event'
}
Event.__index = Event

function Event.new(time, duration)
    checks('?number', '?number')
    local self <const> = setmetatable({}, Event)
    self.__type = 'Event'
    self.time = time or 0         -- ms
    self.duration = duration or 0 -- ms
    return self
end

Protocol.apply(Event, { 'registrable' })

return Event
