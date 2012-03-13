Spine = require 'Spine'

Marking = require 'models/Marking'
ClassificationGroundCover = require 'models/ClassificationGroundCover'

class Classification extends Spine.Model
	@configure 'Classification'
	@hasMany 'markings', Marking
	@hasMany 'groundCovers', ClassificationGroundCover

	@extend Spine.Model.Local

Marking.belongsTo 'classification', Classification
ClassificationGroundCover.belongsTo 'classification', Classification

exports = Classification
