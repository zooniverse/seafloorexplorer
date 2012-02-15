require.config
	paths:
		lib: '/lib'

define (require) ->
	$ = require 'jQuery'

	CreaturePicker = require 'controllers/CreaturePicker'
	Classifier = require 'controllers/Classifier'
	Subject = require 'models/Subject'

	# TODO: Make this an external resource.
	# They've been copied over from Bat Detective for now.
	Pager = require 'controllers/Pager'
	NestedRoute = require 'NestedRoute'

	layout = require 'layout'

	window.pagers = $('[data-page]').parent().map -> new Pager el: @
	NestedRoute.setup()

	$(document).ready layout
	$(window).resize layout

	Subject.create
		src: 'https://encrypted-tbn1.google.com/images?q=tbn:ANd9GcSBV4syySJle_M5M818io0sWRs77KdoMy9XaRV4v0AbwkeyTbfc4g'
		latitude: 12.3
		longitude: 45.6
		depth: 90

	window.classifier = new Classifier
		el: $('#classifier')
		picker: new CreaturePicker
			el: $('#subject')
		subject: Subject.first()
