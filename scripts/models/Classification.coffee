Spine = require 'Spine'

Marking = require 'models/Marking'

class Classification extends Spine.Model
	@configure 'Classification', 'groundCover'
	@hasMany 'markings', Marking

	@extend Spine.Model.Local

Marking.belongsTo 'classification', Classification

exports = Classification
