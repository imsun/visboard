(() ->
	Reader = {}
	Reader.parse = (data) ->
		rows = data.replace /\n+/g, '\n'
					.replace /\r+/g, ''
					.trim()
					.split '\n'
					.map (row, index) ->
						row.split ','
		keys = rows.shift()
		result = []
		rows.forEach (row) ->
			_row = {}
			row.forEach (value, index) ->
				_row[keys[index]] = value
			result.push _row
		result

	Reader.read = (file, callback) ->
		req = new XMLHttpRequest
		req.onload = () ->
			callback null, (Reader.parse @responseText)
		req.open 'get', file, true
		req.send()
		
	if exports?
		module.exports = Reader
	else
		@Reader = Reader
)()