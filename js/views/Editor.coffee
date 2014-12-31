(() ->
	root = @
	class Editor extends View
		init: () ->
			@id = 'editor'

			@domElement = document.createElement 'div'
			@domElement.id = 'editor'
			@domElement.className = 'editor'

	@addEditor = () ->
		editor = new Editor()
		menubar = addMenubar editor

		root.Codeeditor = new CodeEditor editor

		sidebar = addSidebar editor
		root.TreePanel = new Sidebar.TreePanel sidebar, _.cid(), Primitives.tree.data
		new Sidebar.PropPanel sidebar, _.cid()

		bottomBar = addBottombar editor
		root.DataPool = new Bottombar.DataPool bottomBar, _.cid()

		addViewport editor

		return editor
	@Editor = Editor
)()