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

		pointRadius: 5

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

			circle = @paper.circle x, y, @pointRadius
			circle.attr style.circle
			@strayCircles.push circle

			# Each pair makes a line.
			if @strayCircles.length is 2
				line = @paper.path @pathString @strayCircles[0], @strayCircles[1]
			else if @strayCircles.length is 4
				line = @paper.path @pathString @strayCircles[2], @strayCircles[3]

			if line
				line.toBack()
				line.attr style.line
				@strayLines.push line

			# Each set of four makes a marking.
			if @strayCircles.length is 4
				@markings.push new Marking paper: @paper, circles: @strayCircles, lines: @strayLines
				@resetStrays()

		pathString: (c1, c2) =>
			x1 = c1.attr 'cx'
			y1 = c1.attr 'cy'
			x2 = c2.attr 'cx'
			y2 = c2.attr 'cy'

			"M #{x1} #{y1} L #{x2} #{y2}"
