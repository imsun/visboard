(() ->
	Reader = {}

	Reader.upload = () ->
		el = document.createElement 'input'
		el.type = 'file'
		el.style.display = 'none'
		el.addEventListener 'change', (e) ->
			reader = new FileReader
			name = @files[0].name
			reader.onload = (e) ->
				file = e.target.result
				temp = new (Data.get())(name, (Reader.parse file))
				console.log temp
				TreePanel.select TreePanel.selected if TreePanel?

				el.parentElement.removeChild el
				el = null
			reader.readAsText @files[0], 'utf-8'

		document.body.appendChild el
		el.click()

	Reader.parse = (data) ->
		rows = data.replace /\n+/g, '\n'
					.replace /\r+/g, ''
					.trim()
					.split '\n'
					.map (row, index) ->
						result = []
						temp = ''
						qFlag = false
						for i in [0..row.length - 1]
							if row[i] is ',' and not qFlag
								result.push temp
								temp = ''
							else if row[i] is '"'
								qFlag = not qFlag
							else
								temp += row[i]
						# row.split ','
						result.push temp
						return result
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
