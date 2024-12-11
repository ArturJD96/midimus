local lu <const> = require 'LuaUnit'

require 'tests/TestRegistrable'
require 'tests/TesPDable'

os.exit(lu.LuaUnit.run())
