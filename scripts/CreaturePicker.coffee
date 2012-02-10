Spine = require 'Spine'

class CreaturePicker extends Spine.Controller
	markable: true
	points = null

	markings: null

	events:
		'click': 'onClick'

	constructor: ->
		super
		@markings = []
		@points = []

	onClick: (e) ->
		return unless @markable

		@addPoint e.pageX, e.pageY

		if @points.length is 4
			addMarking @points...

	addPoint: (x, y) =>
		@points.push [x, y]
		# Draw the point

	addMarking: (p1, p2, p3, p4) =>
		# Instantiate the marking
		# Add it to @markings
