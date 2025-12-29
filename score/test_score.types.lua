--[[    Helpers.    ]]
---@class (exact) Metatable<I, Ctor>: { __type: string, __index: Metatable<I>, new?: Ctor, [any]: any }

--[[    Main object.    ]]
---@class (exact) Score: PDObject
---@field public recorder Recorder
---@field public tracks { [EventName]: Event }
---@field public get_track fun(self: Score, track_name: EventName): Event # Returns the track named track_name. If not such track exists yet, makes a new one.
---@field public get_event fun(self: Score, event_label: EventName|EventID): Event|nil # Returns the track named track_name. If not such track exists yet, makes a new one.
---@field public in_1_info fun(self: Score, atoms: { [1]: EventID|EventName}): nil
---@field public in_1_midi fun(self: Score, bytes: { [1]: MSB, [number]: MidiByte})
---@field public in_1_reload fun(self: Score): nil
---@field public in_1_record fun(self: Score, atoms: { [1]: EventName, [2]: Speed }): nil

--[[    Score types.    ]]
---@alias Time number # And absolute unit of (current) time.
---@alias Miliseconds number
---@alias Speed number # The speed of an imaginary "tape". 0 is still, 1 is normal, -1 is backward and 2 is twice as fast.
---@alias MidiByte number
---@alias MSB MidiByte
--[[    Event types.    ]]
---@alias EventID number
---@alias EventName string
---@class EventProps

-- @class (exact) EventMeta: Metatable<Event>

---@class (exact) Event
---@field public id EventID When event was created.
---@field public duration Miliseconds How long does the event lasts.
---@field public players Player[] Which players does this event control.
---@field public props EventProps[] What properties act out when event is called.
---@field public name EventName
---@field public tostring fun(self:Event): string

--[[    Player types.   ]]
---@class (exact) Player
---@field public events Event[] What event to play next.
---@field public offset Miliseconds How long to wait for event to play
---@field public speed Speed How fast event acts out (1: as is).
---@field public repeats? number How many times player repeats its event.

--[[    Recorder.   ]]
---@class (exact) Recorder
---@field public start Time
---@field public speed Speed
---@field public target Event # An event to which the newly recorded events are subjugated.
---@field public record fun(self: Recorder, event: Event): nil
