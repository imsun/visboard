(() ->
	class Menubar extends View
		init: (id) ->
			@id = id

			@domElement = document.createElement 'div'
			@domElement.id = id
			@domElement.className = 'menubar'

		@MenuItem: class extends View
			init: (id, name) ->
				@id = id
				@name = name

				@domElement = document.createElement 'li'
				@domElement.id = id
				@domElement.className = 'menu-item'
				@domElement.innerHTML = name
		

		@Menu = class extends View
			init: (id, name) ->
				@id = id
				@name = name

				title = document.createElement 'span'
				title.id = _.cid()
				title.className = 'menu-title'
				title.innerHTML = name

				list = document.createElement 'ul'
				list.id = _.cid()
				list.className = 'menu-list'


				@domElement = document.createElement 'div'
				@domElement.id = id
				@domElement.className = 'menu'
				@domElement.titleEl = title
				@domElement.appendChild title
				@domElement.listEl = list
				@domElement.appendChild list
				@domElement.addEventListener 'mouseover', (e) ->
					@listEl.className = 'menu-list show'
				@domElement.addEventListener 'mouseout', (e) ->
					@listEl.className = 'menu-list'

			add: (child) ->
				@children[child.id] = child
				@domElement.listEl.appendChild child.domElement
	
	@addMenubar = (editor) ->
		menubar = new Menubar editor
		fileMenu = new Menubar.Menu menubar, 'file', 'File'
		fileMenu.domElement.style.width = '50px'

		new Menubar.MenuItem fileMenu, 'import', 'Import'
		new Menubar.MenuItem fileMenu, 'export', 'Export'

		dataMenu = new Menubar.Menu menubar, 'data', 'Data'
		dataMenu.domElement.style.width = '50px'

		newData = new Menubar.MenuItem dataMenu, 'newData', 'New data'

		primitiveMenu = new Menubar.Menu menubar, 'primitive', 'Primitive'

		coordinate = new Menubar.MenuItem primitiveMenu, 'group', 'Group'
		coordinate.domElement.addEventListener 'click', (e) ->
			new Group()

		axis = new Menubar.MenuItem primitiveMenu, 'axis', 'Axis'
		axis.domElement.addEventListener 'click', (e) ->
			new Axis()
			Renderer.renderAll() if Renderer?

		circle = new Menubar.MenuItem primitiveMenu, 'circle', 'Circle'
		circle.domElement.addEventListener 'click', (e) ->
			new Circle()
			Renderer.renderAll() if Renderer?

		templateMenu = new Menubar.Menu menubar, 'template', 'Template'

		scatterPlot = new Menubar.MenuItem templateMenu, 'scatterplot', 'Scatterplot'
		scatterPlot.domElement.addEventListener 'click', (e) ->
			new Scatterplot()
			Renderer.renderAll() if Renderer?
		return menubar

	@Menubar = Menubar
)()