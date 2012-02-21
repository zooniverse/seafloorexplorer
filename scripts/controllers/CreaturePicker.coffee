Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
style = require 'style'

class CreaturePicker extends Spine.Controller
	classification: null

	paper: null

	strayCircles: null
	strayLines: null

	markers: null

	selectedSpecies: ''

	disabled: false

	elements:
		'> img': 'img'

	events:
		'click': 'onClick'

	constructor: ->
		super
		@paper = Raphael @el[0], '100%', '100%'

	delegateEvents: =>
		super
		ESC = 27
		$(document).keydown (e) => @resetStrays() if e.keyCode is ESC

	changeClassification: (@classification) =>
		if @markers then @markers[0].release() until @markers.length is 0
		@markers = []
		@resetStrays()

	resetStrays: =>
		@strayCircles?.remove()
		@strayLines?.remove()
		@strayCircles = @paper.set()
		@strayLines = @paper.set()

	onClick: (e) ->
		return if @disabled

		marker.deactivate() for marker in @markers when marker.active

		offset = @el.offset()
		x = e.pageX - offset.left
		y = e.pageY - offset.top

		circle = @paper.circle x, y
		circle.attr style.circle
		@strayCircles.push circle

		if @selectedSpecies isnt 'seastar'
			# Each pair makes a line.
			if @strayCircles.length is 2
				line = @paper.path Marker::getLineString @strayCircles[0], @strayCircles[1]
			else if @strayCircles.length is 4
				line = @paper.path Marker::getLineString @strayCircles[2], @strayCircles[3]

			if line
				line.toBack()
				line.attr style.boundingBox
				@strayLines.push line

		# Each set of four (five for seastars) makes a marker.
		enoughCircles = 4
		enoughCircles = 5 if @selectedSpecies is 'seastar'

		if @strayCircles.length is enoughCircles
			marking = @classification.markings().create
				species: @selectedSpecies

			for circle in @strayCircles
				point = marking.points().create {}
				point.updateAttributes x: circle.attr('cx'), y: circle.attr('cy')

			marker = new Marker
				picker: @
				marking: marking

			marker.bind 'activate deactivate', => @trigger 'changed-selection', @
			marker.bind 'release', => @markers.splice(i, 1) for m, i in @markers when m is marker

			@markers.push marker
			marker.deactivate()

			@classification.trigger 'change'

			# Markers maintain their own circles and lines.
			@resetStrays()

	setDisabled: (@disabled) =>
		if @disabled then marker.deactivate() for marker in @markers or [] when marker.active
		if @disabled then @el.addClass 'disabled' else @el.removeClass 'disabled'

exports = CreaturePicker
