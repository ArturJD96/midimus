local checks <const> = require 'checks'
local Protocol <const> = require 'utilities/Protocol'

local Event <const> = {
    __type = 'Sequence'
}
Event.__index = Event

function Event.new(id)
    checks('?string')
    local self <const> = setmetatable({}, Event)
    self.id = id
    return self
end

Protocol.apply(Event, { 'registrable' })

return Event
