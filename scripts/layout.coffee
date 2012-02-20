$ = require 'jQuery'

win = $(window)
header = $('#wrapper > header')
main = $('#main')
footer = $('#wrapper > footer')

headerHeight = 0.67

actualHeight = ($el) ->
	actualHeaderHeight = $el.height()
	actualHeaderHeight += parseFloat $el.css 'borderBottomWidth'
	actualHeaderHeight += parseFloat $el.css 'borderTopWidth'

layout = ->
	leftover = win.height() - main.height()

	header.height Math.floor leftover * headerHeight

	main.css top: actualHeight header

	footerHeight = win.height() - (actualHeight(header) + actualHeight(main))

	if footerHeight >= 0
		footer.css 'display', ''
		footer.height footerHeight
	else
		footer.css 'display', 'none'

exports = layout
