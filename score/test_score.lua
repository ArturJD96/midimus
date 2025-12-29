local lu = require('luaunit')
local o = dofile("score/score.pd_lua") ---@type Score

o:initialize()
o:postinitialize()

TestRecord = {}

function TestRecord:test_dummy()
    o:in_1_record({ "track", 1 })
end

os.exit(lu.LuaUnit.run())
