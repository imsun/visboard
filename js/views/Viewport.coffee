(() ->
	class Viewport extends View
		init: (@id) ->
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'viewport'

	@addViewport = (editor) ->
		viewport = new Viewport editor, 'viewport'
		width =  window.innerWidth - 250
		height = window.innerHeight * 0.7 - 30
		viewport.domElement.width = width
		viewport.domElement.height = height
		viewport.domElement.style.width = width + 'px'
		viewport.domElement.style.height = height + 'px'
	@Viewport = Viewport
)()