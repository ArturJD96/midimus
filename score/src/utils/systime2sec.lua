local pd <const> = require "src/pd"

local function systime2sec(systime)
    return systime / pd.TIMEUNITPERMSEC * 10
end

return systime2sec
