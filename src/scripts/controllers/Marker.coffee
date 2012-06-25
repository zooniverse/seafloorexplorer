define (require, exports, module) ->
  Spine = require 'Spine'
  Raphael = require 'Raphael'
  $ = require 'jQuery'

  Dialog = require 'zooniverse/controllers/Dialog'

  style = require 'style'
  {delay} = require 'util'

  class Marker extends Spine.Controller
    annotation: null
    picker: null

    label: null
    labelText: null
    deleteButton: null
    labelRect: null

    centerPoint: null

    selected: false

    constructor: ->
      super

      @drawLabel()
      @hideLabel()

      @centerCircle = @picker.paper.circle()
      @centerCircle.attr style.crossCircle
      @centerCircle.hover @showLabel, @hideLabel
      @centerCircle.click @stopPropagation
      @centerCircle.drag @centerCircleDrag, @dragStart, @dragEnd

      @annotation.bind 'change', @render
      @annotation.bind 'destroy', @destroy

      delay @checkForHalf

    checkForHalf: =>
      # Should we ask if the creature is more than half-in?
      for point in @annotation.value.points
        snappedToEdge = true if point.x <= 0 or point.x >= 1
        snappedToEdge = true if point.y <= 0 or point.y >= 1

      @askIfHalfVisible() if snappedToEdge

    askIfHalfVisible: =>
      dialog = new Dialog
        content: "Is at least half of that #{@annotation.value.species} visible in the image?"
        buttons: [{'Yes': true}, {'No': false}]
        target: @picker.classifier.el.parent()
        className: 'classifier'
        done: (halfInValue) =>
          @annotation.value.halfIn = halfInValue

    drawLabel: (text) =>
      @labelText = @picker.paper.text()
      @labelText.attr style.label.text
      @labelText.transform 'T20,0'

      labelHeight = (style.crossCircle.r * 2) + style.crossCircle['stroke-width']

      @deleteButton = @picker.paper.rect 0, 0, labelHeight, labelHeight
      @deleteButton.attr style.label.deleteButton
      @deleteButton.click @onClickDelete

      @deleteText = @picker.paper.text 0, 0, '\u00D7' # Multiplication sign
      @deleteText.attr style.label.deleteButton.text
      @deleteText.click @onClickDelete

      @labelRect = @picker.paper.rect 0, 0, 0, labelHeight
      @labelRect.toBack()
      @labelRect.attr style.label.rect
      @labelRect.transform "T0,#{-labelHeight / 2}"

      @label = @picker.paper.set @labelText, @labelRect, @deleteButton, @deleteText

      @label.hover @showLabel, @hideLabel

    showLabel: =>
      @dontHide = true
      @label.show()
      @label.animate opacity: 1, 100

    hideLabel: =>
      delete @dontHide
      delay 500, =>
        unless @dontHide then @label.animate opacity: 0, 100, => @label.hide()

    onClickDelete: =>
      @annotation.destroy()

    render: =>
      return if @annotation.destroyed or @centerCircle.removed
      @labelText.attr text: @annotation.value.species.toUpperCase()
      textBox = @labelText.getBBox()
      @labelRect.attr width: 20 + Math.round(textBox.width) + 10
      @deleteButton.transform "T#{@labelRect.attr('width') - 1},#{-style.crossCircle.r - (style.crossCircle['stroke-width'] / 2)}"
      @deleteText.transform "T#{@labelRect.attr('width') + 3},-1}"
      @labelRect.attr fill: style[@annotation.value.species]
      @deleteButton.attr fill: style[@annotation.value.species]

    select: =>
      @selected = true
      @trigger 'select', @

    deselect: =>
      @selected = false
      @trigger 'deselect', @

    dragStart: =>
      return unless $(@centerCircle.node).closest(':disabled, .disabled').length is 0

      @startPoints = ({x: point.x, y: point.y} for point in @annotation.value.points)
      @wasSelected = @selected
      @select() unless @wasSelected

    centerCircleDrag: (dx, dy) =>
      return unless @startPoints?
      @moved = true

      {width: w, height: h} = @picker.getSize()

      for point, i in @annotation.value.points
        point.x = ((@startPoints[i].x * w) + dx) / w
        point.y = ((@startPoints[i].y * h) + dy) / h

      @annotation.trigger 'change'

    dragEnd: =>
      @deselect() if @wasSelected and not @moved # Basically, a click
      @checkForHalf() if @moved

      delete @startPoints
      delete @wasSelected
      delete @moved

    stopPropagation: (e) =>
      e.stopPropagation()

    lineBetween: (point1, point2) =>
      unless 'x' of point1 and 'y' of point1
        point1 =
          x: point1.attr 'cx'
          y: point1.attr 'cy'

      unless 'x' of point2 and 'y' of point2
        point2 =
          x: point2.attr 'cx'
          y: point2.attr 'cy'

      "M #{point1.x} #{point1.y} L #{point2.x} #{point2.y}"

    destroy: =>
      @centerCircle.remove()
      @label.remove()

    limit: (value, threshold) ->
      if 0 - threshold < value < 0 + threshold then value = 0
      if 1 - threshold < value < 1 + threshold then value = 1
      value

  module.exports = Marker
