define (require) ->
	Spine = require 'Spine'

	class Marking extends Spine.Model
		@configure 'Marking', 'points', 'species'
		@belongsTo 'subject', Subject

	class Subject extends Spine.Model
		@configure 'Subject', 'src', 'latitude', 'longitude', 'depth', 'groundCover', 'species'
		@hasMany 'markings', Marking

		constructor: ->
			super
			@markings().model.bind 'create change destroy', (marking) =>
				if @markings().associated marking then @trigger 'change'
