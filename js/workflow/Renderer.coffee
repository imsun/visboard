(() ->
	Renderer =
		primitives:
			root:
				type: 'root'
				children: []
		target: '#viewport'
		renderAll: () ->
			Renderer.clear()
			Renderer.render Primitives.tree.data
		render: (list) ->
			Renderer.primitives =
				root:
					type: 'root'
					children: []
			Renderer._render 'root', 'root', list
			Renderer.draw Renderer.primitives
			return Renderer.primitives
		_render: (id, pid, list) ->
			for child in list[pid].children
				temp = (Renderer.eval child, list[child].target)
				Renderer.primitives[id].children = Renderer.primitives[id].children.concat temp
			for child in Renderer.primitives[id].children
				Renderer._render child.id, child.pid, list
			
		clear: () ->
			if $('#viewport')
				$('#viewport').innerHTML = ''

		eval: (pid, primitive) ->
			prop = primitive.prop
			return if pid is 'root'
			if prop.data? and prop.data.value? or prop.domain? and prop.domain.value?
				runner = ($data, $index, $domain) ->
					_primitive =
						id: _.cid()
						pid: pid
						type: primitive.type
						children: []
						prop: (() ->
							_prop = {}
							for key, value of prop
								_prop[key] = {}
								_.extend _prop[key], value
								
								_runner = (value) ->
									if _.isType value, 'String'
										if not value.match /^function.+}$/
											try
												value = eval value
											catch e
												# console.log e
										else
											try
												fn = eval "(#{value})"
												value = fn($data, $index, $domain)
											catch e
												console.log e
												alert e
									return value

								if _.isType value.value, 'Array'
									_prop[key].value = value.value.map _runner
								else
									_prop[key].value = _runner value.value

							return _prop
						)()
					Renderer.primitives[_primitive.id] = _primitive
					return _primitive

				data = Data.list[prop.data.value]

				if prop.domain? and prop.domain.value?
					_domain = prop.domain.value
					if _.isType _domain, 'String'
						_domain = JSON.parse _domain
					$domain = Data.list[_domain[0]].map (row) ->
						return row[_domain[1]]

				if data
					# TO DO
					# 	应在传入的数据里存储 children 的引用
					items = data.map runner
					return items
				else
					item = runner null, null, $domain
					return [item]
			else
				_primitive =
					id: _.cid()
					pid: pid
					type: primitive.type
					prop: primitive.prop
					children: []
				Renderer.primitives[_primitive.id] = _primitive
				return [_primitive]

		draw: (primitives) ->
			primitives = primitives or Renderer.primitives
			width = $(Renderer.target).width
			height = $(Renderer.target).height
			svg = d3.select Renderer.target
					.append 'svg'
					.attr 'width', width
					.attr 'height', height
			Renderer._draw primitives.root, svg

		_draw: (primitive, parent) ->
			el = null
			prop = primitive.prop
			width = $(Renderer.target).width
			height = $(Renderer.target).height
			display = 'inline'
			display = 'none' if prop? and not prop.visiable.value
			if prop? and prop.x? and prop.y?
				x = (parseFloat prop.x.value)
				y =  -parseFloat prop.y.value
			switch primitive.type
				when 'root'
					el = parent.append 'g'
						.attr 'transform', "translate(40, #{height / 2})"
				when 'circle'
					el = parent.append 'circle'
						.attr 'cx', x
						.attr 'cy', y
						.attr 'r', prop.radius.value
						.style 'fill', 'black'
				when 'axis'
					scale = d3.scale.linear()
							.domain prop.range.value
							.range [0, prop.length.value]
					axis = d3.svg.axis()
							.scale scale
							.ticks  prop.ticks.value
							.orient 'bottom'
					el = parent.append 'g'
						.attr('class', 'axis')
						.attr 'transform', "translate(#{x}, #{y}) rotate(#{prop.rotate.value})"
						.call axis
				else
					el = parent.append 'g'
						.attr 'transform', "translate(#{x}, #{y}) rotate(#{prop.rotate.value}) scale(#{prop.scale.value})"
			el.attr 'style', "display: #{display}"

			for child in primitive.children
				Renderer._draw child, el

			return el

	if exports?
		module.exports = Renderer
	else
		@Renderer = Renderer
)()