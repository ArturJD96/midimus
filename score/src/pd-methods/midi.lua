local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Event <const> = require "src/classes/Event"

function o:in_1_midi(bytes)
    if not self.recorder then return end
    local event <const> = Event.new()
    event.data.midi = bytes
    self.recorder:record(event)
end
