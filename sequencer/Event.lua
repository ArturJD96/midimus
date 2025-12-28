package.path = package.path .. ';./../utilities/protocols/?.lua'

local checks <const> = require 'checks'
local Registrable <const> = require 'Registrable'

local Event <const> = {
    __type = 'Event'
}
Event.__index = Event

function Event.new(time, duration, callback)
    checks('?number', '?number', '?function')
    local self <const> = setmetatable({}, Event)
    self.__type = 'Event'
    self.time = time or 0         -- ms
    self.duration = duration or 0 -- ms
    self.callback = callback or function() end
    return self
end

Registrable:conform(Event)

return Event
