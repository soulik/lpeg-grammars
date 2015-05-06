require 'lpeg'

local P = lpeg.P
local C = lpeg.C
local Ct = lpeg.Ct
local V = lpeg.V
local S = lpeg.S
local R = lpeg.R
local locale = lpeg.locale()

-- RFC 822
local M = {}

local grammar = P {
	'address',
	address 		= V'mailbox'														-- one addressee
            		+ V'group',															-- named list
	group   		= V'phrase' * P':' * (V'mailboxes')^(-1) * P';',
	phrase			= V'word' * (P',' * V'word')^0,
	mailboxes		= V'mailbox' * (P',' * V'mailbox')^0, 
	mailbox 		= V'addrSpec'														-- simple address
            		+ V'phrase' * V'routeAddr',											-- name & addr-spec
	routeAddr		= P'<' * (V'route')^(-1) * V('addrSpec') * P'>',
	route			= (P'@' * V'domain') * (P',' * (P'@' * V'domain')^(-1))^0 * P':',	-- path-relative
	addrSpec		= V'localPart' * P'@' * V'domain',									-- global address
	localPart		= V'word' * (P'.' * V'word')^0,										-- uninterpreted
																						-- case-preserved
	domain    	  	= V'subDomain' * ('.' * V'subDomain')^0,
	subDomain		= V'domainRef' + V'domainLiteral',
	domainRef		= V'atom',															-- symbolic reference

	domainLiteral 	= P'[' * ((1 - S'[]') + V'quotedPair')^0 * P']',
	word			= V'atom' + V'quotedString',
	atom			= (1 -(V'specials'+ locale.space + locale.cntrl))^1,
	quotedString	= P'"' * (V'qText' + V'quotedPair')^0 * P'"',
	qText			= 1 - S" \"\\\n", 
	specials		= S'()<>@,;:\\".[]',
	quotedPair		= P'\\' * P(1),
}

M.parse = function(html)
	return grammar:match(html)
end

return M