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

assert(type(content) ~= 'nil')

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

assert(valid)