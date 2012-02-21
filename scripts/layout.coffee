$ = require 'jQuery'

win = $(window)
header = $('#wrapper > header')
main = $('#main')
footer = $('#wrapper > footer')

headerHeight = 0.67

layout = ->
	leftover = win.height() - main.outerHeight()

	header.height Math.floor leftover * headerHeight

	main.css top: header.outerHeight()

	footerHeight = win.height() - (header.outerHeight() + main.outerHeight())

	if footerHeight >= 0
		footer.css 'display', ''
		footer.height footerHeight
	else
		footer.css 'display', 'none'

exports = layout
