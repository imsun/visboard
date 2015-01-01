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
			Renderer._render 'root', 'root', list,
				$data: null
				$index: null
				$parent: null
			Renderer.draw Renderer.primitives
			return Renderer.primitives
		_render: (id, pid, list, $parent) ->
			for child in list[pid].children
				children = Renderer.eval child, list[child].target, $parent
				Renderer.primitives[id].children = Renderer.primitives[id].children.concat children

			for child in Renderer.primitives[id].children
				# console.log child
				Renderer._render child.id, child.pid, list, child.dataRefer
			
		clear: () ->
			if $('#viewport')
				$('#viewport').innerHTML = ''

		eval: (pid, primitive, $parent) ->
			prop = primitive.prop
			return if pid is 'root'

			evalProp = (value, $data, $index, $domain, $parent) ->
				if value.enableCode
					propValue = value.code
				else
					propValue = value.value
				
				_runner = (value, enableCode) ->
					if _.isType value, 'String'
						if not enableCode
							try
								value = eval value
							catch e
								# console.log e
						else
							try
								fn = eval "(#{value})"
								value = fn($data, $index, $domain, $parent)
							catch e
								console.log e
								alert e
					return value

				if _.isType propValue, 'Array'
					return propValue.map _runner
				else
					return _runner propValue, value.enableCode

			runner = ($data, $index, $parent) ->
				_primitive =
					id: _.cid()
					pid: pid
					type: primitive.type
					children: []
					dataRefer:
						$data: $data
						$index: $index
						$parent: $parent
					prop: (() ->
						_prop = {}
						for key, value of prop
							_prop[key] = {}
							_.extend _prop[key], value
							_prop[key].value = evalProp value, $data, $index, $domain, $parent
						return _prop
					)()
				Renderer.primitives[_primitive.id] = _primitive
				return _primitive


			dataName = evalProp prop.data, null, null, $domain, $parent
			data = Data.list[dataName]

			if prop.domain? and prop.domain.value?
				_domain = prop.domain.value
				if _.isType _domain, 'String'
					_domain = JSON.parse _domain
				$domain = Data.list[_domain[0]].map (row) ->
					return row[_domain[1]]

			if data
				items = data.map (row, index) ->
							runner row, index, $parent
				return items
			else
				item = runner null, null, $parent
				return [item]

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