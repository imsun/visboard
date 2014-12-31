(() ->
	class DataPool extends View
		init: (@id) ->
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'data-pool'
	
	@Bottombar.DataPool = DataPool
)()