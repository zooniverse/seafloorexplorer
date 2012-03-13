Spine = require 'Spine'

# NOTE:
# This model belongs to both Classification and GroundCover.
# This is possibly a bad idea.

class ClassificationGroundCover extends Spine.Model
	@configure 'ClassificationGroundCover'
	@extend Spine.Model.Local

exports = ClassificationGroundCover
