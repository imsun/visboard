(() ->
	class CodeEditor extends View

		init: (@id) ->
			self = @
			@domElement = document.createElement 'div'
			@domElement.id = @id
			@domElement.className = 'code-editor'

			codeArea = document.createElement 'textarea'
			codeArea.className = 'code-area'

			enableCode = document.createElement 'label'
			enableCode.className = 'enable-code-flag'
			enableCode.innerHTML = '<input type="checkbox" checked> Enable programing'
			
			cancelButton = document.createElement 'button'
			cancelButton.className = 'cancel-button'
			cancelButton.innerText = 'Cancel'
			cancelButton.addEventListener 'click', (e) ->
				self.hide()

			confirmButton = document.createElement 'button'
			confirmButton.className = 'confirm-button'
			confirmButton.innerText = 'Save'
			confirmButton.addEventListener 'click', (e) ->
				self.save()
				self.hide()

			@domElement.appendChild codeArea
			@domElement.appendChild enableCode
			@domElement.appendChild cancelButton
			@domElement.appendChild confirmButton

			@domElement.codeAreaEl = codeArea
			@domElement.enableCodeEl = enableCode
			@domElement.cancelButtonEl = cancelButton
			@domElement.confirmButtonEl = confirmButton

		hide: () ->
			@domElement.className = 'code-editor'

		show: (code, flag, callback) ->
			@domElement.codeAreaEl.value = code
			@domElement.className = 'code-editor show'
			@domElement.enableCodeEl.firstChild.checked = flag is true
			@callback = callback

		save: () ->
			@callback @domElement.codeAreaEl.value, @domElement.enableCodeEl.firstChild.checked if @callback?

	@CodeEditor = CodeEditor
)()