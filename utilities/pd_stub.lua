local pd_class_stub = {
    new = function()
        return {
            register = function()
                return {
                    dofilex = function(self, path) return loadfile(path)() end,
                    outlet = function(self, outlet_id, data_type, ...) print('outlet ' .. outlet_id .. '\n', ...) end,
                    error = function(self, message) error(message) end
                }
            end
        }
    end
}

local pd_receive_stub = {
    new = function()
        return {
            register = function(self, obj, sym, method)
                assert(type(sym) == 'string', "Receive name must be string.")
                print('Created receiver for ' .. sym .. ' with method ' .. method)
                return { destruct = function(self) end }
            end,
        }
    end
}

local pd_clock_stub = {
    new = function()
        return {
            register = function(self, obj, method)
                return {
                    callback = obj[method],
                    destruct = function(self) end,
                    delay = function(self, ms)
                        os.execute('sleep ' .. tonumber(ms / 1000))
                        obj[method]()
                    end,
                    unset = function(self) end
                }
            end,
        }
    end
}

local TIMEUNITPERMSEC = 32 * 441 -- from pdlua.c
local function clock2systime()
    return os.clock() * 1000 * TIMEUNITPERMSEC
end

local pd_stub = {

    --[[	faking pd_lua behaviour in pure lua
	     	(so when 'pd' global table is absent)	]] --

    stub = true,
    Class = pd_class_stub,
    post = function(...) print(...) end,
    send = function(sym, sel, ...)
        assert(type(...) == 'table')
        --print('send '..(sym or '')..'\n'..(sel or ''), ...)
    end,
    Receive = pd_receive_stub,
    Clock = pd_clock_stub,
    TIMEUNITPERMSEC = TIMEUNITPERMSEC,
    systime = clock2systime, -- NOTE: this does not behave as pd's, which uses pd.TIMEUNITPERMSEC.
    timesince = function(systime) return math.abs(clock2systime() - systime) end

}

return pd_stub
