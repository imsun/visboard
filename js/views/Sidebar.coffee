(() ->
	class Sidebar extends View
		init: (@id, @title) ->
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'sidebar'

			if @title
				titleEl = document.createElement 'h2'
				titleEl.className = 'sidebar-title'
				titleEl.innerText = @title
				@domElement.titleEl = titleEl
				@domElement.appendChild titleEl

	@addSidebar = (editor) ->
		return new Sidebar(editor, _.cid(), 'Primitives')

	@Sidebar = Sidebar
)()