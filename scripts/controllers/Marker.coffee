Spine = require 'Spine'
Raphael = require 'Raphael'
$ = require 'jQuery'

style = require 'style'
{delay} = require 'util'

class Marker extends Spine.Controller
	marking: null
	paper: null
	@label: null
	@labelText: null
	@deleteButton: null
	@labelRect: null

	@centerPoint: null

	selected: false

	constructor: ->
		super

		@drawLabel()
		@hideLabel()

		@centerCircle = @paper.circle()
		@centerCircle.attr style.crossCircle
		@centerCircle.hover @showLabel, @hideLabel
		@centerCircle.click @stopPropagation
		@centerCircle.drag @centerCircleDrag, @dragStart, @dragEnd

		@marking.bind 'change', @render
		@marking.bind 'destroy', @release

		@release @destroy

	drawLabel: (text) =>
		@labelText = @paper.text()
		@labelText.attr style.label.text
		@labelText.transform 'T20,0'

		labelHeight = (style.crossCircle.r * 2) + style.crossCircle['stroke-width']

		@deleteButton = @paper.rect 0, 0, labelHeight, labelHeight
		@deleteButton.attr style.label.deleteButton
		@deleteButton.click @onClickDelete

		@deleteText = @paper.text 0, 0, '\u00D7' # Multiplication sign
		@deleteText.attr style.label.deleteButton.text
		@deleteText.click @onClickDelete

		@labelRect = @paper.rect 0, 0, 0, labelHeight
		@labelRect.toBack()
		@labelRect.attr style.label.rect
		@labelRect.transform "T0,#{-labelHeight / 2}"

		@label = @paper.set @labelText, @labelRect, @deleteButton, @deleteText

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
		@marking.destroy()

	render: =>
		@labelText.attr text: @marking.species.toUpperCase()
		textBox = @labelText.getBBox()
		@labelRect.attr width: 20 + textBox.width + 10
		@deleteButton.transform "T#{@labelRect.attr 'width'},#{-style.crossCircle.r - (style.crossCircle['stroke-width'] / 2)}"
		@deleteText.transform "T#{@labelRect.attr('width') + 5},0}"
		@labelRect.attr fill: style[@marking.species]
		@deleteButton.attr fill: style[@marking.species]

	select: =>
		@selected = true
		@trigger 'select', @

	deselect: =>
		@selected = false
		@trigger 'deselect', @

	dragStart: =>
		@startPoints = ({x: point.x, y: point.y} for point in @marking.points().all())
		@wasSelected = @selected
		@select() unless @wasSelected

	centerCircleDrag: =>
		# Override

	dragEnd: =>
		@deselect() if @wasSelected and not @moved # Basically, a click
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

	paperSize: =>
		parent = $(@paper.canvas.parentNode)
		width: parent.width(), height: parent.height()

	destroy: =>
		@marking.unbind 'change'
		@centerCircle.remove()
		@label.remove()

exports = Marker
