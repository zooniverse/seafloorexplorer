define (require) ->
	Spine = require 'Spine'

	class Marking extends Spine.Model
		@configure 'Marking', 'points', 'type'
