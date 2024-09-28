local lu <const> = require 'LuaUnit'

require 'tests/TestRegistrable'
require 'tests/TestSequence'
require 'tests/TestTrack'

os.exit(lu.LuaUnit.run())
