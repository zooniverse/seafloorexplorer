define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'

	style = require 'style'

	class Marking extends Spine.Controller
		circles: null
		lines: null

		active: false
		points: null

		crossCircle: null
		boundingBox: null

		crossCircleRadius: 10

		constructor: ->
			super

			@circles.attr style.circle
			@points = for c in @circles then {x: c.attr('cx'), y: c.attr('cy')}

			@boundingBox = @paper.path @getBoundingPathString()
			@boundingBox.attr style.boundingBox

			intersection = @getIntersection()

			@crossCircle = @paper.circle intersection.x, intersection.y, @crossCircleRadius
			@crossCircle.attr style.crossCircle

			@crossCircle.click @crossClicked

			@slideIn()

		getBoundingPathString: =>
			path = []

			path.push 'M', @points[0].x, @points[0].y
			path.push 'L', @points[2].x, @points[2].y
			path.push 'L', @points[1].x, @points[1].y
			path.push 'L', @points[3].x, @points[3].y
			path.push 'z'

			path.join ' '

		getIntersection: =>
			grad1 = (@points[0].y - @points[1].y) / (@points[0].x - @points[1].x)
			grad2 = (@points[2].y - @points[3].y) / (@points[2].x - @points[3].x)

			interX = ((@points[2].y - @points[0].y) + (grad1 * @points[0].x - grad2 * @points[2].x)) / (grad1 - grad2)
			interY = grad1 * (interX - @points[0].x) + @points[0].y

			x: interX, y: interY

		crossClicked: (e) =>
			e.stopPropagation()
			if @active then @deactivate() else @activate()

		activate: =>
			@active = true
			@slideOut()

		deactivate: =>
			@active = false
			@slideIn()

		slideIn: =>
			@lines.animate Raphael.animation opacity: 0, 200

			toIntersection = Raphael.animation
				cx: @crossCircle.attr 'cx'
				cy: @crossCircle.attr 'cy'
				opacity: 0
				200

			@circles.animate toIntersection

		slideOut: =>
			@lines.animate Raphael.animation opacity: 1, 200

			@circles.forEach (circle, i) =>
				circle.animate Raphael.animation cx: @points[i].x, cy: @points[i].y, opacity: 1, 200
