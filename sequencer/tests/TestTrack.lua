local lu <const> = require 'luaunit'
local Sequence <const> = require 'Sequence'
local Track <const> = require 'Track'

TestSequence = {}
function TestTrack:setup()
    -- Sequence.reset()
end

os.exit(lu.LuaUnit.run())
