Spine = require 'Spine'


class Point extends Spine.Model
	@configure 'Point', 'x', 'y'

	@extend Spine.Model.Local

exports = Point
