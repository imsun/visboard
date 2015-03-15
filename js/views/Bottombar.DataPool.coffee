(() ->
	class DataPool extends View
		@selected: null
		@select: (node) ->
			# if DataPool.selected
			# 	DataPool.selected.setAttribute 'class', 'node'
			DataPool.selected = node
			# node.setAttribute 'class', 'node selected'
		init: (@id) ->
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'data-pool'

		display: (dataTrees) ->
			@clear()

			dataTrees = _.copy dataTrees

			style = getComputedStyle @domElement
			width = parseFloat (style.getPropertyValue 'width')
			fullHeight = parseFloat (style.getPropertyValue 'height')
			height = fullHeight / dataTrees.length

			Tree = d3.layout.tree()
					.size [height, width - 200]
					.separation (a, b) ->
						if a.parent is b.parent
							return 1 / (a.depth + 1)
						else
							return 2 / (a.depth + 1)

			diagonal = d3.svg.diagonal()
						.projection (d) ->
							return [d.y, d.x]

			svg = d3.select @domElement
					.append 'svg'
					.attr 'width', width
					.attr 'height', fullHeight

			for dataTree, i in dataTrees
				nodes = Tree.nodes dataTree
				links = Tree.links nodes
				group = svg.append 'g'
						.attr 'transform', "translate(40, #{i * height})"

				link = group.selectAll '.link'
						.data links
						.enter()
						.append 'path'
						.attr 'class', 'link'
						.attr 'd', diagonal
				node = group.selectAll '.node'
						.data nodes
						.enter()
						.append 'g'
						.attr 'class', (d, i) ->
							return 'node ' + d.type
						.attr 'transform', (d) ->
							return "translate(#{d.y}, #{d.x})"
						.on 'click', (d, i) ->
							DataPool.select @
							DataPanel.display (Data.get().getNode d.name, Data.get().tree) if DataPanel?

				node.append 'circle'
					.attr 'r', 4.5

				node.append 'text'
					.attr 'dx', (d, i) ->
						if d.children and i
							return -8
						else
							return 8
					.attr 'dy', 3
					.style 'text-anchor', (d, i) ->
						if d.children and i
							return 'end'
						else
							return 'start'
					.text (d) ->
						return d.name


	@Bottombar.DataPool = DataPool
)()
