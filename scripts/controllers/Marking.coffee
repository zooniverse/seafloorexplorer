define (require) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'
	$ = require 'jQuery'

	style = require 'style'

	class Marking extends Spine.Controller
		picker: null
		circles: null
		lines: null

		active: false
		points: null

		type: '' # "seastar", "fish", "scallop", "squid", "shrimp"

		boundingBox: null
		crossCircle: null

		constructor: ->
			super

			@setupCircleHover()

			@circles.click @onClick
			@circles.drag @circleDrag, @dragStart

			@boundingBox = @picker.paper.path()
			@boundingBox.toBack()
			@boundingBox.attr style.boundingBox

			@hideBoundingBox()

			@crossCircle = @picker.paper.circle()
			@crossCircle.toFront()
			@crossCircle.attr style.crossCircle

			@crossCircle.click @onClick
			@crossCircle.drag @crossDrag, @dragStart, @dragEnd
			@crossCircle.hover @showBoundingBox, @hideBoundingBox

			@redraw()

			@deactivate()

			@release @destroy

			if @type then @setType @type

		setupCircleHover: =>
			marking = @

			over = ->
				marking.overCircle = @
				@attr style.circle_hover

			out = ->
				@attr style.circle

			# These run in the context of the circle!
			@circles.hover over, out

		redraw: =>
			@points = ({x: c.attr('cx'), y: c.attr('cy')} for c in @circles)
			@intersection = @getIntersection()

			@boundingBox.attr path: @getBoundingPathString()
			@lines[0].attr path: @getLineString @circles[0], @circles[1]
			@lines[1].attr path: @getLineString @circles[2], @circles[3]
			@crossCircle.attr cx: @intersection.x, cy: @intersection.y

		getIntersection: =>
			grad1 = (@points[0].y - @points[1].y) / (@points[0].x - @points[1].x)
			grad2 = (@points[2].y - @points[3].y) / (@points[2].x - @points[3].x)

			interX = ((@points[2].y - @points[0].y) + (grad1 * @points[0].x - grad2 * @points[2].x)) / (grad1 - grad2)
			interY = grad1 * (interX - @points[0].x) + @points[0].y

			x: interX, y: interY

		getBoundingPathString: =>
			path = []

			# Not in order!
			path.push 'M', @points[0].x, @points[0].y
			path.push 'L', @points[2].x, @points[2].y
			path.push 'L', @points[1].x, @points[1].y
			path.push 'L', @points[3].x, @points[3].y
			path.push 'z'

			path.join ' '

		getLineString: (c1, c2) =>
			"M #{c1.attr 'cx'} #{c1.attr 'cy'} L #{c2.attr 'cx'} #{c2.attr 'cy'}"

		onClick: (e) =>
			e.stopPropagation()

		activate: =>
			marking.deactivate() for marking in @picker.markings when marking isnt @

			@active = true
			@slideOut()
			@trigger 'activate', @

		deactivate: =>
			@active = false
			@slideIn()
			@trigger 'deactivate'

		slideIn: =>
			@lines.animate Raphael.animation opacity: 0, 200

			toIntersection = Raphael.animation
				cx: @intersection.x
				cy: @intersection.y
				opacity: 0
				200

			@circles.animate toIntersection

		slideOut: =>
			@lines.animate Raphael.animation opacity: 1, 200

			@circles.forEach (circle, i) =>
				circle.animate Raphael.animation cx: @points[i].x, cy: @points[i].y, opacity: 1, 200

		dragStart: =>
			@wasActive = @active
			@activate() unless @wasActive
			@startPoints = (p for p in @points)

		dragEnd: =>
			@deactivate() if @wasActive and not @moved # Click
			delete @wasActive
			delete @startPoints
			delete @moved

		crossDrag: (dx, dy) =>
			@moved = true
			return unless @active
			@circles.forEach (circle, i) =>
				circle.attr cx: @startPoints[i].x + dx
				circle.attr cy: @startPoints[i].y + dy

			@redraw()

		circleDrag: (dx, dy, x, y, e) =>
			i = Array::indexOf.call @circles, @overCircle
			@overCircle.attr(cx: @startPoints[i].x + dx, cy: @startPoints[i].y + dy)
			@redraw()

		showBoundingBox: =>
			@boundingBox.animate Raphael.animation opacity: 1, 400

		hideBoundingBox: =>
			@boundingBox.animate Raphael.animation opacity: 0, 400

		setType: (@type) =>
			@crossCircle.attr style[@type]

		destroy: =>
			@crossCircle.remove()
			@circles.remove()
			@lines.remove()
			@boundingBox.remove()
