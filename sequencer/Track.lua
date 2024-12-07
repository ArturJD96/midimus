local checks <const> = require('checks')
local Protocol <const> = require('utilities/Protocol')

--[[

    Class: T R A C K

    A track loading & performing a loaded sequence.

    This object is responsible for correctly performing
    a sequence by progressing it's events through time
    by correct time intervals in a chosen manner
    (forwards, backwards etc).

]]

local Track <const> = {
    __type = 'Track'
}
Track.__index = Track

function Track.new()
    --[[
        Create a new instance of Track.
    ]]
    local self <const> = setmetatable({}, Track)
    self.__type = 'Track'
    return self
end

Protocol.apply(Track, { 'registrable' })

return Track
