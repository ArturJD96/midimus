local lu <const> = require 'luaunit'
local Protocol <const> = require 'utilities/Protocol'

TestRegistrable = {}
function TestRegistrable:setup()
    -- make dummy class
    self.Class = { __type = 'Class' }
    self.Class.__index = self.Class
    self.Class.new = function(id)
        return setmetatable({ id = id }, self.Class)
    end

    -- apply protocol
    Protocol.apply(self.Class, { "registrable" })

    -- register random number of objects
    self.objects_count = math.random(3, 10)
    for i = 1, self.objects_count, 1 do
        self.Class.new('obj_' .. tostring(i))
    end
end

function TestRegistrable:teardown()
    self.Class.reset_register()
end

function TestRegistrable:test_type_not_present()
    local Test = {}
    Test.__index = Test
    Test.new = function(self)
        return setmetatable({}, Test)
    end
    lu.assertErrorMsgContains('', Protocol.apply, Test, { 'registrable' })
end

function TestRegistrable:test_register_count()
    lu.assertEquals(self.Class.register_count(), self.objects_count)
end

function TestRegistrable:test_remove()
    self.Class.remove('obj_1')
    lu.assertEquals(self.Class.register_count(), self.objects_count - 1)
    lu.assertNil(self.Class._register['obj_1'])
end

function TestRegistrable:test_reset_register()
    self.Class.reset_register()
    lu.assertEquals(self.Class.register_count(), 0)
end

function TestRegistrable:test_default_id()
    self.Class.reset_register()
    local obj = self.Class.new()
    lu.assertEquals(obj.id, self.Class._default_id .. '_1')
end

function TestRegistrable:test_new()
    self.Class.new()
    self.Class.new()
    self.Class.new()
    lu.assertNotNil(self.Class._register['Class_1'])
    lu.assertNotNil(self.Class._register['Class_2'])
    lu.assertNotNil(self.Class._register['Class_3'])
    self.Class.new('Class_4')
    self.Class.new()
    lu.assertNotNil(self.Class._register['Class_5'])
end

function TestRegistrable:test_remove_and_add_new()
    self.Class.new() -- replace 'register' with native 'new' constructor.
    self.Class.new()
    self.Class.new()
    local expected_name = self.Class._default_id .. '_2'
    lu.assertNotNil(self.Class._register[expected_name])
    self.Class.remove(expected_name)
    lu.assertNil(self.Class._register[expected_name])
    self.Class.new('Testtt') --should not affect numeration.
    lu.assertNil(self.Class._register[expected_name])
    self.Class.new()
    lu.assertNotNil(self.Class._register[expected_name])
end

os.exit(lu.LuaUnit.run())
