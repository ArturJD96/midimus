local pd <const> = pd or require('./utilities/pd_stub')
local o <const>  = pd.Class:new():register("score") ---@type Score

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

---@type Metatable<Event, fun(name?:string): Event>
local Event <const> = class("Event", {})
Event.new = function(name)
    local event <const> = setmetatable({}, Event) ---@type Event
    event.id = os.time()
    event.name = name
    event.duration = nil
    event.props = {}
    event.players = {}
    return event
end

---comment
---@return string
function Event:tostring()
    local tab = '        '
    local id <const> = '(' .. self.id .. ')'
    local s = "Event "
        .. (self.name or '') .. ' ' .. id .. ' [' .. tostring(self) .. ']:\n'
        .. tab .. "* duration: " .. tostring(self.duration)
    return s
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

function o:in_1_record(atoms)
    local track_name <const> = atoms[1]
    local toggle <const> = atoms[2]

    local track <const> = self:get_track(track_name)
end

function o:in_1_info(atoms)
    local event_label <const> = atoms[1]
    local event <const> = self:get_event(event_label)
    if event then
        pd.post('[score] ' .. event:tostring())
    else
        pd.post("[score] Event " .. event_label .. " does not exist.")
    end
end

return o
