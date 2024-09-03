local lu <const> = require 'luaunit'
local Sequence <const> = require 'Sequence'

TestSequence = {}
function TestSequence:setup()
    Sequence.reset_register()
end

os.exit(lu.LuaUnit.run())
