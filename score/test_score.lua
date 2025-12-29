local lu = require('luaunit')
local o = dofile("score/score.pd_lua") ---@type Score

function init()
    o:initialize()
    o:postinitialize()
end

TestRecord = {}

function TestRecord:test_dummy()
    init()
    local t = "dummy"
    o:in_1_record({ t, 1 })
    o:in_1_midi({ 1, 2, 3, 4 })
    o:in_1_midi({ 5, 6, 7, 8 })
    o:in_1_record({ t, 0 })
    lu.assertEquals(#o.tracks[t].players, 2)
end

os.exit(lu.LuaUnit.run())
