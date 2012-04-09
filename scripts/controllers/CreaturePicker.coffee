Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
CircleMarker = require 'controllers/CircleMarker'
AxesMarker = require 'controllers/AxesMarker'

TEMPLATE = require 'lib/text!views/CreaturePicker.html'

style = require 'style'

class CreaturePicker extends Spine.Controller
	classification: null

	className: 'creature-picker'
	template: TEMPLATE

	paper: null

	strayCircles: null
	strayAxes: null

	markers: null

	selectedSpecies: ''

	disabled: false

	elements:
		'> .selection-area': 'selectionArea'
		'> .selection-area > img': 'image'

	events:
		'mousedown': 'onMouseDown'

	constructor: ->
		super

		@html @template
		@refreshElements()

		@paper = Raphael @selectionArea[0], '100%', '100%'
		@image.insertBefore @paper.canvas

	ESC = 27
	delegateEvents: =>
		super

		# $(window).on 'resize', @resize

		$(document).on 'mousemove', @onMouseMove
		$(document).on 'mouseup', @onMouseUp

		$(document).on 'keydown', (e) =>
			@resetStrays() if e.keyCode is ESC

	getSize: =>
		width: @image.width(), height: @image.height()

	resize: =>
		imageProportion = @image[0].naturalWidth / @image[0].naturalHeight
		elProportion = @el.width() / @el.height()

		if imageProportion < elProportion
			@selectionArea.css width: '', height: '100%'
			@image.css width: '', height: '100%'
			@selectionArea.css width: @image.width()
			@selectionArea.css left: (@el.width() - @selectionArea.width()) / 2, top: ''
		else
			@selectionArea.css width: '100%', height: ''
			@image.css width: '100%', height: ''
			@selectionArea.css height: @image.height()
			@selectionArea.css left: '', top: (@el.height() - @selectionArea.height()) / 2

		@paper.setSize @selectionArea.width(), @selectionArea.height()

		marker.render() for marker in @markers or []

	mouseIsDown: false
	onMouseDown: (e) =>
		return if @disabled
		return unless @image.add(@paper.canvas).is e.target

		@mouseIsDown = true

		m.deselect() for m in @markers when m.selected

		{left, top} = @selectionArea.offset()
		@createStrayCircle e.pageX - left, e.pageY - top

		@checkStrays()

		e.preventDefault() # Disable text selection

	createStrayCircle: (cx, cy) =>
		circle = @paper.circle cx, cy
		circle.attr style.circle
		@strayCircles.push circle

		@el.trigger 'create-stray-circle'

		circle

	createStrayAxis: =>
		strayCircle1 = @strayCircles[@strayCircles.length - 2]
		strayCircle2 = @strayCircles[@strayCircles.length - 1]

		line = @paper.path Marker::lineBetween strayCircle1, strayCircle2
		line.toBack()
		line.attr style.boundingBox
		@strayAxes.push line

		@el.trigger 'create-stray-axis'

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

		{left, top} = @selectionArea.offset()
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

		marking.bind 'destroy', => @classification.trigger 'change'

		{width: w, height: h} = @getSize()

		for circle in @strayCircles
			point = marking.points().create {}
			point.updateAttributes
				x: circle.attr('cx') / w
				y: circle.attr('cy') / h

		@classification.trigger 'change'

		@el.trigger 'create-marking'

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
		if @disabled then marker.deselect() for marker in @markers or [] when marker.selected
		if @disabled then @selectionArea.addClass 'disabled' else @selectionArea.removeClass 'disabled'

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
