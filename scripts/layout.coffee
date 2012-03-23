$ = require 'jQuery'

subject = $('#subject')

layout = ->
	if subject.width() < subject.height()
		subject.addClass 'portrait'
		subject.removeClass 'landscape'
	else
		subject.removeClass 'portrait'
		subject.addClass 'landscape'

exports = layout
