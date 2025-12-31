--[[    Helpers (internal).    ]]
---@class (exact) Metatable<I>: { __type: string, __index: Metatable<I> }


--[[    Helpers (public)    ]]
---@alias Time number # And absolute unit of (current) time.
---@alias Miliseconds number
---@alias Systime number
---@alias Speed number # The speed of an imaginary "tape". 0 is still, 1 is normal, -1 is backward and 2 is twice as fast.
---@alias MidiByte number
---@alias MSB MidiByte

---@alias EventID number
---@alias EventName string
---@class EventProps
---
---@alias PlayerID string
---@alias PlayerName string


--[[    Event types.    ]]
---@class (exact) Event: Metatable<Event>
---@field new fun(name?:string): Event
---properties
---@field id EventID When event was created.
---@field name EventName
---@field duration Miliseconds How long does the event lasts.
---@field data {midi:MidiByte[]} What data act out when event is called.
---@field players Player[] Which players does this event control.
---@field emit_callback fun(self:Event, o:Score) What the Pd object does.
---methods
---@field tostring fun(self:Event): string # Turn an event into a string representation (e.g. for logging).
---@field emit fun(self:Event, o:Score) # Do this when event is called (e.g. output something from an pd box's outlet – this is defined in emit_callback).


--[[    Player types.   ]]
---@class (exact) Player: Metatable<Player>
---@field new fun(o:Score, offset:Miliseconds, events:Event[], speed:Speed, repeats?:number): Player
---properties
---@field o Score Backreference to the top object.
---@field id PlayerID
---@field clock Clock
---@field events Event[] What event to play next.
---@field offset Miliseconds How long to wait for event to play
---@field speed Speed How fast event acts out (1: as is).
---@field repeats? number How many times player repeats its event.
---@field play_callback fun(self: Player, offset?:Miliseconds) The way this player plays it's event.
---methods
---@field play fun(self: Player, offset?:Miliseconds) Play attached events (using play_callback).


--[[    Recorder.   ]]
---@class (exact) Recorder: Metatable<Recorder>
---@field new fun(o:Score, track:Event, speed:Speed): Recorder
---propertiers
---@field o Score Backreference to the top object.
---@field target Event # An event to which the newly recorded events are subjugated.
---@field start Systime
---@field speed Speed
---methods
---@field record fun(self: Recorder, event: Event): nil
---@field finish fun(self: Recorder): nil


--[[    Main object.    ]]
---@class (exact) Score: PDObject
---properties
---@field recorder Recorder
---@field players { [PlayerName]: Player }
---@field tracks { [EventName]: Event }
---private methods
---@field get_event fun(self: Score, event_label: EventName|EventID): Event|nil # Returns the track named track_name. If not such track exists yet, makes a new one.
---public methods
---@field in_1_info fun(self: Score, atoms: { [1]: EventID|EventName}): nil
---@field in_1_midi fun(self: Score, bytes: MidiByte[]): nil
---@field in_1_play fun(self: Score, atoms: { [1]: EventName, [2]: Speed}): nil
---@field in_1_reload fun(self: Score): nil
---@field in_1_record fun(self: Score, atoms: { [1]: EventName, [2]: Speed }): nil
