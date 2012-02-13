require.config
	paths:
		lib: '/lib'

define (require) ->
	CreaturePicker = require 'CreaturePicker'
	$ = require 'jQuery'
	layout = require 'layout'

	window.creaturePicker = new CreaturePicker el: $('#subject')

	$(document).ready layout
	$(window).resize layout
