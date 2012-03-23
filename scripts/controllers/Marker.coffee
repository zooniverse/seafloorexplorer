Spine = require 'Spine'
Raphael = require 'Raphael'
$ = require 'jQuery'

{delay} = require 'util'

class Marker extends Spine.Controller
	marking: null
	paper: null

	selected: false

	constructor: ->
		super

		@marking.bind 'change', @render
		@marking.bind 'destroy', @release

		@release @destroy

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
		# Remove all shapes

exports = Marker
