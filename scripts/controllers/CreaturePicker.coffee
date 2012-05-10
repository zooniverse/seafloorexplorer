Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
CircleMarker = require 'controllers/CircleMarker'
AxesMarker = require 'controllers/AxesMarker'

Point = require 'models/Point'

TEMPLATE = require 'lib/text!views/CreaturePicker.html'

style = require 'style'

class CreaturePicker extends Spine.Controller
  classification: null

  className: 'creature-picker'
  template: TEMPLATE

  paper: null
  indicator: null

  strayCircles: null
  strayAxes: null

  markers: null

  selectedSpecies: ''
  selectedMarkerType: ''

  disabled: false

  elements:
    '.map img': 'map'
    '.selection-area': 'selectionArea'
    '.selection-area img': 'image'

  events:
    'mousedown': 'onMouseDown'

  constructor: ->
    super

    @html @template

    @paper = Raphael @selectionArea[0], '100%', '100%'
    @image.insertBefore @paper.canvas

  ESC = 27
  delegateEvents: =>
    super

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

  createStrayCircle: (cx, cy) =>
    circle = @paper.circle cx, cy
    circle.attr style.circle
    @strayCircles.push circle

    @el.trigger 'create-stray-circle'

    circle

  createStrayAxis: =>
    # It'll always be between the last two stray circles.
    strayCircle1 = @strayCircles[@strayCircles.length - 2]
    strayCircle2 = @strayCircles[@strayCircles.length - 1]

    line = @paper.path Marker::lineBetween strayCircle1, strayCircle2
    line.toBack()
    line.attr style.boundingBox
    @strayAxes.push line

    @el.trigger 'create-stray-axis'

    line

  createStrayBoundingCircle: =>
    # It'll always be centered on the first stray circle.
    cx = @strayCircles[0].attr 'cx'
    cy = @strayCircles[0].attr 'cy'

    circle = @paper.circle cx, cy
    circle.attr style.line
    @strayAxes.push circle # Not an axis, but same idea.

    circle

  mouseIsDown: false
  onMouseDown: (e) =>
    return if @disabled
    return unless @image.add(@paper.canvas).is e.target

    m.deselect() for m in @markers when m.selected

    @mouseIsDown = true

    {left, top} = @selectionArea.offset()

    @createStrayCircle e.pageX - left, e.pageY - top

    e.preventDefault() # Disable text selection.

  dragThreshold: 10
  mouseMoves: 0
  movementCircle: null
  movementAxis: null
  movementBoundingCircle: null
  onMouseMove: (e) =>
    return unless @mouseIsDown and not @disabled

    @mouseMoves += 1
    return if @mouseMoves < @dragThreshold

    {width, height} = @getSize()
    {left, top} = @selectionArea.offset()

    @movementCircle ||= @createStrayCircle()

    fauxPoint = {}
    Point::setX.call fauxPoint, (e.pageX - left) / width
    Point::setY.call fauxPoint, (e.pageY - top) / height

    @movementCircle.attr
      cx: fauxPoint.x * width
      cy: fauxPoint.y * height

    @movementAxis ||= @createStrayAxis()
    secondLastCircle = @strayCircles[@strayCircles.length - 2]
    @movementAxis.attr
      path: Marker::lineBetween secondLastCircle, @movementCircle

    if @selectedMarkerType is 'circle'
      @movementBoundingCircle ||= @createStrayBoundingCircle()
      @movementBoundingCircle.attr
        r: @movementAxis.getTotalLength()

  onMouseUp: (e) =>
    return unless @mouseIsDown and not @disabled
    @mouseIsDown = false
    @mouseMoves = 0

    @checkStrays()

    @movementCircle = null
    @movementAxis = null
    @movementBoundingCircle = null

  checkStrays: =>
    if @strayCircles.length is 1
      @resetStrays()
    if @strayCircles.length is 2
      if @selectedMarkerType is 'circle'
        marker = @createCircleMarker()
    else if @strayCircles.length is 3
      @strayCircles.pop().remove()
    else if @strayCircles.length is 4
      marker = @createAxesMarker()

    @indicator.setStep @strayCircles.length - 1

    if marker?
      @markers.push marker

      setTimeout marker.deselect, 250

      marker.bind 'select', (marker) =>
        m.deselect() for m in @markers when m isnt marker
        @trigger 'change-selection'

      marker.bind 'deselect', =>
        @trigger 'change-selection'

      marker.bind 'release', =>
        @markers.splice(i, 1) for m, i in @markers when m is marker

      @resetStrays()

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
