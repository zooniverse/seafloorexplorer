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
	strayAxes: null

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

	mouseIsDown: false
	onMouseDown: (e) =>
		return if @disabled or e.target isnt @paper.canvas

		@mouseIsDown = true

		m.deselect() for m in @markers when m.selected

		{left, top} = @el.offset()
		@createStrayCircle e.pageX - left, e.pageY - top

		@checkStrays()

	createStrayCircle: (cx, cy) =>
		circle = @paper.circle cx, cy
		circle.attr style.circle
		@strayCircles.push circle
		circle

	createStrayAxis: =>
		strayCircle1 = @strayCircles[@strayCircles.length - 2]
		strayCircle2 = @strayCircles[@strayCircles.length - 1]

		line = @paper.path Marker::lineBetween strayCircle1, strayCircle2
		line.toBack()
		line.attr style.boundingBox
		@strayAxes.push line

		line

	dragThreshold: 10
	mouseMoves: 0
	movementCircle: null
	movementAxis: null
	onMouseMove: (e) =>
		return unless @mouseIsDown and not @disabled
		return if @strayCircles.length % 2 is 0 and not @movementCircle

		@mouseMoves += 1
		return if @mouseMoves < @dragThreshold

		@movementCircle = @createStrayCircle() unless @movementCircle?
		@movementAxis = @createStrayAxis() unless @movementAxis?

		{left, top} = @el.offset()
		@movementCircle.attr
			cx: e.pageX - left
			cy: e.pageY - top

		secondLastCircle = @strayCircles[@strayCircles.length - 2]
		@movementAxis.attr
			path: Marker::lineBetween secondLastCircle, @movementCircle

	onMouseUp: (e) =>
		return unless @mouseIsDown and not @disabled
		@mouseIsDown = false
		@mouseMoves = 0

		@movementCircle = null
		@movementAxis = null

		@checkStrays()

	createCircleMarker: (x, y) =>
		marking = @createMarking()
		marker = new CircleMarker
			marking: marking
			paper: @paper

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

		marking

	checkStrays: =>
		if @strayCircles.length is 2
			if @selectedSpecies is 'seastar'
				marker = @createCircleMarker()
			else if @strayAxes.length is 0
				@createStrayAxis()
		else if @strayCircles.length is 4
			marker = @createAxesMarker()

		if marker?
			@markers.push marker
			marker.deselect()

			marker.bind 'select', (marker) =>
				m.deselect() for m in @markers when m isnt marker
				@trigger 'change-selection'

			marker.bind 'deselect', =>
				@trigger 'change-selection'

			marker.bind 'release', =>
				@markers.splice(i, 1) for m, i in @markers when m is marker

			@resetStrays()

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

		@strayAxes?.remove()
		@strayAxes = @paper.set()

exports = CreaturePicker
