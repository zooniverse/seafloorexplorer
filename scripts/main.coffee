require.config
	paths:
		lib: '/lib'

define (require) ->
	CreaturePicker = require 'CreaturePicker'
	$ = require 'jQuery'

	window.creaturePicker = new CreaturePicker el: $('#subject')
