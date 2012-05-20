define (require, exports, module) ->
  Spine = require 'Spine'

  Point = require 'models/Point'

  class Marking extends Spine.Model
    @configure 'Marking', 'species', 'halfIn' # TODO
    @hasMany 'points', Point

    toJSON: =>
      species: @species
      points: (point.toJSON() for point in @points().all())
      halfIn: @halfIn

  Point.belongsTo 'marking', Marking

  module.exports = Marking
