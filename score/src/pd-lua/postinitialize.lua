local o <const> = require "src/obj"

function o:postinitialize(sel, atoms)
    self.tracks = {}
    self.players = {}
end
