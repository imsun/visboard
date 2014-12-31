(() ->
	class PropRow extends View
		init: (id, key, prop) ->
			@id = id
			@prop = prop
			if _.isType prop.value, 'Function'
				propValue = prop.value()
			else
				propValue = prop.value

			@domElement = document.createElement 'div'
			@domElement.id = key
			@domElement.className = 'prop-row'
			propLabelEl = document.createElement 'label'
			propLabelEl.id = _.cid()
			propLabelEl.className = 'prop-label'
			propLabelEl.innerHTML = prop.name

			# if prop.type is 'select'
			event = 'change'
			
			switch prop.type
				when 'title'
					propLabelEl.className += ' prop-title'
				when 'label'
					propValueEl = document.createElement 'input'
					propValueEl.className = 'prop-value'
					propValueEl.type = 'text'
					propValueEl.readOnly = 'readOnly'
					propValueEl.value = propValue
				when 'text'
					propValueEl = document.createElement 'input'
					propValueEl.className = 'prop-value'
					propValueEl.type = 'text'
					propValueEl.value = propValue
				when 'number'
					propValueEl = document.createElement 'input'
					propValueEl.className = 'prop-value'
					propValueEl.type = 'text'
					propValueEl.value = propValue
				when 'boolean'
					propValueEl = document.createElement 'input'
					propValueEl.className = 'prop-value'
					propValueEl.type = 'checkbox'
					propValueEl.checked = propValue
					propValueEl.addEventListener event, (e) ->
						prop.listener this.checked				
				when 'select'
					propValueEl = document.createElement 'select'
					propValueEl.className = 'prop-value'
					if _.isType prop.set, 'Function'
						set = prop.set()
					else
						set = prop.set
					for optionInfo in set
						option = document.createElement 'option'
						option.value = optionInfo.value
						option.innerHTML = optionInfo.name
						if optionInfo.value is propValue
							option.setAttribute 'selected', 'selected'
						propValueEl.appendChild option
				when 'range'
					propValueEl = document.createElement 'span'
					propValueEl.className = 'prop-value prop-range'

					startEl = document.createElement 'input'
					startEl.type = 'text'
					startEl.value = propValue[0]

					endEl = document.createElement 'input'
					endEl.type = 'text'
					endEl.value = propValue[1]

					if prop.listener?
						changeRange = () ->
							prop.listener [startEl.value, endEl.value]

						startEl.addEventListener event, changeRange
						endEl.addEventListener event, changeRange

					temp = document.createElement 'span'
					temp.innerText = ' - '

					propValueEl.appendChild startEl
					propValueEl.appendChild temp
					propValueEl.appendChild endEl


			@domElement.appendChild propLabelEl
			if propValueEl?
				@domElement.appendChild propValueEl
				if prop.listener? and not (prop.type in ['range', 'boolean'])
					propValueEl.addEventListener event, () ->
						prop.listener this.value

			if prop.code?
				codeButton = document.createElement 'button'
				codeButton.className = 'prop-code'
				codeButton.innerText = '</>'
				codeButton.addEventListener 'click', () ->
					Codeeditor.show prop.code, prop.enableCode, (code, flag) ->
						prop.code = code
						prop.enableCode = flag
						if flag
							propValueEl.style.display = 'none'
							codeButton.style.float = 'left'
						else
							propValueEl.style.display = ' inline-block'
							codeButton.style.float = 'right'
						prop.codeListener code, flag if prop.codeListener?
						Renderer.renderAll()
				if prop.enableCode and propValueEl?
					propValueEl.style.display = 'none'
					codeButton.style.float = 'left'
						
				@domElement.appendChild codeButton
					
	@PropRow = PropRow
)()