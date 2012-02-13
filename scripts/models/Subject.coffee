define (require) ->
	Spine = require 'Spine'

	class Subject extends Spine.Model
		@configure 'Subject', 'src', 'latitude', 'longitude', 'depth', 'groundCover', 'species'
