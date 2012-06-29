define (require, exports, module) ->
	Spine = require 'Spine'
	Raphael = require 'Raphael'

	Marker = require 'controllers/Marker'
	style = require 'style'

	class CircleMarker extends Marker
		radiusHandle: null
		radiusLine: null
		boundingCircle: null

		constructor: ->
			super

			@radiusHandle = @picker.paper.circle()
			@radiusHandle.toBack()
			@radiusHandle.attr style.circle
			@radiusHandle.click @stopPropagation
			@radiusHandle.drag @radiusHandleDrag, @dragStart

			@radiusLine = @picker.paper.path()
			@radiusLine.toBack()
			@radiusLine.attr style.boundingBox

			@boundingCircle = @picker.paper.circle()
			@boundingCircle.toBack()
			@boundingCircle.attr style.line

			@annotation.trigger 'change'

		render: =>
			super

			{width: w, height: h} = @picker.getSize()

			centerPoint = @annotation.value.points[0]
			@centerCircle.attr
				stroke: style[@annotation.value.species]
				cx: centerPoint.x * w
				cy: centerPoint.y * h

			@label.attr
				x: Math.round centerPoint.x * w
				y: Math.round centerPoint.y * h

			radiusPoint = @annotation.value.points[@annotation.value.points.length - 1]
			@radiusHandle.attr
				cx: radiusPoint.x * w
				cy: radiusPoint.y * h

			@radiusLine.attr
				path: @lineBetween @centerCircle, @radiusHandle

			@boundingCircle.attr
				cx: centerPoint.x * w
				cy: centerPoint.y * h
				r: @getRadius centerPoint, radiusPoint

		radiusHandleDrag: (dx, dy) =>
			@moved = true

			{width: w, height: h} = @picker.getSize()

			radiusPoint = @annotation.value.points[@annotation.value.points.length - 1]
			radiusPoint.x = @limit ((@startPoints[1].x * w) + dx) / w, 0.02
			radiusPoint.y = @limit ((@startPoints[1].y * h) + dy) / h, 0.04

			@annotation.trigger 'change'

		getRadius: (centerPoint, radiusPoint) ->
			{width: w, height: h} = @picker.getSize()
			aSquared = Math.pow (centerPoint.x * w) - (radiusPoint.x * w), 2
			bSquared = Math.pow (centerPoint.y * h) - (radiusPoint.y * h), 2
			Math.sqrt aSquared + bSquared

		select: =>
			super

			{width: w, height: h} = @picker.getSize()

			centerPoint = @annotation.value.points[0]
			radiusPoint = @annotation.value.points[@annotation.value.points.length - 1]
			@radiusHandle.animate
				cx: radiusPoint.x * w
				cy: radiusPoint.y * h
				250

			@radiusLine.animate
				opacity: 1
				250

			@boundingCircle.animate
				r: @getRadius centerPoint, radiusPoint
				opacity: 1
				250

		deselect: =>
			super

			{width: w, height: h} = @picker.getSize()

			centerPoint = @annotation.value.points[0]
			@radiusHandle.animate
				cx: centerPoint.x * w
				cy: centerPoint.y * h
				250

			@radiusLine.animate
				opacity: 0
				125

			@boundingCircle.animate
				r: 0
				opacity: 0
				250

		destroy: =>
			super
			@radiusHandle.remove()
			@radiusLine.remove()
			@boundingCircle.remove()

	module.exports = CircleMarker
