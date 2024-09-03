local checks <const> = require 'checks'
local Protocol <const> = require 'utilities/Protocol'
local Track <const> = require 'Track'

local Sequence <const> = {
    __type = 'Sequence'
}
Sequence.__index = Sequence

function Sequence.new(id)
    checks('?string')
    local self = setmetatable({}, Sequence)
    self.id = id
    self.duration = nil
    self.events = {}
    return self
end

Protocol.apply(Sequence, { 'registrable' })

return Sequence
