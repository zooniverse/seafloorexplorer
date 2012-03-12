Spine = require 'Spine'
Raphael = require 'Raphael'

Marker = require 'controllers/Marker'
style = require 'style'

class CircleMarker extends Marker
	centerCircle: null
	radiusHandle: null
	radiusLine: null
	boundingCircle: null

	constructor: ->
		super

		@centerCircle = @paper.circle()
		@centerCircle.attr style.crossCircle
		@centerCircle.click @stopPropagation
		@centerCircle.drag @centerCircleDrag, @dragStart, @dragEnd

		@radiusHandle = @paper.circle()
		@radiusHandle.toBack()
		@radiusHandle.attr style.circle
		@radiusHandle.click @stopPropagation
		@radiusHandle.drag @radiusHandleDrag, @dragStart

		@radiusLine = @paper.path()
		@radiusLine.toBack()
		@radiusLine.attr style.boundingBox

		@boundingCircle = @paper.circle()
		@boundingCircle.toBack()
		@boundingCircle.attr style.boundingBox

		@marking.trigger 'change'

	render: =>
		centerPoint = @marking.points().first()
		@centerCircle.attr
			cx: centerPoint.x
			cy: centerPoint.y

		radiusPoint = @marking.points().last()
		@radiusHandle.attr
			cx: radiusPoint.x
			cy: radiusPoint.y

		@radiusLine.attr
			path: @lineBetween centerPoint, radiusPoint

		@boundingCircle.attr
			cx: centerPoint.x
			cy: centerPoint.y
			r: do ->
				aSquared = Math.pow centerPoint.x - radiusPoint.x, 2
				bSquared = Math.pow centerPoint.y - radiusPoint.y, 2
				Math.sqrt aSquared + bSquared

	centerCircleDrag: (dx, dy) =>
		@moved = true

		for point, i in @marking.points().all()
			point.updateAttribute 'x', @startPoints[i].x + dx
			point.updateAttribute 'y', @startPoints[i].y + dy

		@marking.trigger 'change'

	radiusHandleDrag: (dx, dy) =>
		@moved = true

		point = @marking.points().last()
		point.updateAttributes
			x: @startPoints[1].x + dx
			y: @startPoints[1].y + dy

		@marking.trigger 'change'

	select: =>
		super

		radiusPoint = @marking.points().last()
		@radiusHandle.animate
			cx: radiusPoint.x
			cy: radiusPoint.y
			250

		@radiusLine.animate
			opacity: 1
			250

		@boundingCircle.animate
			opacity: 1
			250

	deselect: =>
		super

		centerPoint = @marking.points().first()
		@radiusHandle.animate
			cx: centerPoint.x
			cy: centerPoint.y
			250

		@radiusLine.animate
			opacity: 0
			125

		@boundingCircle.animate
			opacity: 0
			250

	destroy: =>
		super
		@centerCircle.remove()
		@radiusHandle.remove()
		@radiusLine.remove()
		@boundingCircle.remove()

exports = CircleMarker
