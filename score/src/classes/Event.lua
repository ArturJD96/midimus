local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"
local systime2sec <const> = require "src/utils/systime2sec"

---@type Event
local Event <const> = class("Event", {})
function Event.new(name)
    local self <const> = setmetatable({}, Event)
    self.id = tostring(math.random())
    self.name = name
    self.duration = 0
    self.players = {}
    self.emitters = {}
    return self
end

function Event:emit(pdObj)
    for i, player in pairs(self.players) do
        player:play()
    end
    for k, emitter in pairs(self.emitters) do
        emitter(pdObj)
    end
end

function Event:tostring()
    local cls <const> = getmetatable(self).__type
    local brk <const> = '\n        '
    local id <const> = '(' .. self.id .. ')'
    local time <const> = systime2sec(self.duration)
    local players_brk = ''
    for _, p in pairs(self.players) do
        local line <const> = '  - at ' .. tostring(systime2sec(p.offset)) .. ': ' .. p:tostring() .. brk
        players_brk = players_brk .. line
    end
    local s <const> = cls .. ' '
        .. (self.name or '') .. ' ' .. id .. ' [' .. tostring(self) .. ']:' .. brk
        .. "* duration: " .. tostring(time) .. 's' .. brk
        .. "* players" .. "(#" .. #self.players .. "):" .. brk
        .. players_brk
    return s
end

function Event:delete_all_players_safely()
    self.players = {}
end

function Event:merge(other, time_offset, overdub)
    time_offset = time_offset or 0
    local cut_start <const> = time_offset
    local cut_end <const> = time_offset + other.duration
    --- When not overdubbing, remove old `players`
    if not overdub then
        local players <const> = self.players
        if cut_start == cut_end then
            --- A single selected time moment (duration 0)
            for i, p in pairs(self.players) do
                if p.offset == cut_start then
                    self.players[i] = nil
                end
            end
        else
            --- Within time range. Events at the last moment are excluded.
            -- for k, v in pairs(self.players) do print('INSIDE:', k, v.offset) end
            for i, p in pairs(self.players) do
                -- print(i, cut_start, cut_end, p.offset)
                if (p.offset >= cut_start) and (p.offset < cut_end) then
                    self.players[i] = nil
                end
            end
            -- print(#self.players)
        end
    end
    --- Modify `track` players table and durations.
    if time_offset < 0 then
        --- Add all `tracks`s `players` to `other, modify their offset
        --- and put it sacve it as `tracks` players.
        for _, p in pairs(self.players) do
            p.offset = p.offset - time_offset
            table.insert(other.players, p)
        end
        self.players = other.players
    else
        --- Add all `other`'s `players` and modify their offset.
        for _, p in pairs(other.players) do
            p.offset = p.offset + time_offset
            table.insert(self.players, p)
        end
    end
    --- Analyze and update duration of the event.
    self.duration = math.max(self.duration, other.duration + math.abs(time_offset))
end

return Event
