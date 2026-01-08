local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:get_player(track_label)
    local track <const> = self.tracks[track_label]
    if not track then
        self:error("Unnamed Event " .. track_label .. " cannot be found.")
    end
    return self.players[track_label]
end
