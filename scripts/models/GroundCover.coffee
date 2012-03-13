Spine = require 'Spine'

ClassificationGroundCover = require 'models/ClassificationGroundCover'

class GroundCover extends Spine.Model
	@configure 'GroundCover', 'description'
	@hasMany 'classifications', ClassificationGroundCover

	@extend Spine.Model.Local

ClassificationGroundCover.belongsTo 'groundCover', GroundCover, 'ground_cover_id'

exports = GroundCover
