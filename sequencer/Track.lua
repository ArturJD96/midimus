local checks <const> = require('checks')
local Protocol <const> = require('utilities/Protocol')
local Track <const> = {}
Track.__index = Track

function Track.new(Sequence)
    checks('Sequence')
    --[[
        Create a new instance of Track.
    ]]
    local self = setmetatable({}, Track)
    self.Sequence = Sequence
    return self
end

Protocol.apply(Track, { 'registrable' })

return Track
