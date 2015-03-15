(() ->
	# TO DO
	# 	very dirty
	# 	should be rewrote
	class TreePanel extends View
		selectListener: []
		init: (id, data) ->
			@id = id

			@domElement = document.createElement 'div'
			@domElement.id = id
			@domElement.className = 'tree-panel'

			@tree = new Tree @, _.cid(), data, ['root'], @

		select: (node)->
			return if not node
			@selected.domElement.titleEl.className = 'tree-node-title' if @selected?
			node.domElement.titleEl.className = 'tree-node-title selected'
			@selected = node
			for listener in @selectListener
				listener.fn.call listener.self, node
			DataPool.display _.copy Data.get().tree if DataPool?
			DataPanel.clear() if DataPanel?

		update: (data) ->
			@tree.update data


	class Tree extends View
		init: (id, data, keys, root) ->
			@id = id
			@data = data
			@root = root
			@keys = keys

			@domElement = document.createElement 'ul'
			@domElement.id = id
			@domElement.className = 'tree'

			@_genTree @, keys

		_genTree: (parent, keys) ->
			return if not keys? or not @data?
			for key in keys
				node = new Node parent, _.cid(), @data, @data[key], @root

		update: (data) ->
			@data = data or @data
			@clear()
			@_genTree @, @keys

	class Node extends View
		init: (id, data, el, root) ->
			@id = id
			@data = data
			@target = el.target
			@name = el.name
			@root = root
			self = @
			el.target.treeNode = @

			title = document.createElement 'span'
			title.className = 'tree-node-title'
			title.innerHTML = @name
			title.addEventListener 'click', (e) ->
				self.root.select self

			@domElement = document.createElement 'li'
			@domElement.id = id
			@domElement.className = 'tree-node'
			@domElement.titleEl = title
			@domElement.appendChild title

			@domElement.subTree = new Tree @, _.cid(), @data, null, @root
			if el.children? and el.children.length > 0
				@parent._genTree @domElement.subTree, el.children

		changeParent: (newParent) ->
			# console.log @parent
			@parent.domElement.removeChild @domElement
			@parent = newParent
			newParent.add @

	@Sidebar.TreePanel = TreePanel
)()
