define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	Marking = require 'controllers/Marking'
	style = require 'style'

	class CreaturePicker extends Spine.Controller
		paper: null
		strayCircles = null
		strayLines = null
		markings: null

		disabled: false

		typeForNewMarkings: ''

		elements:
			'> img': 'img'

		events:
			'click': 'onClick'

		constructor: ->
			super

			@paper = Raphael @el[0], '100%', '100%'
			@markings = []

			@resetStrays()

		delegateEvents: =>
			super

			$(document).keydown (e) =>
				if e.keyCode is 27 then @clearStrays()

		setImgSrc: (src) =>
			@img.attr 'src', src

		clearStrays: =>
			@strayCircles.remove()
			@strayLines.remove()

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
				marking = new Marking
					picker: @
					circles: @strayCircles
					lines: @strayLines
					type: @typeForNewMarkings

				@markings.push marking

				marking.bind 'activate deactivate', @selectionChanged

				# Because "activate" is triggered before we can bind to it:
				@markingCreated marking
				@selectionChanged marking

				@resetStrays()

		selectionChanged: (marking) =>
			@log 'Selected marking', marking
			@trigger 'selected', marking

		markingCreated: (marking) =>
			@log 'Created marking', marking
			@trigger 'created', marking

		setDisabled: (@disabled) =>
			if @disabled then @el.addClass 'disabled' else @el.removeClass 'disabled'
			if @disabled then marking.deactivate() for marking in @markings when marking.active

		reset: =>
			marking.release() for marking in @markings
			@markings.splice 0, @markings.length
