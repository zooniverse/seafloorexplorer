Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
CircleMarker = require 'controllers/CircleMarker'
AxesMarker = require 'controllers/AxesMarker'

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
		'mousedown': 'onMouseDown'

	constructor: ->
		super
		@paper = Raphael @el[0], '100%', '100%'

	ESC = 27
	delegateEvents: =>
		super

		$(document).on 'mousemove', @onMouseMove
		$(document).on 'mouseup', @onMouseUp

		$(document).on 'keydown', (e) =>
			@resetStrays() if e.keyCode is ESC

	onMouseDown: (e) =>
		return if @disabled or e.target isnt @paper.canvas
		@mouseDown = e

		m.deselect() for m in @markers when m.selected

		{left, top} = @el.offset()
		circle = @paper.circle e.pageX - left, e.pageY - top
		circle.attr style.circle
		@strayCircles.push circle

		if @strayCircles.length is 2
			if @selectedSpecies is 'seastar'
				marker = @createCircleMarker()
			else
				@createAxis()
		else if @strayCircles.length is 4
			marker = @createAxesMarker()

		if marker?
			marker.bind 'select', (marker) =>
				m.deselect() for m in @markers when m isnt marker
				@trigger 'change-selection'

			marker.bind 'deselect', =>
				@trigger 'change-selection'

			marker.bind 'release', =>
				@markers.splice(i, 1) for m, i in @markers when m is marker

			@markers.push marker
			marker.deselect()

	onMouseMove: (e) =>
		return unless @mouseDown and not @disabled

	createCircleMarker: (x, y) =>
		marking = @createMarking()
		marker = new CircleMarker
			marking: marking
			paper: @paper

	createAxis: =>
			line = @paper.path Marker::lineBetween @strayCircles[0], @strayCircles[1]
			line.toBack()
			line.attr style.boundingBox
			@strayLines.push line

	createAxesMarker: =>
		marking = @createMarking()

		marker = new AxesMarker
			marking: marking
			paper: @paper

	createMarking: =>
		marking = @classification.markings().create
			species: @selectedSpecies

		for circle in @strayCircles
			point = marking.points().create {}
			point.updateAttributes
				x: circle.attr 'cx'
				y: circle.attr 'cy'

		@classification.trigger 'change'
		@resetStrays()

		marking

	onMouseUp: (e) =>
		return if @disabled

	setDisabled: (@disabled) =>
		if @disabled then marker.deactivate() for marker in @markers or [] when marker.active
		if @disabled then @el.addClass 'disabled' else @el.removeClass 'disabled'

	changeClassification: (@classification) =>
		if @markers then @markers[0].release() until @markers.length is 0
		@markers = []
		@resetStrays()

	resetStrays: =>
		@strayCircles?.remove()
		@strayCircles = @paper.set()

		@strayLines?.remove()
		@strayLines = @paper.set()

exports = CreaturePicker
