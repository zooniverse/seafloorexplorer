define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	style = require 'style'

	class Marker extends Spine.Controller
		marking: null
		picker: null

		circles: null
		lines: null
		crossCircle: null
		boundingBox: null

		active: false

		constructor: ->
			super
			points = @marking.points().all()

			@circles = @picker.paper.set(@picker.paper.circle() for p in points)
			@circles.toFront()
			@circles.attr style.circle

			@setupCircleHover()
			@circles.drag @circleDrag, @dragStart
			@circles.click @onClick

			@lines = @picker.paper.set(@picker.paper.path() for p in points)
			@lines.toBack()
			@lines.attr style.line

			@crossCircle = @picker.paper.circle()
			@crossCircle.toFront()
			@crossCircle.attr style.crossCircle

			@crossCircle.hover @showBoundingBox, @hideBoundingBox
			@crossCircle.drag @crossDrag, @dragStart, @dragEnd
			@crossCircle.click @onClick

			@boundingBox = @picker.paper.path()
			@boundingBox.toBack()
			@boundingBox.attr style.boundingBox
			@hideBoundingBox()

			@release @destroy

			@marking.bind 'change', @render
			@marking.bind 'destroy', @release

			@marking.trigger 'change'

		setupCircleHover: =>
			marker = @

			over = ->
				marker.overCircle = @
				@attr style.circle_hover

			out = ->
				@attr style.circle

			# These run in the context of the circle!
			@circles.hover over, out

		render: =>
			intersection = @getIntersection()
			@crossCircle.attr cx: intersection.x, cy: intersection.y
			@crossCircle.attr style[@marking.species] or style.crossCircle

			points = @marking.points().all()
			for circle, i in @circles
				circle.attr cx: points[i].x, cy: points[i].y

			for line, i in @lines
				line.attr path: @getLineString @circles[i], @crossCircle

			@boundingBox.attr path: @getBoundingPathString()

		getIntersection: =>
			points = @marking.points().all()

			if @marking.species is 'seastar'
				totalX = 0
				totalX = 0 + totalX + point.x for point in points
				averageX = totalX / points.length

				totalY = 0
				totalY = 0 + totalY + point.y for point in points
				averageY = totalY / points.length

				x: averageX, y: averageY
			else
				grad1 = (points[0].y - points[1].y) / (points[0].x - points[1].x)
				grad2 = (points[2].y - points[3].y) / (points[2].x - points[3].x)

				interX = ((points[2].y - points[0].y) + (grad1 * points[0].x - grad2 * points[2].x)) / (grad1 - grad2)
				interY = grad1 * (interX - points[0].x) + points[0].y

				x: interX, y: interY

		getBoundingPathString: =>
			points = @marking.points().all()
			path = []
			path.push 'M', points[0].x, points[0].y

			# Draw a line to the even points, then the odd points.
			# This draws a nice star around five consecutive points and a box around crossed points.
			for point in points by 2 then path.push 'L', point.x, point.y
			for point in points[1..] by 2 then path.push 'L', point.x, point.y

			path.push 'z'
			path.join ' '

		getLineString: (c1, c2) =>
			"M #{c1.attr 'cx'} #{c1.attr 'cy'} L #{c2.attr 'cx'} #{c2.attr 'cy'}"

		onClick: (e) =>
			# Keep clicks from reaching the picker and creating stray circles.
			e.stopPropagation()

		activate: =>
			marker.deactivate() for marker in @picker.markers when marker isnt @

			@active = true

			@lines.animate Raphael.animation opacity: 1, 200

			points = @marking.points().all()
			for circle, i in @circles
				circle.animate Raphael.animation
					cx: points[i].x
					cy: points[i].y
					opacity: 1
					200

			@marking.trigger 'change'

		deactivate: =>
			@active = false

			@lines.animate Raphael.animation opacity: 0, 200

			toIntersection = Raphael.animation
				cx: @crossCircle.attr 'cx'
				cy: @crossCircle.attr 'cy'
				opacity: 0
				200

			@circles.animate toIntersection

		dragStart: =>
			@wasActive = @active
			@activate() unless @wasActive
			@startPoints = ({x: point.x, y: point.y} for point in @marking.points().all())

		dragEnd: =>
			@deactivate() if @wasActive and not @moved # Click
			delete @wasActive
			delete @startPoints
			delete @moved

		crossDrag: (dx, dy) =>
			@moved = true

			for point, i in @marking.points().all()
				point.updateAttribute 'x', @startPoints[i].x + dx
				point.updateAttribute 'y', @startPoints[i].y + dy

			@marking.trigger 'change'

		circleDrag: (dx, dy, x, y, e) =>
			points = @marking.points().all()

			i = Array::indexOf.call @circles, @overCircle
			points[i].updateAttribute 'x', @startPoints[i].x + dx
			points[i].updateAttribute 'y', @startPoints[i].y + dy

			@marking.trigger 'change'

		showBoundingBox: =>
			@boundingBox.animate Raphael.animation opacity: 1, 400

		hideBoundingBox: =>
			@boundingBox.animate Raphael.animation opacity: 0, 400

		destroy: =>
			@deactivate()

			@crossCircle.remove()
			@circles.remove()
			@lines.remove()
			@boundingBox.remove()

			@marking.unbind 'change'
