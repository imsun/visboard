csv = require '../js/workflow/Reader'
fs = require 'fs'

fs.readFile 'data/game.csv',
		encoding: 'utf8'
	, (err, data) ->
		throw err if err

		data = csv.parse data
		keys = Object.keys data[0]
		count = {}
		count[key] = {} for key in keys

		data.forEach (row) ->
			for key in keys
				if not (row[key] of count[key])
					count[key][row[key]] = 0
				else
					count[key][row[key]]++

		# console.log JSON.stringify count.action
		console.log data

		fs.writeFile 'data/data.js', "data=#{(JSON.stringify data)};\n"
