checks = require('checks')
Player = require 'Player'

local Track <const> = {
    _defaultName = 'track_',
    _tracks = {},
    __type = 'Track'
}
Track.__index = Track

function Track._count()
    checks()
    --[[
        Count all existing tracks
        (stored in Track._tracks table).
    ]]
    local c = 0
    for id, _ in pairs(Track._tracks) do c = c + 1 end
    return c
end

function Track._get_default_id()
    checks()
    --[[
        Get the next default name for an unnamed new track.

        When creating a new Track without giving it
        an explicit id, default ID is assigned.

        This default ID consists of initial Track._defaultName
        and a number.

        Continuity of numbers is strived to be preserved.
        Thus, next id will end with the highest number
        UNLESS there is a gap between numbers.

        Examples:
        1) track_1, track_2, track_3 -> track_4
        2) track_1, track_3, track_5 -> track_2 (between 1 and 3)
    ]]
    local ids, id_num = {}, nil
    for id, _ in pairs(Track._tracks) do
        id_num = id:match('^' .. Track._defaultName .. '(%d+)$')
        if id_num and (id_num:sub(0, 1) ~= 0) then
            table.insert(ids, tonumber(id_num))
        end
    end
    if #ids == 0 then return Track._defaultName .. '1' end
    table.sort(ids)
    local id = 0
    for _, n in ipairs(ids) do
        if n - id == 1 then id = n else break end
    end
    return Track._defaultName .. tostring(id + 1)
end

function Track._new(id)
    checks('?string')
    --[[
        Instantiate new track (without putting it into Track._tracks).
        NOTE: use Track.add() to instantiate new Track.
    ]]
    local self = setmetatable({}, Track)
    self.id = id or Track._get_default_id()
    self.duration = nil
    self.events = {}
    self.player = Player.new(self)
    self.__type = 'Track'
    return self
end

function Track.reset()
    checks()
    --[[
        Remove all tracks.
    ]]
    Track._tracks = {}
    collectgarbage()
end

function Track.add(id)
    checks('?string')
    --[[
        Add new track to the existing Tracks.
    ]]
    local track = Track._new(id)
    assert(not Track._tracks[track.id], 'Track ' .. track.id .. ' already exists.')
    Track._tracks[track.id] = track
    return track
end

function Track.remove(id)
    checks('string')
    --[[
        Remove a track from the existing tracks.
        NOTE: to be removed, track must exist.
    ]]
    assert(Track._tracks[id], 'Cannot remove non existent track ' .. id)
    Track._tracks[id] = nil
end

return Track
