(() ->
	$ = (selector) ->
		return if not selector?
		main = selector
		index = Math.max.apply this, [' ', '+', '>'].map (op) ->
					selector.lastIndexOf op
		main = selector.substr index if index > 0

		return document.getElementById selector.substr(1) if main[0] is '#'
		return document.body.querySelectorAll selector

	_ = {}

	_.isType = (obj, type) ->
		Object.prototype.toString.call(obj) is "[object #{type}]"

	_.extend = (obj, prop) ->
		obj = obj or {}
		for key, value of prop
			obj[key] = value
		obj

	_.getMouseLoc = (event) ->
		x: event.pageX
		y: event.pageY

	_.copy = (obj) ->
		JSON.parse (JSON.stringify obj)

	cid = 0
	_.cid = () ->
		'cid' + cid++

	if exports?
		exports._ = _
		exports.$ = $
	else
		@_ = _
		@$ = $
)()