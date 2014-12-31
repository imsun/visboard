(() ->
	class View
		constructor: (parent, config...) ->
			@parent = parent
			@children = {}
			@domElement

			@init.apply this, config
			@id = @id or _.cid()
			@domElement.id = _.cid() if @domElement? and @domElement.id is 'undefined'

			@parent.add @ if parent?

		init: (config...) ->
			@id = _.cid()
			@domElement = document.createElement 'div'
			@domElement.id = _.cid()
			@domElement.className = 'view'

		add: (child) ->
			@children[child.id] = child
			@domElement.appendChild child.domElement

		clear: () ->
			@children = []
			@domElement.innerHTML = ''

	@View = View
)()