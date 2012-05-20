define (require, exports, module) ->
  Spine = require 'Spine'

  ClassificationGroundCover = require 'models/ClassificationGroundCover'

  class GroundCover extends Spine.Model
    @configure 'GroundCover', 'description'
    @hasMany 'classifications', ClassificationGroundCover

    toJSON: =>
      @description

  ClassificationGroundCover.belongsTo 'groundCover', GroundCover, 'ground_cover_id'

  module.exports = GroundCover
