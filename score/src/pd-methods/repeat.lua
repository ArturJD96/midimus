local pd <const> = require "src/pd"
local o <const> = require "src/obj"

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
