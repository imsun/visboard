(() ->
	class Data
		@list: {}
		constructor: (key, @data) ->
			Data.list[key] = @data
			@init()
		init: () ->
	
	if exports?
		module.exports = Data
	else
		@Data = Data
)()