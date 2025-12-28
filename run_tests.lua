local lfs <const> = require "lfs"
local lu <const> = require "luaunit"

--[[
    Note: run from top midimus directory!
]]

local FOLDER_WITH_TESTS_NAME = 'tests'

local function is_dir(path)
    -- https://stackoverflow.com/questions/2833675/using-lua-check-if-file-is-a-directory
    -- "This. Use LFS. In Soviet Lua, portability hurts YOU."
    -- lfs.attributes will error on a filename ending in '/'
    return path:sub(-1) == "/" or lfs.attributes(path, "mode") == "directory"
end

local function get_tests()
    local required_string = '^Test'
    for test in lfs.dir(FOLDER_WITH_TESTS_NAME) do
        if test:match(required_string) then
            dofile(FOLDER_WITH_TESTS_NAME .. '/' .. test)
        end
    end
end

local function find_tests(dir)
    dir = dir or '.'
    -- local current_dir = lfs.currentdir()

    for file in lfs.dir(dir) do
        local this_dir  = file == '.'
        local upper_dir = file == '..'
        local ignored   = file:match('^%.%a')
        if not (this_dir or upper_dir or ignored) then
            new_dir = dir .. '/' .. file
            if is_dir(new_dir) then
                if file == FOLDER_WITH_TESTS_NAME then
                    local prev_dir = lfs.currentdir()
                    lfs.chdir(dir)
                    get_tests(dir)
                    lfs.chdir(prev_dir)
                else
                    find_tests(new_dir)
                end
            end
        end
    end
end

find_tests()

os.exit(lu.LuaUnit.run())



-- t = os.execute('ls')
-- print(type(t))
