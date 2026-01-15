local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Event <const> = require "src/classes/Event"
local Emitter <const> = require "src/classes/Emitter"

function o:in_1_midi(bytes, debug)
    if self.thru then
        self:outlet(1, "list", { self.thru, table.unpack(bytes) })
    end
    if self.recorder then
        local tags <const> = { self.recorder.target.name }
        local event <const> = Event.new()
        local emitter = Emitter.new(tags, bytes)
        event.emitters = { emitter }
        self.recorder:record(event, debug and debug.time)
    end
end
