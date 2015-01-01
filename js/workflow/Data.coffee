(() ->	
	class Data
		@list: {}
		@tree: []
		@getNode = (name, trees) ->
			for tree in trees
				if tree.name is name
					return tree
			for tree in trees
				result = Data.getNode name, tree.children
				return result if result
		constructor: (name, @data, parent) ->
			Data.list[name] = @data
			dataNode =
				name: name
				type: 'data'
				parent: parent
				children: []
				prop:
					title:
						name: 'Data'
						type: 'title'
					name:
						name: 'Name'
						type: 'label'
						value: name
					rows:
						name: 'Rows'
						type: 'label'
						value: @data.length
					preview:
						name: 'Preview'
						type: 'html'
						value: (() ->
							data = Data.list[name]
							keys = Object.keys data[0]
							tr = ''
							th = '<thead><tr><th>' + (keys.join '</th><th>') + '</th></tr></thead>'
							data.forEach (row, i) ->
								td = ''
								keys.forEach (key, j) ->
									td += "<td>#{row[key]}</td>"
								tr += "<tr>#{td}</tr>"
							table = "<table>#{th}<tbody>#{tr}</tbody></table>"
							return table
						)()
			if parent?
				node = Data.getNode parent, Data.tree
				node.children.push dataNode
			else
				Data.tree.push dataNode

			# d3.tree() will remove `children` from tree's nodes
			DataPool.display _.copy Data.tree if DataPool?
			DataPanel.display dataNode if DataPanel?

	# Filter and Cluster need to be reduced
	Data.Filter = class
		@counter: 0
		constructor: () ->
			self = @
			name = 'filter ' + Data.Filter.counter++
			dataNode =
				id: _.cid()
				name: name
				type: 'filter'
				parent: null
				children: []
				prop:
					title:
						name: 'Filter'
						type: 'title'
					name:
						name: 'Name'
						type: 'label'
						value: name
					input:
						name: 'Input'
						type: 'select'
						value: null
						set: () ->
							result = [
								name: 'none'
								value: null
							]
							for key, value of Data.list
								result.push
									name: key
									value: key
							return result
						listener: (value) ->
							value = null if value is 'null'
							if dataNode.parent?
								oldParent = Data.getNode dataNode.parent, Data.tree
												.children
							else
								oldParent = Data.tree
							index = oldParent.indexOf dataNode
							oldParent.splice index, 1
							dataNode.parent = value
							dataNode.prop.input.value = value

							if value?
								parent = Data.getNode value, Data.tree
											.children
							else
								parent = Data.tree
							parent.push dataNode

							dataNode.update()
					select:
						name: 'Select'
						type: 'text'
						value: null
						listener: (value) ->
							value = null if value is 'null'
							dataNode.prop.select.value = value
							dataNode.update()
					rules:
						name: 'Rules'
						type: 'text'
						value: null
						listener: (value) ->
							dataNode.prop.rules.value = value
							dataNode.update()
				update: () ->
					for child in dataNode.children
						delete Data.list[child.name]
					dataNode.children = []

					inputName = dataNode.prop.input.value
					select = dataNode.prop.select.value
					rules = dataNode.prop.rules.value

					if not select or not inputName
						DataPool.display Data.tree
						return
					input = Data.list[inputName]

					if select isnt '*'
						select = select.split ','
									.map (row) ->
										return row.trim()

					output = []
					input.forEach (row, index) ->
						if rules
							fn = eval "(function ($data, $index) { return #{rules}})"
							if not fn row, index
								return

						if select is '*'
							output.push (_.copy row)
						else
							result = {}
							select.forEach (key) ->
								result[key] = _.copy row[key]
							output.push result
					i = 0
					i++ while Data.list[inputName + '.' + i]
					new Data inputName + '.' + i, output, dataNode.name

			Data.tree.push dataNode

			DataPool.display Data.tree if DataPool?
			DataPanel.display dataNode if DataPanel?

	Data.Cluster = class
		@counter: 0
		constructor: () ->
			self = @
			name = 'cluster ' + Data.Cluster.counter++
			dataNode =
				id: _.cid()
				name: name
				type: 'cluster'
				parent: null
				children: []
				prop:
					title:
						name: 'Cluster'
						type: 'title'
					name:
						name: 'Name'
						type: 'label'
						value: name
					input:
						name: 'Input'
						type: 'select'
						value: null
						set: () ->
							result = [
								name: 'none'
								value: null
							]
							for key, value of Data.list
								result.push
									name: key
									value: key
							return result
						listener: (value) ->
							value = null if value is 'null'
							if dataNode.parent?
								oldParent = Data.getNode dataNode.parent, Data.tree
												.children
							else
								oldParent = Data.tree
							index = oldParent.indexOf dataNode
							oldParent.splice index, 1
							dataNode.parent = value
							dataNode.prop.input.value = value

							if value?
								parent = Data.getNode value, Data.tree
											.children
							else
								parent = Data.tree
							parent.push dataNode

							dataNode.update()
					key:
						name: 'Key'
						type: 'text'
						value: null
						listener: (value) ->
							value = null if value is 'null'
							dataNode.prop.key.value = value
							dataNode.update()
				update: () ->
					for child in dataNode.children
						delete Data.list[child.name]
					dataNode.children = []

					inputName = dataNode.prop.input.value
					key = dataNode.prop.key.value

					if not key or not inputName
						DataPool.display Data.tree
						return
					input = Data.list[inputName]

					group = {}
					input.forEach (row, index) ->
						if not group[row[key]]
							group[row[key]] = []
						group[row[key]].push (_.copy row)
					keys = Object.keys group
							.map (row) ->
								temp = {}
								temp[key] = row
								return temp

					# TO DO
					# 	may exist name conflict
					new Data inputName + '.' + key, keys, dataNode.name

					for index, item of group
						new Data inputName + '.' + key + '.' + index, item, dataNode.name

			Data.tree.push dataNode

			DataPool.display Data.tree if DataPool?
			DataPanel.display dataNode if DataPanel?

	if exports?
		module.exports = Data
	else
		@Data = Data
)()