define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	Marking = require 'controllers/Marking'
	style = require 'style'

	class CreaturePicker extends Spine.Controller
		paper: null

		strayCircles: null
		strayLines: null
		markings: null

		disabled: false

		selectedSpecies: ''

		elements:
			'> img': 'img'

		events:
			'click': 'onClick'

		constructor: ->
			super
			@paper = Raphael @el[0], '100%', '100%'
			@markings = []
			@reset()

		delegateEvents: =>
			super
			$(document).keydown (e) => @clearStrays() if e.keyCode is 27 # Escape

		setSubject: (@subject) =>
			@img.attr 'src', @subject.src

		reset: =>
			marking.release() for marking in @markings
			@resetStrays()

		resetStrays: =>
			@strayCircles = @paper.set()
			@strayLines = @paper.set()

		onClick: (e) ->
			return if @disabled

			marking.deactivate() for marking in @markings when marking.active

			offset = @el.offset()
			x = e.pageX - offset.left
			y = e.pageY - offset.top

			circle = @paper.circle x, y
			circle.attr style.circle
			@strayCircles.push circle

			# Each pair makes a line.
			if @strayCircles.length is 2
				line = @paper.path Marking::getLineString @strayCircles[0], @strayCircles[1]
			else if @strayCircles.length is 4
				line = @paper.path Marking::getLineString @strayCircles[2], @strayCircles[3]

			if line
				line.toBack()
				line.attr style.line
				@strayLines.push line

			# Each set of four makes a marking.
			if @strayCircles.length is 4
				marking = @subject.markings().create
					species: @selectedSpecies
					points: ({x: c.attr('cx'), y: c.attr('cy')} for c in @strayCircles)

				markingController = new Marking
					picker: @
					circles: @strayCircles
					lines: @strayLines
					model: marking

				markingController.deactivate()
				@markings.push markingController

				@resetStrays()

		clearStrays: =>
			@strayCircles.remove()
			@strayLines.remove()

			@resetStrays()

		setDisabled: (@disabled) =>
			if @disabled then marking.deactivate() for marking in @markings when marking.active
			if @disabled then @el.addClass 'disabled' else @el.removeClass 'disabled'
