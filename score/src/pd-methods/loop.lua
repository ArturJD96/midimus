local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:in_1_loop(atoms)
    local track_name <const> = atoms[1] ---@type string
    local toggle <const> = atoms[2] ---@type boolean
    local speed <const> = atoms[3] ---@type Speed
    o:in_1_repeat({ track_name, -1, speed })
end
