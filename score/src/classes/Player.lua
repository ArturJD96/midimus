local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"

---@type Player
local Player <const> = class("Player", {})
function Player.new(pdObj, offset, events, speed, repeats)
    local self <const> = setmetatable({}, Player) ---@type Player
    self.o = pdObj
    self.id = tostring(pd.systime())
    self.events = events
    self.offset = offset
    self.speed = speed
    self.repeats = repeats or 0

    -- some callback examples:
    local at_once = function(pdObj)
        local dur_max = 0
        for i, event in ipairs(self.events) do
            event:emit(self.o)
            if event.duration and event.duration > dur_max then
                dur_max = event.duration
            end
        end
        if self.repeats > 0 then
            self.repeats = self.repeats - 1
        end
        if self.repeats ~= 0 then
            self.clock:delay(dur_max - self.offset)
        end
    end

    local strum = function(pdObj) end -- arpeggio-like.

    self.play_callback = at_once

    -- Make callback for clock.
    self.o[self.id] = self.play_callback
    self.clock = pd.clock(self.o, self.id)

    return self
end

function Player:play(offset)
    self.clock:delay(offset or self.offset)
end

function Player:finish()
    self.clock:unset()
    for i, event in ipairs(self.events) do
        for j, player in ipairs(event.players) do
            player:finish()
        end
    end
end

return Player
