(() ->
	Reader = {}

	uploader = document.createElement 'input'
	uploader.type = 'file'
	uploader.style.display = 'none'
	uploader.addEventListener 'change', (e) ->
		reader = new FileReader
		name = @files[0].name
		reader.onload = (e) ->
			file = e.target.result
			new Data name, (Reader.parse file)
			TreePanel.select TreePanel.selected if TreePanel?
		reader.readAsText @files[0], 'utf-8'
	document.body.appendChild uploader
	Reader._uploader = uploader

	Reader.upload = () ->
		Reader._uploader.click()

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