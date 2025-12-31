local lu = require('luaunit')
local o = dofile("score/score.pd_lua") ---@type Score

function init(o)
    o:finalize()
    o:initialize(nil, {})
    o:postinitialize(nil, {})
end

function record_dummy_track(o)
    local t = "dummy"
    o:in_1_record({ t, 1 })
    o:in_1_midi({ 1, 2, 3, 4 })
    o:in_1_midi({ 5, 6, 7, 8 })
    o:in_1_record({ t, 0 })
    local track = o.tracks[t]
    return track
end

TestRecord = {}

function TestRecord:test_works()
    init(o)
    local track = record_dummy_track(o)
    lu.assertEquals(#track.players, 2)
    lu.assertTrue(track.duration > 0)
    lu.assertNotNil(track:tostring())
end

TestPlay = {}

function TestPlay:test_works()
    init(o)
    local track = record_dummy_track(o)
    o:in_1_play({ track.name, 1 })
    lu.assertNotNil(o.players[track.name])
    o:in_1_play({ track.name, 0 })
end

os.exit(lu.LuaUnit.run())
