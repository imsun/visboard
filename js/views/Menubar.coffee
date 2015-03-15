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

		logo = new Menubar.Menu menubar, 'logo', '<span>Vis</span>board'

		fileMenu = new Menubar.Menu menubar, 'file', 'File'
		fileMenu.domElement.style.width = '50px'

		new Menubar.MenuItem fileMenu, 'import', 'Import'
		new Menubar.MenuItem fileMenu, 'export', 'Export'

		dataMenu = new Menubar.Menu menubar, 'data', 'Workflow'
		dataMenu.domElement.style.width = '70px'

		newData = new Menubar.MenuItem dataMenu, 'newData', 'New data'
		newData.domElement.addEventListener 'click', (e) ->
			Reader.upload()
		newFilter = new Menubar.MenuItem dataMenu, 'newFilter', 'Filter'
		newFilter.domElement.addEventListener 'click', (e) ->
			new (Data.tools().Filter)()
		newCluster = new Menubar.MenuItem dataMenu, 'newCluster', 'Cluster'
		newCluster.domElement.addEventListener 'click', (e) ->
			new (Data.tools().Cluster)()
		newScale = new Menubar.MenuItem dataMenu, 'newScale', 'Scale'
		newScale.domElement.addEventListener 'click', (e) ->
			new (Data.tools().Scale)()

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
