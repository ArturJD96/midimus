local checks = require('checks')
local Player <const> = {}
Player.__index = Player

function Player.new(track)
    checks('Track')
    --[[
        Create a new instance of Player.
    ]]
    local self = setmetatable({}, Player)
    self.track = track
    return self
end

return Player
