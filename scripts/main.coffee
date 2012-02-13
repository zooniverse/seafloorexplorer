require.config
	paths:
		lib: '/lib'

define (require) ->
	$ = require 'jQuery'
	CreaturePicker = require 'controllers/CreaturePicker'
	Classifier = require 'controllers/Classifier'
	layout = require 'layout'

	creaturePicker = new CreaturePicker el: $('#subject')

	classifier = new Classifier el: $('classifier'), picker: creaturePicker

	$(document).ready layout
	$(window).resize layout
