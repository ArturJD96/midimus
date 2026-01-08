local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"

---@type Player
local Player <const> = class("Player", {})
function Player.new(pdObj, offset, events, speed, repeats)
    local self <const> = setmetatable({}, Player) ---@type Player
    self.o = pdObj
    self.id = tostring(math.random())
    self.events = events
    self.offset = offset
    self.speed = speed
    self.repeats = repeats or 1

    -- Shall the clock be destroyed when player does not play?
    -- And also the method?
    self.clock = pd.clock(self.o, self.id)
    self.o[self.id] = self
    self.session = nil

    return self
end

function Player:__call()
    repeats = self.session.repeats_remaining
    local dur_max = 0
    for i, event in ipairs(self.events) do
        event:emit(self.o)
        if event.duration and event.duration > dur_max then
            dur_max = event.duration
        end
    end
    if repeats ~= 0 then
        self.session.repeats_remaining = repeats - 1
        self.clock:delay(dur_max - self.offset)
    else
        self:finish()
        -- self.o[self.id] = nil
    end
end

function Player:play(offset)
    self.session = {
        repeats_remaining = self.repeats
    }
    self.clock:delay(offset or self.offset)
end

function Player:finish()
    self.session = nil
    self.clock:unset()
    for i, event in ipairs(self.events) do
        for j, player in ipairs(event.players) do
            player:finish()
        end
    end
end

function Player:tostring()
    local cls <const> = getmetatable(self).__type
    local brk <const> = '\n        '
    local id <const> = '(' .. self.id .. ')'
    local s <const> = cls .. ' ' .. id .. ' [' .. tostring(self) .. ']:' .. brk
    return s
end

return Player
