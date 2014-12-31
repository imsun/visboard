(() ->
	class PropPanel extends View
		init: (id) ->
			@id = id
						
			@domElement = document.createElement 'div'
			@domElement.id = id
			@domElement.className = 'prop-panel'

			if TreePanel?
				TreePanel.selectListener.push
					self: @
					fn: @display

		display: (node) ->
			@clear()
			primitive = node.target

			for key, value of primitive.prop
				new Sidebar.PropRow @, _.cid(), key, value

	@Sidebar.PropPanel = PropPanel
)()