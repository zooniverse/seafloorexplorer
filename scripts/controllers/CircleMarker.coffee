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
		super

		{width: w, height: h} = @paperSize()

		centerPoint = @marking.points().first()
		@centerCircle.attr
			stroke: style[@marking.species]
			cx: centerPoint.x * w
			cy: centerPoint.y * h

		@label.attr
			x: centerPoint.x * w
			y: centerPoint.y * h

		radiusPoint = @marking.points().last()
		@radiusHandle.attr
			cx: radiusPoint.x * w
			cy: radiusPoint.y * h

		@radiusLine.attr
			path: @lineBetween @centerCircle, @radiusHandle

		@boundingCircle.attr
			cx: centerPoint.x * w
			cy: centerPoint.y * h
			r: do ->
				aSquared = Math.pow (centerPoint.x * w) - (radiusPoint.x * w), 2
				bSquared = Math.pow (centerPoint.y * h) - (radiusPoint.y * h), 2
				Math.sqrt aSquared + bSquared

	centerCircleDrag: (dx, dy) =>
		@moved = true

		{width: w, height: h} = @paperSize()

		for point, i in @marking.points().all()
			point.updateAttributes
				x: ((@startPoints[i].x * w) + dx) / w
				y: ((@startPoints[i].y * h) + dy) / h

		@marking.trigger 'change'

	radiusHandleDrag: (dx, dy) =>
		@moved = true

		{width: w, height: h} = @paperSize()

		@marking.points().last().updateAttributes
			x: ((@startPoints[1].x * w) + dx) / w
			y: ((@startPoints[1].y * h) + dy) / h

		@marking.trigger 'change'

	select: =>
		super

		{width: w, height: h} = @paperSize()

		radiusPoint = @marking.points().last()
		@radiusHandle.animate
			cx: radiusPoint.x * w
			cy: radiusPoint.y * h
			250

		@radiusLine.animate
			opacity: 1
			250

		@boundingCircle.animate
			opacity: 1
			250

	deselect: =>
		super

		{width: w, height: h} = @paperSize()

		centerPoint = @marking.points().first()
		@radiusHandle.animate
			cx: centerPoint.x * w
			cy: centerPoint.y * h
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
