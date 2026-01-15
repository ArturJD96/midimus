local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:in_1_thru(atoms)
    local track_label <const> = atoms[1]
    self.thru = track_label
end
