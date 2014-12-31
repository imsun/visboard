(() ->
	class Bottombar extends View
		init: (@id, @title) ->		
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'bottombar'

			if @title
				titleEl = document.createElement 'h2'
				titleEl.className = 'bottombar-title'
				titleEl.innerText = @title
				@domElement.titleEl = titleEl
				@domElement.appendChild titleEl

	@addBottombar = (editor) ->
		return new Bottombar editor, _.cid(), 'Data Pool'

	@Bottombar = Bottombar
)()