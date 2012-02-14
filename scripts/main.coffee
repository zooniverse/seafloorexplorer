require.config
	paths:
		lib: '/lib'

define (require) ->
	$ = require 'jQuery'
	Spine = require 'Spine'

	CreaturePicker = require 'controllers/CreaturePicker'
	Classifier = require 'controllers/Classifier'
	Subject = require 'models/Subject'

	# TODO: Make this an external resource.
	# They've been copied over from Bat Detective for now.
	Pager = require 'controllers/Pager'
	NestedRoute = require 'NestedRoute'

	layout = require 'layout'

	subjects = []

	subjects.push new Subject
		src: 'https://encrypted-tbn1.google.com/images?q=tbn:ANd9GcSBV4syySJle_M5M818io0sWRs77KdoMy9XaRV4v0AbwkeyTbfc4g'
		latitude: 12.3
		longitude: 45.6
		depth: 90

	creaturePicker = new CreaturePicker el: $('#subject'), disabled: true
	window.classifier = new Classifier el: $('#classifier'), picker: creaturePicker, subject: subjects[0]

	window.pagers = $('[data-page]').parent().map -> new Pager el: @
	NestedRoute.setup()

	# TODO: Prevent direct access to /classify/*

	$(document).ready layout
	$(window).resize layout
