LPEG Grammars
======

A set of LPEG grammars for parsing various types of document: HTML, e-mail (RFC 822).

Dependencies
============

* Lua 5.1.x or LuaJIT 2.0.x+
* LPEG library

Usage
=====

## Parse an HTML document

```lua
local htmlParser = require 'lexers/html'

local content = htmlParser.parse([[
<!DOCTYPE html>
<html>
	<head>
		<title>A sample code</title>
		<meta charset="UTF-8"/>
	</head>
	<body>
		<h1>Hello world!</h1><br />
	</body>
</html>
]])
```

## Validate an HTML document

```lua
local validator = require 'validator'

local valid = validator.html([[
<!DOCTYPE html>
<html>
	<head>
		<title>A sample code</title>
		<meta charset="UTF-8"/>
	</head>
	<body>
		<h1>Hello world!</h1><br />
	</body>
</html>
]])
```

## Validate an e-mail address

```lua
local validator = require 'validator'

local valid = validator.email('test+folder@test.com')
```

Authors
=======
* Mário Kašuba <soulik42@gmail.com>

Links for further info
======================
For more information regarding LPEG, please visit:

-	http://www.inf.puc-rio.br/~roberto/lpeg/ - LPeg - Parsing Expression Grammars For Lua by Roberto Ierusalimschy

Copying
=======
Copyright 2015 Mário Kašuba
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
