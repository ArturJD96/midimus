local pd <const> = require "src/pd"
local o <const> = require "src/obj"
local Player <const> = require "src/classes/Player"

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
