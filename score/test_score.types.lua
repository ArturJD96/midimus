--[[    Helpers (internal).    ]]
---@class (exact) Metatable<I>: { __type: string, __index: Metatable<I> }


--[[    Helpers (public)    ]]
---@alias Time number # And absolute unit of (current) time.
---@alias Miliseconds number
---@alias Speed number # The speed of an imaginary "tape". 0 is still, 1 is normal, -1 is backward and 2 is twice as fast.
---@alias MidiByte number
---@alias MSB MidiByte

---@alias EventID number
---@alias EventName string
---@class EventProps


--[[    Event types.    ]]
---@class (exact) Event: Metatable<Event>
---@field new fun(name?:string): Event
---properties
---@field id EventID When event was created.
---@field duration Miliseconds How long does the event lasts.
---@field players Player[] Which players does this event control.
---@field props EventProps[] What properties act out when event is called.
---@field name EventName
---methods
---@field tostring fun(self:Event): string # Turn an event into a string representation (e.g. for logging).


--[[    Player types.   ]]
---@class (exact) Player: Metatable<Player>
---@field new fun(offset:Miliseconds, events:Event[], speed:Speed, repeats?:number): Player
---properties
---@field events Event[] What event to play next.
---@field offset Miliseconds How long to wait for event to play
---@field speed Speed How fast event acts out (1: as is).
---@field repeats? number How many times player repeats its event.


--[[    Recorder.   ]]
---@class (exact) Recorder: Metatable<Recorder>
---@field new fun(track:Event, speed:Speed): Recorder
---propertiers
---@field start Time
---@field speed Speed
---@field target Event # An event to which the newly recorded events are subjugated.
---methods
---@field record fun(self: Recorder, event: Event): nil


--[[    Main object.    ]]
---@class (exact) Score: PDObject
---properties
---@field recorder Recorder
---@field tracks { [EventName]: Event }
---private methods
---@field get_track fun(self: Score, track_name: EventName): Event # Returns the track named track_name. If not such track exists yet, makes a new one.
---@field get_event fun(self: Score, event_label: EventName|EventID): Event|nil # Returns the track named track_name. If not such track exists yet, makes a new one.
---public methods
---@field in_1_info fun(self: Score, atoms: { [1]: EventID|EventName}): nil
---@field in_1_midi fun(self: Score, bytes: { [1]: MSB, [number]: MidiByte}): nil
---@field in_1_reload fun(self: Score): nil
---@field in_1_record fun(self: Score, atoms: { [1]: EventName, [2]: Speed }): nil
