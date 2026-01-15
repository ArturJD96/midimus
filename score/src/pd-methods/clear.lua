local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:in_1_clear(atoms)
    local track_label <const> = atoms[1]
    local track <const> = self:get_track(track_label)
    if track then
        self.tracks[track_label] = nil
    end
end
