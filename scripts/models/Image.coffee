define (require) ->
	Spine = require 'Spine'

	class Image extends Spine.model
		@configure 'Image', 'src', 'latitude', 'longitude'
