lu = require 'luaunit'
Track = require 'Track'

TestTrack = {}
function TestTrack:setup()
    Track.reset()
end

function TestTrack:testAdd()
    local default_name1 = 'track_1'
    local track = Track.add()
    lu.assertEquals(Track._count(), 1)
    lu.assertEquals(Track._tracks[default_name1], track)
    lu.assertEquals(track.id, default_name1)
    local test_name = 'test'
    local named_track = Track.add(test_name)
    lu.assertEquals(Track._count(), 2)
    lu.assertEquals(Track._tracks[test_name], named_track)
    lu.assertEquals(named_track.id, test_name)
    local default_name2 = 'track_2'
    local another_track = Track.add()
    lu.assertEquals(Track._count(), 3)
    lu.assertEquals(Track._tracks[default_name2], another_track)
    lu.assertEquals(another_track.id, default_name2)
end

function TestTrack:testRemove()
    lu.assertEquals(Track._count(), 0)
    local test_name = 'test'
    local named_track = Track.add(test_name)
    local track1 = Track.add()
    local track2 = Track.add()
    lu.assertEquals(named_track.id, test_name)
    lu.assertEquals(track1.id, 'track_1')
    lu.assertEquals(track2.id, 'track_2')
    Track.remove('track_1')
    lu.assertEquals(Track._count(), 2)
end

function TestTrack:testRemoveAddDefaultName()
    local int = math.random(3, 8)
    local id = 'track_' .. tostring(int)
    for i = 0, int do Track.add() end
    lu.assertEquals(Track._tracks[id].id, id)
    Track.remove(id)
    Track.add()
    lu.assertEquals(Track._tracks[id].id, id)
end

os.exit(lu.LuaUnit.run())
