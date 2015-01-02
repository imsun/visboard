(() ->
	Primitives =
		list: []
		tree:
			data: {}
			insert: (primitive) ->
				dataList = Primitives.tree.data
				_.extend primitive,
					target: primitive
					children: []
				dataList[primitive.id] = primitive

				Primitives.list[primitive.id] =
					type: primitive.type
					prop: primitive.prop

				if primitive.parent? and dataList[primitive.parent]?
					dataList[primitive.parent].children.push primitive.id
				if TreePanel?
					TreePanel.update()
					TreePanel.select primitive.treeNode

			changeParent: (primitive, parent) ->
				dataList = Primitives.tree.data

				children = dataList[primitive.parent].children
				index = children.indexOf primitive.id
				children.splice index, 1

				primitive.parent = parent
				primitive.prop.parent.value = parent
				dataList[parent].children.push primitive.id

				primitive.treeNode.changeParent dataList[parent].target.treeNode.domElement.subTree

				TreePanel.update(dataList)
				TreePanel.select primitive.treeNode


	class Primitive
		@counter: 0
		constructor: (name) ->
			self = @
			@parent = 'root'
			@id = 'UID' + Primitive.counter++
			@type = 'primitive'
			@name = name or 'Primitive'
			@data = null
			@prop =
				# id:
				# 	name: 'ID'
				# 	type: 'label'
				# 	value: self.id
				name:
					name: 'Name'
					type: 'text'
					value: () ->
						return self.name
					listener: (value) ->
						self.name = value
						self.prop.name.value = value
						TreePanel.update Primitives.tree.data
				parent:
					name: 'Parent'
					type: 'select'
					value: @parent
					set: () ->
						result = []
						for key, value of Primitives.tree.data
							if key isnt self.id and value.target.type in ['root', 'scatterplot', 'group']
								result.push
									name: value.name
									value: key
						return result
					listener: (value) ->
						Primitives.tree.changeParent self, value
						Renderer.renderAll()

				data:
					name: 'Data'
					type: 'select'
					value: @data
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
						self.bind value
						Renderer.renderAll()
				visiable:
					name: 'Visiable'
					type: 'boolean'
					value: true
					listener: (value) ->
						self.prop.visiable.value = value
						Renderer.renderAll()

				x:
					name: 'X'
					type: 'number'
					value: 0
					listener: (value) ->
						self.setX value
						Renderer.renderAll()
				y:
					name: 'Y'
					type: 'number'
					value: 0
					listener: (value) ->
						self.setY value
						Renderer.renderAll()
				scale:
					name: 'Scale'
					type: 'number'
					value: 1.0
					listener: (value) ->
						self.setScale value
						Renderer.renderAll()
				rotate:
					name: 'Rotate'
					type: 'number'
					value: 0
					listener: (value) ->
						self.setRotate value
						Renderer.renderAll()

			@init name
			@setCode()

			Primitives.tree.insert @
			if @parent and @parent isnt 'root'
				Primitives.tree.changeParent @, @parent
		init: () ->
		bind: (data) ->
			if data is 'null'
				@data = @prop.data.value = null
			else
				@data = @prop.data.value = data

		setX: (value) ->
			@prop.x.value = value
		setY: (value) ->
			@prop.y.value = value
		setScale: (value) ->
			@prop.scale.value = value
		setRotate: (value) ->
			@prop.rotate.value = value
		setCode: (disableList) ->
			for key, value of @prop
				if not(key in ['id', 'name', 'parent']) and (not disableList? or not(key in disableList)) and value.type isnt 'title' and not value.code?
					propValue = value.value
					if _.isType value.value, 'Function'
						propValue = value.value()
					if (_.isType propValue, 'Object') or (_.isType propValue, 'Array')
						propValue = JSON.stringify propValue
					else if _.isType propValue, 'String'
						propValue = "'#{propValue}'"
					
					value.code = "function($data, $index, $domain, $parent) {\n    return #{propValue}\n}"
					value.enableCode = false

	class Root extends Primitive
		init: () ->
			delete @parent
			delete @data
			delete @prop.parent
			delete @prop.data
			@id = 'root'
			# @prop.id.value = 'root'
			@type = 'root'
			@name = 'Root'

	class Circle extends Primitive
		@counter: 0
		init: (name) ->
			self = @
			@type = 'circle'
			@name = name or 'Circle ' + Circle.counter++
			_.extend @prop,
				radius:
					name: 'Radius'
					type: 'number'
					value: 5
					listener: (value) ->
						self.prop.radius.value = value
						Renderer.renderAll()

	class Group extends Primitive
		@counter: 0
		init: (name) ->
			@type = 'group'
			@name = name or 'Group ' + Group.counter++
			# _.extend @prop,

	class Axis extends Primitive
		@counter: 0
		init: (name) ->
			self = @
			@type = 'axis'
			@name = name or 'Axis ' + Axis.counter++
			_.extend @prop,
				domain:
					name: 'Domain'
					type: 'select'
					value: null
					set: () ->
						result = [
							name: 'none'
							value: null
						]
						for dataName, data of Data.list
							for key of data[0]
								result.push
									name: "#{dataName}.#{key}"
									value: JSON.stringify [dataName, key]
						return result
					listener: (value) ->
						if value is 'null'
							self.prop.domain.value = null
						else
							self.prop.domain.value = value

						Renderer.renderAll()
				length:
					name: 'Length'
					type: 'number'
					value: 100
					listener: (value) ->
						self.prop.length.value = value
						Renderer.renderAll()

				ticks:
					name: 'Ticks'
					type: 'number'
					value: 10
					listener: (value) ->
						self.prop.ticks.value = value
						Renderer.renderAll()
				range:
					name: 'Range'
					type: 'range'
					value: [0, 10]
					listener: (value) ->
						self.prop.range.value = value
						Renderer.renderAll()


	new Root()

	if exports?
		root = exports
	else
		root = @
	_.extend root,
		Primitives: Primitives
		Primitive: Primitive
		Axis: Axis
		Circle: Circle
		Group: Group
)()