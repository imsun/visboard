(() ->
	Workflow = () ->
		wf = @
		@DataModel = DataModel = class
			@list: {}
			@tree: []
			@getNode: (name, trees) ->
				for tree in trees
					if tree.name is name
						return tree
				for tree in trees
					result = @getNode name, tree.children
					return result if result
			constructor: (name, @data, parent) ->
				DataModel.list[name] = @data
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
								data = DataModel.list[name]
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
					node = DataModel.getNode parent, DataModel.tree
					node.children.push dataNode
				else
					DataModel.tree.push dataNode

				# d3.tree() will remove `children` from tree's nodes
				DataPool.display _.copy DataModel.tree if DataPool?
				DataPanel.display dataNode if DataPanel?
				return @


		@Tool = Tool = class
			constructor: () ->
				self = @
				name = 'Tool ' + Tool.counter++
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
								for key, value of DataModel.list
									result.push
										name: key
										value: key
								return result
							listener: (value) ->
								self.setInput value

				@dataNode = dataNode
				@init()
				DataModel.tree.push dataNode

				DataPool.display DataModel.tree if DataPool?
				DataPanel.display dataNode if DataPanel?

			@counter: 0
			update: () ->
				for child in @dataNode.children
					delete Data.list[child.name]
				@dataNode.children = []
			setInput: (value) ->
				value = null if value is 'null'
				if @dataNode.parent?
					oldParent = DataModel.getNode @dataNode.parent, Data.tree
									.children
				else
					oldParent = DataModel.tree
				index = oldParent.indexOf @dataNode
				oldParent.splice index, 1
				@dataNode.parent = value
				@dataNode.prop.input.value = value

				if value?
					parent = DataModel.getNode value, DataModel.tree
								.children
				else
					parent = DataModel.tree
				parent.push @dataNode
				console.log @
				@update()
			init: () ->
				console.log 'init'

		# Filter and Cluster need to be reduced
		@Filter = Filter = class extends @Tool
			@counter: 0
			init: () ->
				self = @
				@dataNode.name = @dataNode.prop.name.value = @name = 'filter ' + Filter.counter++
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
					DataPool.display DataModel.tree
					return
				input = DataModel.list[inputName]

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
				i++ while DataModel.list[inputName + '.' + i]
				new DataModel inputName + '.' + i, output, @dataNode.name

		@Cluster = Cluster = class extends @Tool
			@counter: 0
			init: () ->
				self = @
				@dataNode.name = @dataNode.prop.name.value = @name = 'cluster ' + Cluster.counter++
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
					DataPool.display DataModel.tree
					return
				input = DataModel.list[inputName]

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
				new DataModel inputName + '.' + key, keys, @dataNode.name

				for index, item of group
					new DataModel inputName + '.' + key + '.' + index, item, @dataNode.name

		@Scale = Scale = class extends Tool
			@counter: 0
			@list: []
			init: () ->
				self = @
				@dataNode.name = @dataNode.prop.name.value = @name = 'scale' + Scale.counter++
				@dataNode.prop.title.name = 'Scale'
				@dataNode.type = 'scale'
				@dataNode.prop.input.listener

				Scale.list.push @dataNode
				_.extend @dataNode.prop,
					domain:
						name: 'Domain'
						type: 'select'
						value: null
						set: () ->
							result = [
								name: 'none'
								value: null
							]
						listener: (value) ->
							self.dataNode.prop.domain.value = value
					from:
						name: 'From'
						type: 'range'
						value: ['$Min($domain)', '$Max($domain)']
						listener: (value) ->
							self.dataNode.prop.from.value = value
					to:
						name: 'To'
						type: 'range'
						value: [0, 100]
						listener: (value) ->
							self.dataNode.prop.to.value = value
			update: () ->
				super()
				DataPool.display _.copy DataModel.tree if DataPool?
			setInput: (value) ->
				value = null if value is 'null'
				super value
				@dataNode.prop.domain.set = () ->
					result = [
						name: 'none'
						value: null
					]
					if value?
						Object.keys DataModel.list[value][0]
							.forEach (key) ->
								result.push
									name: key
									value: key
					return result
				DataPanel.display @dataNode if DataPanel?
		console.log @
		return @

	Data =
		list: {}
		add: (id) ->
			Data.list[id] = new Workflow()
		get: (id) ->
			return Data.list[id].DataModel if id?
			return Data.list[TreePanel.selected.target.id].DataModel if TreePanel?
			return null
		tools: (id) ->
			return Data.list[id] if id?
			return Data.list[TreePanel.selected.target.id] if TreePanel?
			return null
		remove: (id) ->
			delete Data.list[id]

	if exports?
		module.exports = Data
	else
		@Data = Data
)()
