local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:in_1_info(atoms)
    local event_label <const> = atoms[1]
    local event <const> = self:get_event(event_label, self.tracks)
    if event then
        pd.post('[score] ' .. event:tostring())
    else
        pd.post("[score] Unknown event: '" .. event_label .. "'.")
    end
end
