local o <const> = require "src/obj"

function o:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 2
    return true
end
