Spine = require 'Spine'
$ = require 'jQuery'

class Tutorial extends Spine.Controller
	steps: null

	className: 'tutorial'
	message: null
	underlay: null

	current = -1

	constructor: ->
		super
		@steps ?= []

		@underlay = $('<div></div>')
		@underlay.addClass 'underlay'

		@underlay.appendTo @el

		@message = $('<div></div>')
		@message.addClass 'message'

		@message.appendTo @el

	start: =>
		@current = -1
		@next()

	next: (e) =>
		e?.stopPropagation?()

		if ~@current then @steps[@current].leave @

		@current += 1
		if @steps[@current]
			@steps[@current].enter @
		else
			@message.add(@underlay).remove()

class Tutorial.Step
	style: null
	className: ''
	arrows: '' # "{top|right|bottom|left}-{top|right|bottom|left}"
	content: ''
	modal: false
	nextOn: null

	constructor: (params) ->
		@[param] = value for param, value of params

	enter: (tutorial) =>
		both = tutorial.message.add tutorial.underlay

		tutorial.message.html @content

		if @nextOn
			$(window).on event, selector, tutorial.next for event, selector of @nextOn
		else
			tutorial.message.on 'click', tutorial.next

		tutorial.message.css @style
		both.addClass @className
		if @modal then both.addClass 'modal'

	leave: (tutorial) =>
		both = tutorial.message.add tutorial.underlay

		tutorial.message.html ''

		if @nextOn
			$(window).off event, selector, tutorial.next for event, selector of @nextOn
		else
			tutorial.message.off 'click', tutorial.next

		tutorial.message.css prop: '' for prop of @style
		both.removeClass @className
		both.removeClass 'modal'

exports = Tutorial
