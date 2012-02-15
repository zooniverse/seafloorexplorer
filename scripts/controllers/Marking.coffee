define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	style = require 'style'

	class Marking extends Spine.Controller
		model: null
		picker: null

		circles: null
		lines: null

		intersection: null
		crossCircle: null
		boundingBox: null

		active: false

		constructor: ->
			super

			@circles = @picker.paper.set(@picker.paper.circle() for p in @model.points)
			@circles.toFront()
			@circles.attr style.circle

			@setupCircleHover()
			@circles.drag @circleDrag, @dragStart
			@circles.click @onClick

			@lines = @picker.paper.set(@picker.paper.path() for p in @model.points)
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

			@model.bind 'change', @render
			@model.bind 'destroy', @release

			@render()

		setupCircleHover: =>
			marking = @

			over = ->
				marking.overCircle = @
				@attr style.circle_hover

			out = ->
				@attr style.circle

			# These run in the context of the circle!
			@circles.hover over, out

		render: =>
			intersection = @getIntersection()
			@crossCircle.attr cx: intersection.x, cy: intersection.y
			@crossCircle.attr style[@model.species]

			for circle, i in @circles
				circle.attr cx: @model.points[i].x, cy: @model.points[i].y

			for line, i in @lines
				line.attr path: @getLineString @circles[i], @crossCircle

			@boundingBox.attr path: @getBoundingPathString()

		getIntersection: =>
			if @model.species is 'seastar'
				totalX = 0
				totalX = 0 + totalX + point.x for point in @model.points
				averageX = totalX / @model.points.length

				totalY = 0
				totalY = 0 + totalY + point.y for point in @model.points
				averageY = totalY / @model.points.length

				x: averageX, y: averageY
			else
				grad1 = (@model.points[0].y - @model.points[1].y) / (@model.points[0].x - @model.points[1].x)
				grad2 = (@model.points[2].y - @model.points[3].y) / (@model.points[2].x - @model.points[3].x)

				interX = ((@model.points[2].y - @model.points[0].y) + (grad1 * @model.points[0].x - grad2 * @model.points[2].x)) / (grad1 - grad2)
				interY = grad1 * (interX - @model.points[0].x) + @model.points[0].y

				x: interX, y: interY

		getBoundingPathString: =>
			path = []
			path.push 'M', @model.points[0].x, @model.points[0].y

			# Draw a line to the even points, then the odd points.
			# This draws a nice star around five consecutive points
			# and a box around crossed points.
			for point in @model.points by 2 then path.push 'L', point.x, point.y
			for point in @model.points[1..] by 2 then path.push 'L', point.x, point.y

			path.push 'z'
			path.join ' '

		getLineString: (c1, c2) =>
			"M #{c1.attr 'cx'} #{c1.attr 'cy'} L #{c2.attr 'cx'} #{c2.attr 'cy'}"

		onClick: (e) =>
			# Keep clicks from reaching the picker and creating stray circles.
			e.stopPropagation()

		activate: =>
			marking.deactivate() for marking in @picker.markings when marking isnt @

			@active = true

			@lines.animate Raphael.animation opacity: 1, 200

			for circle, i in @circles
				circle.animate Raphael.animation
					cx: @model.points[i].x
					cy: @model.points[i].y
					opacity: 1
					200

			@model.trigger 'change'

		deactivate: =>
			@active = false

			@lines.animate Raphael.animation opacity: 0, 200

			toIntersection = Raphael.animation
				cx: @crossCircle.attr 'cx'
				cy: @crossCircle.attr 'cy'
				opacity: 0
				200

			@circles.animate toIntersection

			@model.trigger 'change'

		dragStart: =>
			@wasActive = @active
			@activate() unless @wasActive
			@startPoints = ({x: point.x, y: point.y} for point in @model.points)

		dragEnd: =>
			@deactivate() if @wasActive and not @moved # Click
			delete @wasActive
			delete @startPoints
			delete @moved

		crossDrag: (dx, dy) =>
			@moved = true

			for point, i in @model.points
				point.x = @startPoints[i].x + dx
				point.y = @startPoints[i].y + dy
			@model.trigger 'change'

		circleDrag: (dx, dy, x, y, e) =>
			i = Array::indexOf.call @circles, @overCircle
			@model.points[i].x = @startPoints[i].x + dx
			@model.points[i].y = @startPoints[i].y + dy
			@model.trigger 'change'

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

			index = i for marking, i in @picker.markings when marking is @
			@picker.markings.splice index, 1

			@model.unbind 'change'
