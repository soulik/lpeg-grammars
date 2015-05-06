local lpeg = require 'lpeg'
local locale = lpeg.locale()

local M = {}
local P = lpeg.P
local S = lpeg.S
local R = lpeg.R
local C = lpeg.C
local Cg = lpeg.Cg
local Cc = lpeg.Cc
local Cb = lpeg.Cb
local Ct = lpeg.Ct
local Cf = lpeg.Cf
local Cmt = lpeg.Cmt
local V = lpeg.V
local space = locale.space
local word = locale.alnum

local lt, gt = P'<', P'>'
local lte, gte = P'</', P'/>'
local ltdt = P'<!'
local squot = P"'"
local dquot = P'"'
local cb, ce = P'<!--', P'-->'
local equal = P'='
local nameChar = word + S':_'
local name = nameChar^1
local cdataS=P'<![CDATA['
local cdataE=P']]>'
local text = (1 - lt)^1
local doctype = P'doctype' + P'DOCTYPE'

local stackMT = {
	__unm = function(t)
		return table.remove(t)
	end,
	__add = function(t, v)
		table.insert(t, v)
		return t
	end,
}

local stack = function()
	local stack = {}
	setmetatable(stack, stackMT)
	return stack
end

local D = function(name)
	return function(...)
		print(name,':')
		local t = {}
		local values = {...}
		for i,v in ipairs(values) do
			table.insert(t, ('%q'):format(tostring(v)))
		end
		print(unpack(t))
		return ...
	end
end

local function elementType(name)
	return Cg(Cc(name), 'type')
end

M.parse = function(html)
	local tagStack = stack()
	
	local openTag = function(a)
		return -tagStack
	end

	local closeTag = function(a)
		tagStack = tagStack + a
		return a
	end

    local grammar = P {
    	'htmlDocument',
    	htmlDocument = space^0 * Ct(V'doctype' * V'elements'),
    	doctype = Cg(Ct(ltdt * doctype * (V'tagAttributesList')^(-1) * space^0 * gt), 'doctype'),

    	elements =
    		space^0 *
    		Cg(
    			Ct(
    				(Ct(V'tag' + V'comment' + V'textContent' + V'CDATA'))^0
    			),
    			'elements'
    		)
    		* space^0,

    	tag = space^0 * (V'pairTag' + V'singleTag') * elementType('tag') * space^0,
    	tagName = name,

    	singleTag = lt * Cg(V'tagName', 'elementName') * (V'tagAttributesList')^(-1) * space^0 * (gte + gt),
    	
    	pairTagBegin = lt * Cg(Cg(C(V'tagName') / openTag, 'element'), 'elementName') * (V'tagAttributesList')^(-1) * gt ,
    	pairTagEnd = lte * Cmt((C(V'tagName') / closeTag) * Cb'elementName',
    		function(s, i, a, b)
    			return a==b
    		end) * gt,
    	pairTag =  V'pairTagBegin' * V'elements' * V'pairTagEnd',

    	tagAttributeName = C(name),
    	tagAttributeValue = (squot * C((1-squot)^0) * squot) + (dquot * C((1-dquot)^0) * dquot),

    	tagAttributeFlag = Cg(V'tagAttributeName' * Cc(true)),
    	tagAttributeValued = Cg(V'tagAttributeName' * equal * V'tagAttributeValue'),
    	tagAttribute = (V'tagAttributeValued' + V'tagAttributeFlag'),

    	tagAttributes = V'tagAttribute' * (space^1 * V'tagAttribute')^0,
    	tagAttributesList = space^1 * Cg(Cf(Ct'' * V'tagAttributes', function(t, k, v)
    		t[k] = v
    		return t,k,v
    	end), 'attributes') * space^0,

    	textContent = space^0 * Cg(C(text), 'text') * elementType('text') * space^0,

    	commentContent = C((1- ce)^0),
    	comment = space^0 * cb * Cg(V'commentContent', 'text') * elementType('comment') * ce * space^0,

    	CDATAcontent = C((1- cdataE)^0),
    	CDATA = space^0 * (cdataS * space^0 * Cg(V'CDATAcontent', 'text') * space^0 * cdataE) * elementType('CDATA') * space^0,
    }

	return grammar:match(html)
end

return M