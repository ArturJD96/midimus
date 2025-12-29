local lu = require('luaunit')
local o = dofile("score/score.pd_lua") ---@type Score

function init()
    o:initialize(nil, {})
    o:postinitialize(nil, {})
end

TestRecord = {}

function TestRecord:test_works()
    init()
    local t = "dummy"
    o:in_1_record({ t, 1 })
    o:in_1_midi({ 1, 2, 3, 4 })
    o:in_1_midi({ 5, 6, 7, 8 })
    o:in_1_record({ t, 0 })
    local track = o.tracks[t]
    lu.assertEquals(#track.players, 2)
    lu.assertTrue(track.duration > 0)
    lu.assertNotNil(track:tostring())
end

os.exit(lu.LuaUnit.run())
