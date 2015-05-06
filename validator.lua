local lexers = {
	html = require 'lexers/html',
	email = require 'lexers/email',
}

local M = {}

M.email = function(str)
	assert(type(str)=='string')
	local result = lexers.email.parse(str)
	return (type(result)~='nil')
end

M.html = function(str)
	assert(type(str)=='string')
	local result = lexers.html.parse(str)
	return (type(result)~='nil')
end

return M