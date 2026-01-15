local pd <const> = pd or require "src/utils/pd_stub"
local o <const> = require "src/obj"
local class <const> = require "src/utils/class"

---@type Emitter
local Emitter <const> = class("Emitter", {})
function Emitter.new(tags, data)
    local self <const> = setmetatable({}, Emitter)
    self.tags = tags
    self.data = data
    return self
end

function Emitter:__call(pdObj)
    for _, tag in ipairs(self.tags) do
        pdObj:outlet(1, "list", { tag, table.unpack(self.data) })
    end
end

return Emitter
