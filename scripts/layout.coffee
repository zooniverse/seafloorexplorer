define (require) ->
	$ = require 'jQuery'

	win = $(window)
	header = $('#wrapper > header')
	main = $('#main')
	footer = $('#wrapper > footer')

	headerHeight = 0.67

	layout = ->
		leftover = win.height() - main.height()

		header.height leftover * headerHeight

		main.css top: header.height()

		footerHeight = win.height() - (header.height() + main.height())

		if footerHeight > 0
			footer.css 'display', ''
			footer.height footerHeight
		else
			footer.css 'display', 'none'

	layout
