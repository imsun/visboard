(() ->
	class Modal extends View
		init: (@id) ->
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'modal'

		hide: () ->
			@domElement.className = 'modal'

		show: (props) ->
			for id, prop of props
				new PropRow @, _cid(), id, prop
			@domElement.className = 'modal show'

	@Modal = Modal
)()