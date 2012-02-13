require.config
	paths:
		lib: '/lib'

define (require) ->
	$ = require 'jQuery'
	Spine = require 'Spine'

	CreaturePicker = require 'controllers/CreaturePicker'
	Classifier = require 'controllers/Classifier'

	# TODO: Make this an external resource.
	# They've been copied over from Bat Detective for now.
	Pager = require 'controllers/Pager'
	NestedRoute = require 'NestedRoute'

	layout = require 'layout'

	class Page extends Spine.Controller

	creaturePicker = new CreaturePicker el: $('#subject')
	classifier = new Classifier el: $('classifier'), picker: creaturePicker

	window.pagers = @$('[data-page]').parent().map -> new Pager el: @
	NestedRoute.setup()

	$(document).ready layout
	$(window).resize layout
