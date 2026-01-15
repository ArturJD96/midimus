local lfs <const> = require "lfs"

local DIR <const> = "src"

---comment
---@param dir string
---@param fnames? string[] # Names of files.
---@return string
local function get_code(dir, fnames)
    local dir_full <const> = DIR .. '/' .. dir
    local content = ""
    local patt_requires = 'local %w+ <const> =.*require "[a-zA-Z0-9/]+"'
    for _, script in ipairs(fnames) do
        local file_name = script:match('(.+)%.lua$')
        if file_name == "pd_stub" then
            -- ignore.
        elseif file_name then
            local patt_returns = 'return ' .. script:match('(.+)%.lua$') .. '\n$'
            local fp = dir_full .. '/' .. script
            print('* parsing ' .. fp)
            local file = io.open(fp, "r")
            local text = file:read("a")
            local code = text:gsub(patt_requires, ""):gsub(patt_returns, "")
            file:close()
            content = content .. code
        end
    end
    return content
end

print("Compiling score.pd_lua...")

local utils <const>   = get_code("utils", {
    "systime2sec.lua",
    "class.lua",
})
local classes <const> = get_code("classes", {
    "Emitter.lua",
    "Event.lua",
    "Player.lua",
    "Recorder.lua"
})
local private <const> = get_code("pd-private", {
    "get_track.lua",
    "get_player.lua"
})
local obj <const>     = get_code("pd-lua", {
    "initialize.lua",
    "postinitialize.lua",
    "finalize.lua",
    "reload.lua"
})
local methods <const> = get_code("pd-methods", {
    "clear.lua",
    "debug.lua",
    "info.lua",
    "loop.lua",
    "midi.lua",
    "play.lua",
    "record.lua",
    "repeat.lua",
    "thru.lua"
})

local header          = [[
local pd <const> = pd or require "score/src/utils/pd_stub"
local o <const>  = pd.Class:new():register("score") ---@type Score

]]
local script          = header .. utils .. classes .. private .. obj .. methods .. "\n\nreturn o"
local dist            = io.open("score.pd_lua", "w")
dist:write(script)
dist:close()

print("done!")
