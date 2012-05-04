Spine = require 'Spine'

class Point extends Spine.Model
  @configure 'Point', 'x', 'y'

  toJSON: =>
    {@x, @y}

exports = Point
