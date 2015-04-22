(() ->
	class DataPanel extends View
		init: (id) ->
			@id = id

			@domElement = document.createElement 'div'
			@domElement.id = id
			@domElement.className = 'data-panel'

		display: (node) ->
			@clear()

			for key, value of node.prop
				new PropRow @, _.cid(), key, value

			if node.type is 'data'
				addToPoolBtn = document.createElement 'button'
				addToPoolBtn.innerText = 'Pass on'
				addToPoolBtn.className = 'prop-btn'
				addToPoolBtn.onclick = () ->
					console.log node
					Data.get().members[node.name].output()

				@add
					domElement: addToPoolBtn

	@Bottombar.DataPanel = DataPanel
)()
