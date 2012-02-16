define (require) ->
	Spine = require 'Spine'

	class Point extends Spine.Model
		@configure 'Point', 'x', 'y'
		@belongsTo 'marking', Marking

	class Marking extends Spine.Model
		@configure 'Marking', 'species'
		@hasMany 'points', Point
		@belongsTo 'classification', Classification

	class Classification extends Spine.Model
		@configure 'Classification', 'groundCover'
		@hasMany 'markings', Marking
		@belongsTo 'subject', Subject

	class Subject extends Spine.Model
		@configure 'Subject', 'image', 'latitude', 'longitude', 'depth'
		@hasMany 'classifications', Classification
