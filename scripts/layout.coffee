define (require) ->
	$ = require 'jQuery'

	win = $(window)
	header = $('#wrapper > header')
	main = $('#main')
	footer = $('#wrapper > footer')

	headerHeight = 0.9
	footerHeight = 1 - headerHeight

	# Divide up the header and footer heights.
	layout = ->
		leftover = win.height() - main.height()
		header.height leftover * headerHeight
		main.css top: leftover * headerHeight
		footer.height leftover * footerHeight

	layout
