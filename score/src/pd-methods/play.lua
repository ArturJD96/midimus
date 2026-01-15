local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Player <const> = require "src/classes/Player"

function o:in_1_play(atoms)
    local track_name <const> = atoms[1] ---@type EventName
    local speed <const> = atoms[2] ---@type Speed
    local repeats <const> = atoms[3] ---@type integer | nil

    local track <const> = self:get_track(track_name)
    if not track then
        self:error("[score] Unknown event: '" .. track_name .. "'.")
        return
    end

    local player_old <const> = self:get_player(track_name)
    if player_old then
        player_old:finish()
        self.players[track_name] = nil
    end

    if speed == 0 then return end

    local player_new <const> = Player.new(self, 0, { track }, speed, repeats)

    self.players[track_name] = player_new
    player_new:play()
end
