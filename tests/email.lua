local validator = require 'validator'

local valid = validator.email('test+folder@test.com')
assert(valid)