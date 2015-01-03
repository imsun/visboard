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

	Data.Tool = class
		@counter: 0
		constructor: () ->
			self = @
			name = 'Tool ' + Data.Tool.counter++
			@name = name
			dataNode =
				id: _.cid()
				name: name
				type: 'tool'
				parent: null
				children: []
				prop:
					title:
						name: 'Tool'
						type: 'title'
					name:
						name: 'Name'
						type: 'text'
						value: name
						listener: (value) ->
							self.dataNode.name = value
							self.dataNode.prop.name.value = value
							self.update()
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
							console.log self
							self.update()

			@dataNode = dataNode
			@init()
			Data.tree.push dataNode

			DataPool.display Data.tree if DataPool?
			DataPanel.display dataNode if DataPanel?
		update: () ->
			for child in @dataNode.children
				delete Data.list[child.name]
			@dataNode.children = []

		init: () ->



	# Filter and Cluster need to be reduced
	Data.Filter = class extends Data.Tool
		@counter: 0
		init: () ->
			self = @
			@dataNode.name = @dataNode.prop.name.value = @name = 'filter ' + Data.Filter.counter++
			@dataNode.prop.title.name = 'Filter'
			@dataNode.type = 'filter'

			_.extend @dataNode.prop,
				select:
					name: 'Select'
					type: 'text'
					value: null
					listener: (value) ->
						value = null if value is 'null'
						self.dataNode.prop.select.value = value
						self.update()
				rules:
					name: 'Rules'
					type: 'text'
					value: null
					listener: (value) ->
						self.dataNode.prop.rules.value = value
						self.update()

		update: () ->
			super()

			inputName = @dataNode.prop.input.value
			select = @dataNode.prop.select.value
			rules = @dataNode.prop.rules.value

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
			new Data inputName + '.' + i, output, @dataNode.name


	Data.Cluster = class extends Data.Tool
		@counter: 0
		init: () ->
			self = @
			@dataNode.name = @dataNode.prop.name.value = @name = 'cluster ' + Data.Filter.counter++
			@dataNode.prop.title.name = 'Cluster'
			@dataNode.type = 'cluster'

			_.extend @dataNode.prop,
				key:
					name: 'Key'
					type: 'text'
					value: null
					listener: (value) ->
						value = null if value is 'null'
						self.dataNode.prop.key.value = value
						self.update()

		update: () ->
			super()

			inputName = @dataNode.prop.input.value
			key = @dataNode.prop.key.value

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
			new Data inputName + '.' + key, keys, @dataNode.name

			for index, item of group
				new Data inputName + '.' + key + '.' + index, item, @dataNode.name

	Data.Scale = class extends Data.Tool
		@counter: 0
		@list: []
		init: () ->
			self = @
			@dataNode.name = @dataNode.prop.name.value = @name = 'scale' + Data.Scale.counter++
			@dataNode.prop.title.name = 'Scale'
			@dataNode.type = 'scale'

			Data.Scale.list.push @dataNode
			_.extend @dataNode.prop,
				domain:
					name: 'Domain'
					type: 'range'
					value: [null, null]
					listener: (value) ->
						self.dataNode.prop.domain.value = value

				range:
					name: 'Range'
					type: 'range'
					value: [null, null]
					listener: (value) ->
						self.dataNode.prop.range.value = value
		update: () ->
			super()
			DataPool.display _.copy Data.tree if DataPool?

	if exports?
		module.exports = Data
	else
		@Data = Data
)()