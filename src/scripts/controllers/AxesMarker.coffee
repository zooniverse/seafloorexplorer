define (require, exports, module) ->
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

			points = @annotation.value.points

			@circles = @picker.paper.set(@picker.paper.circle() for p in points)
			@circles.toBack()
			@circles.attr style.circle

			@setupCircleHover()
			@circles.drag @circleDrag, @dragStart

			@lines = @picker.paper.set(@picker.paper.path() for p in points)
			@lines.toBack()
			@lines.attr style.boundingBox

			@annotation.trigger 'change'

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

			{width: w, height: h} = @picker.getSize()

			intersection = @getIntersection()
			@centerCircle.attr
				cx: intersection.x * w
				cy: intersection.y * h

			@centerCircle.attr stroke: style[@annotation.value.species]

			@label.attr
				x: intersection.x * w
				y: intersection.y * h

			points = @annotation.value.points
			for circle, i in @circles
				circle.attr
					cx: points[i].x * w
					cy: points[i].y * h

			for line, i in @lines
				line.attr path: @lineBetween @circles[i], @centerCircle

		getIntersection: =>
			points = @annotation.value.points

			grads = [
				(points[0].y - points[1].y) / ((points[0].x - points[1].x) || 0.00001)
				(points[2].y - points[3].y) / ((points[2].x - points[3].x) || 0.00001)
			]

			interX = ((points[2].y - points[0].y) + (grads[0] * points[0].x - grads[1] * points[2].x)) / (grads[0] - grads[1])
			interY = grads[0] * (interX - points[0].x) + points[0].y

			x: interX, y: interY

		getBoundingPathString: =>
			{width: w, height: h} = @picker.getSize()

			points = @annotation.value.points
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

			{width: w, height: h} = @picker.getSize()

			points = @annotation.value.points
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

			points = @annotation.value.points
			{width: w, height: h} = @picker.getSize()

			i = indexOf @circles, @overCircle
			points[i].x = @limit ((@startPoints[i].x * w) + dx) / w, 0.02
			points[i].y = @limit ((@startPoints[i].y * h) + dy) / h, 0.04

			@annotation.trigger 'change'

		destroy: =>
			super
			@circles.remove()
			@lines.remove()

	module.exports = AxesMarker
