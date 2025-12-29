local pd <const> = pd or require('./utilities/pd_stub')
local o <const>  = pd.Class:new():register("score") ---@type Score

-- local Track <const> = {

-- }



-- function o:get_track(track_name)
--     local track <const> = self.tracks[track_name]
--     if not track then
--         local track_new <const> = Track.new(track_name)
--         self.tracks[track_name] = track_new
--         return track_new
--     end
--     return track
-- end

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

    -- local track <const> = self:get_track(track_name)
end

return o
