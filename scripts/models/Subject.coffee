Spine = require 'Spine'

class Point extends Spine.Model
	@configure 'Point', 'x', 'y'
	@belongsTo 'marking', Marking

	@extend Spine.Model.Local

class Marking extends Spine.Model
	@configure 'Marking', 'species'
	@hasMany 'points', Point
	@belongsTo 'classification', Classification

	@extend Spine.Model.Local

class Classification extends Spine.Model
	@configure 'Classification', 'groundCover'
	@hasMany 'markings', Marking
	@belongsTo 'subject', Subject

	@extend Spine.Model.Local

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'latitude', 'longitude', 'depth'
	@hasMany 'classifications', Classification

	@next: ->
		noClassifications = @select (subject) ->
			subject.classifications().all().length is 0

		noClassifications[0]

exports = Subject
