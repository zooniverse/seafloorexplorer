Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
{indexOf} = require 'util'
style = require 'style'

class AxesMarker extends Marker
	circles: null
	lines: null

	constructor: ->
		super

		points = @marking.points().all()

		@circles = @paper.set(@paper.circle() for p in points)
		@circles.toBack()
		@circles.attr style.circle

		@setupCircleHover()
		@circles.drag @circleDrag, @dragStart

		@lines = @paper.set(@paper.path() for p in points)
		@lines.toBack()
		@lines.attr style.boundingBox

		@marking.trigger 'change'

	setupCircleHover: =>
		marker = @

		over = ->
			marker.overCircle = @
			@attr style.circle.hover

		out = ->
			@attr style.circle

		# These run in the context of the circle!
		@circles.hover over, out

	render: =>
		super

		{width: w, height: h} = @paperSize()

		intersection = @getIntersection()
		@centerCircle.attr
			cx: intersection.x * w
			cy: intersection.y * h

		@centerCircle.attr stroke: style[@marking.species]

		@label.attr
			x: intersection.x * w
			y: intersection.y * h

		points = @marking.points().all()
		for circle, i in @circles
			circle.attr
				cx: points[i].x * w
				cy: points[i].y * h

		for line, i in @lines
			line.attr path: @lineBetween @circles[i], @centerCircle

	getIntersection: =>
		points = @marking.points().all()

		grads = [
			(points[0].y - points[1].y) / (points[0].x - points[1].x)
			(points[2].y - points[3].y) / (points[2].x - points[3].x)
		]

		# Check for divide-by-zero errors.
		for grad, i in grads
			if isNaN(grad) or grad is Infinity or grad is -Infinity then grads[i] = 0.001

		interX = ((points[2].y - points[0].y) + (grads[0] * points[0].x - grads[1] * points[2].x)) / (grads[0] - grads[1])
		interY = grads[0] * (interX - points[0].x) + points[0].y

		x: interX, y: interY

	getBoundingPathString: =>
		{width: w, height: h} = @paperSize()

		points = @marking.points().all()
		path = []
		path.push 'M', points[0].x * w, points[0].y * h

		# Draw a line to the even points, then the odd points.
		# This draws a nice star around five consecutive points and a box around crossed points.
		for point in points by 2 then path.push 'L', point.x * w, point.y * h
		for point in points[1..] by 2 then path.push 'L', point.x * w, point.y * h

		path.push 'z'
		path.join ' '

	select: =>
		super

		{width: w, height: h} = @paperSize()

		points = @marking.points().all()
		for circle, i in @circles
			circle.animate
				cx: points[i].x * w
				cy: points[i].y * h
				opacity: 1
				200

		@lines.animate opacity: 1, 333

	deselect: =>
		super

		@circles.animate
			cx: @centerCircle.attr 'cx'
			cy: @centerCircle.attr 'cy'
			opacity: 0
			250

		@lines.animate opacity: 0, 125

	circleDrag: (dx, dy) =>
		@moved = true

		points = @marking.points().all()
		{width: w, height: h} = @paperSize()

		i = indexOf @circles, @overCircle
		points[i].updateAttributes
			x: ((@startPoints[i].x * w) + dx) / w
			y: ((@startPoints[i].y * h) + dy) / h

		@marking.trigger 'change'

	destroy: =>
		super
		@centerCircle.remove()
		@circles.remove()
		@lines.remove()

exports = AxesMarker
