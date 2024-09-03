local checks <const> = require('checks')
local Protocol <const> = require('utilities/Protocol')
local Track <const> = {
    __type = 'Track'
}
Track.__index = Track

function Track.new()
    checks('Sequence')
    --[[
        Create a new instance of Track.
    ]]
    local self <const> = setmetatable({}, Track)
    return self
end

Protocol.apply(Track, { 'registrable' })

return Track
