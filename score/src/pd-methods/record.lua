local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Event <const> = require "src/classes/Event"
local Recorder <const> = require "src/classes/Recorder"

--- **`record`** – toggle recording of a `track`.
--- 1) `track` *(str)* – name of a `track`.
--- 2) `speed` *(int)* – default speed at which recording is taken (`1`). When `0`, stops recording.
--- 3) `arm` *(bool)* – start recording only when the first event hits.
--- 4) `offset=0` *(miliseconds, "append" or "prepend")* – at what point in time the new `event`s are added to `track`.
---    * If set to `"prepend"`, content is added before the `track` (including `tracks`'s duration').
---    * If set to `"append"`, content is added after the track.
--- 5) `overdub=0` *(bool)* – new content overrides the old one (default behaviour). Note: does nothing if `offset` is set to "append" or "prepend".
function o:in_1_record(atoms, debug)
    local track_name <const> = atoms[1]
    local speed <const> = atoms[2]
    local arm <const> = atoms[3]
    local offset <const> = atoms[4] or 0
    local overdub <const> = atoms[5]

    if not speed then
        self:error("score: record. Must provide speed value to 'record' method.")
    elseif speed ~= 0 then
        --- Record a new track.
        local track <const> = Event.new(track_name)
        self.recorder = Recorder.new(self, track, speed)
        return
    else
        --- Finish and save recording.
        self.recorder:finish(debug and debug.time)
        local track_new <const> = self.recorder.target
        local track_old <const> = self.tracks[track_name]
        self.recorder = nil
        if track_old then
            --- When track already exists, modify it.
            if offset == "append" then
                track_old:merge(track_new, track_old.duration)
            elseif offset == "prepend" then
                track_old:merge(track_new, -track_new.duration)
            else
                ---@cast offset number
                track_old:merge(track_new, offset, overdub)
            end
        else
            --- When track doesn't exist yet, save it.
            self.tracks[track_name] = track_new
        end
    end
end
