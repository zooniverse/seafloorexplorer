define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	Marking = require 'Marking'
	style = require 'style'

	class CreaturePicker extends Spine.Controller
		paper: null
		strayCircles = null
		strayLines = null
		markings: null

		events:
			'click': 'onClick'

		constructor: ->
			super

			@paper = Raphael @el[0], '100%', '100%'
			@markings = []

			@resetStrays()

		resetStrays: =>
			@strayCircles = @paper.set()
			@strayLines = @paper.set()

		onClick: (e) ->
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
				@markings.push new Marking picker: @, circles: @strayCircles, lines: @strayLines
				@resetStrays()
