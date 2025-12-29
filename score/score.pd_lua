local pd <const> = pd or require('./utilities/pd_stub')
local o <const>  = pd.Class:new():register("score") ---@type Score

---Return current time.
---@return Time
local function time()
    return os.clock()
end

---Calc (absolute) time from the given stamp.
---@param start Time
---@return Time
local function timedelta(start)
    return math.abs(time() - start)
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
    self.id = os.time()
    self.name = name
    self.duration = nil
    self.props = {}
    self.players = {}
    return self
end

function Event:tostring()
    local cls = getmetatable(self).__type
    local brk = '\n        '
    local id <const> = '(' .. self.id .. ')'
    local players_brk = ''
    for i, p in ipairs(self.players) do
        local line = '  - at ' .. tostring(p.offset) .. ': ' .. tostring(p) .. brk
        players_brk = players_brk .. line
    end
    local s = cls .. ' '
        .. (self.name or '') .. ' ' .. id .. ' [' .. tostring(self) .. ']:' .. brk
        .. "* duration: " .. tostring(self.duration) .. brk
        .. "* players:" .. brk
        .. players_brk
    return s
end

---@type Player
local Player <const> = class("Player", {})
function Player.new(offset, events, speed, repeats)
    local self = setmetatable({}, Player) ---@type Player
    self.events = events
    self.offset = offset
    self.speed = speed
    self.repeats = repeats
    return self
end

---@type Recorder
local Recorder <const> = class("Recorder", {})
function Recorder.new(track, speed)
    local self = setmetatable({}, Recorder) ---@type Recorder
    self.start = time()
    self.speed = speed
    self.target = track
    return self
end

function Recorder:record(event)
    local dt = timedelta(self.start)
    table.insert(self.target.players, Player.new(dt, { event }, self.speed))
end

function Recorder:finish()
    self.target.duration = timedelta(self.start)
end

function o:get_track(track_name)
    local track <const> = self.tracks[track_name]
    if not track then
        local track_new <const> = Event.new(track_name)
        self.tracks[track_name] = track_new
        return track_new
    end
    return track
end

function o:get_event(event_label)
    if type(event_label) == "number" then
        pd.post("Unnamed Event " .. event_label .. " cannot be found (not implemented).")
    end
    return self.tracks[event_label]
end

--[[
	    pd-lua.
]]

function o:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 2
    return true
end

function o:postinitialize(sel, atoms)
    self.tracks = {}
end

function o:finalize() end

function o:in_1_reload()
    self:dofilex(self._scriptname)
end

--[[
	    Pure Data.
]]

function o:in_1_info(atoms)
    local event_label <const> = atoms[1]
    local event <const> = self:get_event(event_label)
    if event then
        pd.post('[score] ' .. event:tostring())
    else
        pd.post("[score] Unknown event: '" .. event_label .. "'.")
    end
end

function o:in_1_midi(bytes)
    if not self.recorder then return end
    self.recorder:record(bytes)
end

-- function o:in_1_play(atoms)
--     local speed <const> = atoms[2]

--     -- if speed == 0 then

--     -- end
-- end

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
    self.recorder = Recorder.new(track, speed)
end

return o
