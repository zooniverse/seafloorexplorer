define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jquery'
  Raphael = require 'Raphael'

  Marker = require 'controllers/Marker'
  CircleMarker = require 'controllers/CircleMarker'
  AxesMarker = require 'controllers/AxesMarker'

  Annotation = require 'zooniverse/models/Annotation'

  TEMPLATE = require 'views/CreaturePicker'

  style = require 'style'

  class CreaturePicker extends Spine.Controller
    className: 'creature-picker'
    template: TEMPLATE

    paper: null

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
      '.selection-area .scale': 'scale'

    events:
      'mousedown': 'onMouseDown'

    constructor: ->
      super

      @html @template

      @paper = Raphael @selectionArea[0], '100%', '100%'
      @image.insertBefore @paper.canvas

      @changeClassification null

    ESC = 27
    delegateEvents: =>
      super

      $(document).on 'mousemove', @onMouseMove
      $(document).on 'mouseup', @onMouseUp

      $(document).on 'keydown', (e) =>
        if e.keyCode is ESC
          @resetStrays()
          @classifier.indicator.setStep 0

    reset: =>
      @image.attr 'src', @classifier.workflow.selection[0].location
      subject = @classifier.workflow.selection[0]
      @map.attr 'src', "http://maps.googleapis.com/maps/api/staticmap?center=#{subject.coords[0]},#{subject.coords[1]}&zoom=10&size=745x570&maptype=satellite&sensor=false"
      @scale.css width: @classifier.workflow.selection[0].metadata.mm_pix * 100

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

      @classifier.indicator.setStep @strayCircles.length

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

      fauxPoint =
        x: Marker::limit (e.pageX - left) / width, 0.02
        y: Marker::limit (e.pageY - top) / height, 0.04

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

      @classifier.indicator.setStep @strayCircles.length
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
        annotation: marking
        picker: @

    createAxesMarker: =>
      marking = @createMarking()
      marker = new AxesMarker
        annotation: marking
        picker: @

    createMarking: =>
      {width, height} = @getSize()

      points = []
      for circle in @strayCircles
        point =
          x: circle.attr('cx') / width
          y: circle.attr('cy') / height
        points.push point

      annotation = Annotation.create
        classification: @classifier.classification
        value:
          species: @selectedSpecies
          points: points

      @el.trigger 'create-marking'

      annotation

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

  module.exports = CreaturePicker
