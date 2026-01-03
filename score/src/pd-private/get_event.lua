local pd <const> = require "src/pd"
local o <const> = require "src/obj"

function o:get_event(event_label, events)
    if type(event_label) == "number" then
        pd.post("Unnamed Event " .. event_label .. " cannot be found (not implemented).")
    end
    return events[event_label]
end
