Spine = require 'Spine'

Point = require 'models/Point'

class Marking extends Spine.Model
	@configure 'Marking', 'species'
	@hasMany 'points', Point

	@extend Spine.Model.Local

Point.belongsTo 'marking', Marking

exports = Marking
