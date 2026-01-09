local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"

---@type Emitter
local Emitter <const> = class("Emitter", {})
function Emitter.new(data)
    local self <const> = setmetatable({}, Emitter)
    self.data = data
    return self
end

function Emitter:__call(pdObj)
    pdObj:outlet(1, "list", self.data or {})
end

return Emitter
