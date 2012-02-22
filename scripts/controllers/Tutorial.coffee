Spine = require 'Spine'
$ = require 'jQuery'
{delay, translate} = require 'util'

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
		@message.add(@underlay).css display: ''
		@current = -1
		@next()

	next: (e) =>
		e?.stopPropagation?()

		if ~@current then @steps[@current].leave @

		@current += 1
		if @steps[@current]
			@steps[@current].enter @
		else
			@message.add(@underlay).css display: 'none'

class Tutorial.Step
	style: null
	className: ''
	arrows: '' # "{top|right|bottom|left}-{top|right|bottom|left}"
	content: ''
	modal: false
	nextOn: null

	continueParagraph: null

	constructor: (params) ->
		@[param] = value for param, value of params

	enter: (tutorial) =>
		both = tutorial.message.add tutorial.underlay

		tutorial.message.html @content

		if @nextOn
			$(document).on event, selector, tutorial.next for event, selector of @nextOn
		else
			buttonsHolder = $('<div class="continue"></div>')
			continueButtons = translate 'tutorialContinue', 'button'
			buttonsHolder.append continueButtons
			tutorial.message.append buttonsHolder
			tutorial.message.on 'click', '.continue button', tutorial.next

		tutorial.message.css @style
		if @modal then both.addClass 'modal'
		delay 333, => both.addClass @className

	leave: (tutorial) =>
		both = tutorial.message.add tutorial.underlay

		tutorial.message.html ''

		if @nextOn
			$(document).off event, selector, tutorial.next for event, selector of @nextOn
		else
			tutorial.message.off 'click', '.continue button', tutorial.next

		tutorial.message.css prop: '' for prop of @style
		both.removeClass 'modal'
		both.removeClass @className

exports = Tutorial
