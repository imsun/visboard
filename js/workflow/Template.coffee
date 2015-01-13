(() ->
	class Scatterplot extends Primitive
		@counter: 0
		constructor: (name) ->
			super()
			self = @
			@xAxis = new Axis 'x axis'
			@yAxis = new Axis 'y axis'
			@point = new Circle 'point'

			@yAxis.prop.rotate.value = 90
			@yAxis.prop.y.value = 100
			@yAxis.prop.range.value = [10, 0]

			_.extend @prop,
				pointData:
					name: 'Point'
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
						self.prop.pointData.value = value
						self.point.bind value
						Renderer.renderAll()
						# self.updateChildren()
					# codeListener: (value, flag) ->
					# 	self.point.prop.data.enableCode = flag
					# 	self.point.prop.data.code = value

				xAxis:
					name: 'X axis'
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
						self.setXAxis value
						Renderer.renderAll()
				yAxis:
					name: 'Y axis'
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
						self.setYAxis value
						Renderer.renderAll()
				width:
					name: 'Width'
					type: 'number'
					value: 300
					listener: (value) ->
						self.setWidth value
						Renderer.renderAll()
				height:
					name: 'Height'
					type: 'number'
					value: 150
					listener: (value) ->
						self.setHeight value
						Renderer.renderAll()
			@setCode(['pointData', 'xAxis', 'yAxis'])

			@updateChildren()
			Primitives.tree.changeParent @xAxis, @id
			Primitives.tree.changeParent @yAxis, @id
			Primitives.tree.changeParent @point, @id

			TreePanel.select @treeNode

		init: (name) ->
			@type = 'scatterplot'
			@name = name or 'Scatterplot ' + Scatterplot.counter++

		setWidth: (value) ->
			@prop.width.value = value
			@xAxis.prop.length.value = value
			@setXAxis @prop.xAxis.value
		setHeight: (value) ->
			@prop.height.value = value
			@yAxis.prop.length.value = value
			@yAxis.prop.y.value = value
			@setYAxis @prop.yAxis.value
		setXAxis: (value) ->
			value = null if value is 'null'
			@prop.xAxis.value = value
			# @xAxis.prop.domain.value = value

			if value
				xDomain = value
				if _.isType xDomain, 'String'
					xDomain = JSON.parse xDomain

				xColumn = Data.list[xDomain[0]].map (row) ->
					try
						return parseFloat(row[xDomain[1]])
					catch e
						return 0

				xMax = Math.max.apply @, xColumn
				xMin = Math.min.apply @, xColumn
				if xMin >= 0
					@xAxis.prop.range.value = [0, xMax]
					@point.prop.x.value = "$data['#{xDomain[1]}'] / #{xMax} * #{@prop.width.value}" if @prop.pointData.value
					@yAxis.prop.x.value = 0
				else
					@xAxis.prop.range.value = [xMin, xMax]
					step = @prop.width.value / (xMax - xMin)
					@point.prop.x.value = "$data['#{xDomain[1]}'] * #{step} + #{-xMin * step}" if @prop.pointData.value
					@yAxis.prop.x.value = "#{-xMin * step}"
			else
				@xAxis.prop.range.value = [0, 10]
				@point.prop.x.value = 0
				@yAxis.prop.x.value = 0
		setYAxis: (value) ->
			value = null if value is 'null'
			@prop.yAxis.value = value
			# @yAxis.prop.domain.value = value

			if value
				yDomain = value
				if _.isType yDomain, 'String'
					yDomain = JSON.parse yDomain

				yColumn = Data.list[yDomain[0]].map (row) ->
					try
						return parseFloat(row[yDomain[1]])
					catch e
						return 0

				yMax = Math.max.apply @, yColumn
				yMin = Math.min.apply @, yColumn
				if yMin >= 0
					@yAxis.prop.range.value = [yMax, 0]
					@point.prop.y.value = "$data['#{yDomain[1]}'] / #{yMax} * #{@prop.height.value}" if @prop.pointData.value
					@xAxis.prop.y.value = 0
				else
					@yAxis.prop.range.value = [yMax, yMin]
					step = @prop.height.value / (yMax - yMin)
					@point.prop.y.value = "$data['#{yDomain[1]}'] * #{step} + #{-yMin * step}" if @prop.pointData.value
					@xAxis.prop.y.value = "#{-yMin * step}"
			else
				@yAxis.prop.range.value = [10, 0]
				@point.prop.y.value = 0
				@xAxis.prop.y.value = 0

		updateChildren: () ->
			@setWidth @prop.width.value
			@setHeight @prop.height.value
			@setXAxis @prop.xAxis.value
			@setYAxis @prop.yAxis.value

			Renderer.renderAll()


	if exports?
		root = exports
	else
		root = @
	_.extend root,
		Scatterplot: Scatterplot
)()
