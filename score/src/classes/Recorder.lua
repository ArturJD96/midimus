local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"
local Player <const> = require "src/classes/Player"

---@type Recorder
local Recorder <const> = class("Recorder", {})
function Recorder.new(pdObj, track, speed)
    local self <const> = setmetatable({}, Recorder) ---@type Recorder
    self.o = pdObj
    self.start = pd.systime()
    self.speed = speed
    self.target = track
    return self
end

function Recorder:record(event)
    local dt <const> = pd.timesince(self.start)
    table.insert(self.target.players, Player.new(self.o, dt, { event }, self.speed))
end

function Recorder:finish()
    self.target.duration = pd.timesince(self.start)
end

return Recorder
