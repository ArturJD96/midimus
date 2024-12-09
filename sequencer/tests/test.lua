local lu <const> = require 'LuaUnit'

require 'tests/TestRegistrable'
require 'tests/TestSequence'
require 'tests/TestPerformer'

os.exit(lu.LuaUnit.run())
