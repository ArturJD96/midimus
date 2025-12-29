---@alias Miliseconds number
---@alias Date number
---@alias Speed number # The speed of an imaginary "tape". 0 is still, 1 is normal, -1 is backward and 2 is twice as fast.
---@alias TrackName string # Name of a Track.

---@class EventProps

---@class (exact) Player
---@field public event Event
---@field public offset Miliseconds
---@field public speed Speed
---@field public repeats number

---@class (exact) Event
---@field public born Date
---@field public duration Miliseconds
---@field public players Player
---@field public props EventProps

---@class (exact) Track: Event
---@field public name? TrackName
---@field public new Track

---@class (exact) Score: PDObject
---@field public tracks { [TrackName]: Track }
---@field public get_track fun(self: Score, track_name: TrackName): Track # Returns the track named track_name. If not such track exists yet, makes a new one.
---@field public in_1_reload fun(self: Score): nil
---@field public in_1_record fun(self: Score, atoms: { [1]: string, [2]: number }): nil
