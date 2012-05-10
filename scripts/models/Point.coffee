Spine = require 'Spine'

class Point extends Spine.Model
  @configure 'Point', 'x', 'y'

  setX: (value) =>
    if 0 < value < 0.02 then value = 0
    if 1 > value > 0.98 then value = 1
    @x = value

  setY: (value) =>
    if 0 < value < 0.04 then value = 0
    if 1 > value > 0.96 then value = 1
    @y = value

  toJSON: =>
    {@x, @y}

exports = Point
