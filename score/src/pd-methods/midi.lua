local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Event <const> = require "src/classes/Event"
local Emitter <const> = require "src/classes/Emitter"

function o:in_1_midi(bytes)
    if not self.recorder then return end
    local event <const> = Event.new()
    event.emitters = { Emitter.new(bytes) }
    self.recorder:record(event)
end
