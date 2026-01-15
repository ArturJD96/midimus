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
    -- Shall it be moved to :play() or :__call()?
    self.clock = pd.clock(self.o, self.id)
    self.o[self.id] = self
    self.session = nil

    return self
end

function Player:__call()
    local ss <const> = self.session
    ss.repeats = ss.repeats - 1
    local dur_max = 0
    for _, event in pairs(self.events) do
        event:emit(self.o)
        if event.duration and event.duration > dur_max then
            dur_max = event.duration
        end
    end
    if ss.repeats > 0 then
        self.clock:delay(dur_max - self.offset)
    end
end

function Player:play(offset)
    self.session = {
        repeats = self.repeats
    }
    pd.post(tostring(offset) .. " " .. tostring(self.offset))
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
    local id <const> = '(' .. self.id .. ')'
    local s <const> = cls .. ' ' .. id .. ' [' .. tostring(self) .. ']:'
    return s
end

return Player
