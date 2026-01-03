local pd <const> = pd or require "score/src/utils/pd_stub"
local o <const>  = pd.Class:new():register("score") ---@type Score



local function systime2sec(systime)
    return systime / pd.TIMEUNITPERMSEC * 10
end

---Prepare a metatable to be implemented as a "class."
---@generic I, J
---@param name `I`
---@param meta { [string]: any }
---@param parent? Metatable<J>
---@return Metatable<I>
local function class(name, meta, parent)
    local c <const> = {
        __type = name,
        table.unpack(meta)
    }
    c.__index = parent or c
    return c
end



---@type Event
local Event <const> = class("Event", {})
function Event.new(name)
    local self <const> = setmetatable({}, Event)
    self.id = pd.systime()
    self.name = name
    self.duration = nil
    self.data = {}
    self.players = {}

    -- some callback examples:
    local midi = function(event_self, pdObj)
        if not event_self.data.midi then return end
        pdObj:outlet(1, "list", event_self.data.midi)
    end

    self.emit_callback = midi

    return self
end

function Event:emit(pdObj)
    for i, player in ipairs(self.players) do
        player:play()
    end
    self:emit_callback(pdObj)
end

function Event:tostring()
    local cls <const> = getmetatable(self).__type
    local brk <const> = '\n        '
    local id <const> = '(' .. self.id .. ')'
    local time <const> = systime2sec(self.duration)
    local players_brk = ''
    for i, p in ipairs(self.players) do
        local line <const> = '  - at ' .. tostring(systime2sec(p.offset)) .. ': ' .. tostring(p) .. brk
        players_brk = players_brk .. line
    end
    local s <const> = cls .. ' '
        .. (self.name or '') .. ' ' .. id .. ' [' .. tostring(self) .. ']:' .. brk
        .. "* duration: " .. tostring(time) .. 's' .. brk
        .. "* players:" .. brk
        .. players_brk
    return s
end



---@type Player
local Player <const> = class("Player", {})
function Player.new(pdObj, offset, events, speed, repeats)
    local self <const> = setmetatable({}, Player) ---@type Player
    self.o = pdObj
    self.id = tostring(pd.systime())
    self.events = events
    self.offset = offset
    self.speed = speed
    self.repeats = repeats or 0

    -- some callback examples:
    local at_once = function(pdObj)
        local dur_max = 0
        for i, event in ipairs(self.events) do
            event:emit(self.o)
            if event.duration and event.duration > dur_max then
                dur_max = event.duration
            end
        end
        if self.repeats > 0 then
            self.repeats = self.repeats - 1
        end
        if self.repeats ~= 0 then
            self.clock:delay(dur_max - self.offset)
        end
    end

    local strum = function(pdObj) end -- arpeggio-like.

    self.play_callback = at_once

    -- Make callback for clock.
    self.o[self.id] = self.play_callback
    self.clock = pd.clock(self.o, self.id)

    return self
end

function Player:play(offset)
    self.clock:delay(offset or self.offset)
end

function Player:finish()
    self.clock:unset()
    for i, event in ipairs(self.events) do
        for j, player in ipairs(event.players) do
            player:finish()
        end
    end
end



---@type Recorder
local Recorder <const> = class("Recorder", {})
function Recorder.new(pdObj, track, speed)
    local self <const> = setmetatable({}, Recorder) ---@type Recorder
    self.o = pdObj
    self.start = pd.systime()
    self.speed = speed
    self.target = track
    return self
end

function Recorder:record(event)
    local dt <const> = pd.timesince(self.start)
    table.insert(self.target.players, Player.new(self.o, dt, { event }, self.speed))
end

function Recorder:finish()
    self.target.duration = pd.timesince(self.start)
end



function o:get_event(event_label, events)
    if type(event_label) == "number" then
        pd.post("Unnamed Event " .. event_label .. " cannot be found (not implemented).")
    end
    return events[event_label]
end


function o:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 2
    return true
end


function o:postinitialize(sel, atoms)
    self.tracks = {}
    self.players = {}
end


function o:finalize() end


function o:in_1_reload()
    self:dofilex(self._scriptname)
end


function o:in_1_info(atoms)
    local event_label <const> = atoms[1]
    local event <const> = self:get_event(event_label, self.tracks)
    if event then
        pd.post('[score] ' .. event:tostring())
    else
        pd.post("[score] Unknown event: '" .. event_label .. "'.")
    end
end


function o:in_1_loop(atoms)
    local track_name <const> = atoms[1] ---@type string
    local toggle <const> = atoms[2] ---@type boolean
    local speed <const> = atoms[3] ---@type Speed
    o:in_1_repeat({ track_name, -1, speed })
end


function o:in_1_midi(bytes)
    if not self.recorder then return end
    local event <const> = Event.new()
    event.data.midi = bytes
    self.recorder:record(event)
end


function o:in_1_play(atoms)
    local track_name <const> = atoms[1]
    local speed <const> = atoms[2]
    local repeats <const> = atoms[3] or 0

    if not track_name then
        pd.post("[score] Unknown event: '" .. track_name .. "'.")
        return
    end

    local track <const> = self:get_event(track_name, self.tracks)
    local player = self:get_event(track_name, self.players) ---@type Player

    if player then
        player.clock:unset()
        player.speed = speed
        player.repeats = repeats
    else
        player = Player.new(self, 0, { track }, speed, repeats)
    end

    if speed == 0 then
        player:finish()
        self.players[track_name] = nil
        return
    end

    self.players[track_name] = player
    player:play()
end


function o:in_1_record(atoms)
    local track_name <const> = atoms[1]
    local speed <const> = atoms[2]

    if speed == 0 then
        self.recorder:finish()
        self.recorder = nil
        return
    end

    local track <const> = Event.new(track_name)
    self.tracks[track_name] = track
    self.recorder = Recorder.new(self, track, speed)
end


-- function o:in_1_repeat(atoms)
--     local track_name <const> = atoms[1]
--     local n_repeats <const> = atoms[2]
--     local speed <const> = atoms[3] or 1

--     if not track_name then
--         pd.post("[score] Unknown event: '" .. track_name .. "'.")
--         return
--     end

--     local track <const> = self:get_event(track_name)

--     if n_repeats == 0 then
--         -- self.players[track_name]:finish()
--         self.players[track_name] = nil
--         return
--     end

--     local player <const> = Player.new(self, 0, { track }, speed, n_repeats)
--     self.players[track_name] = player
--     player:play()
-- end


return o