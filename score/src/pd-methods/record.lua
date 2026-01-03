local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Recorder <const> = require "src/classes/Recorder"

function o:in_1_record(atoms)
    local track_name <const> = atoms[1]
    local speed <const> = atoms[2]

    if speed == 0 then
        self.recorder:finish()
        self.recorder = nil
        return
    end

    local track <const> = Event.new(track_name)
    self.tracks[track_name] = track
    self.recorder = Recorder.new(self, track, speed)
end
