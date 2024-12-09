local checks <const> = require('checks')
local Protocol <const> = require('utilities/Protocol')

--[[

    Class: T R A C K

    A performer able to play out sequence.

    This object is responsible for correctly performing
    a sequence by progressing it's events through time
    by correct time intervals in a chosen manner
    (forwards, backwards etc).

]]

local Performer <const> = {
    __type = 'Track'
}
Performer.__index = Performer

function Performer.new()
    --[[
        Create a new instance of Track.
    ]]
    local self <const> = setmetatable({}, Performer)
    self.__type = 'Performer'
    return self
end

Protocol.apply(Performer, { 'registrable' })

return Performer
