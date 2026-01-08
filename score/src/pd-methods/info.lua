local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:in_1_info(atoms)
    local track_label <const> = atoms[1]
    local track <const> = self:get_track(track_label)
    if track then
        pd.post('[score] ' .. track:tostring())
    else
        self:error("[score] Unknown event: '" .. track_label .. "'.")
    end
end
