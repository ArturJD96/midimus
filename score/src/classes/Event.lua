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
        local line <const> = '  - at ' .. tostring(systime2sec(p.offset)) .. ': ' .. p:tostring() .. brk
        players_brk = players_brk .. line
    end
    local s <const> = cls .. ' '
        .. (self.name or '') .. ' ' .. id .. ' [' .. tostring(self) .. ']:' .. brk
        .. "* duration: " .. tostring(time) .. 's' .. brk
        .. "* players:" .. brk
        .. players_brk
    return s
end

return Event
