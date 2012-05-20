define (require, exports, module) ->
  Spine = require 'Spine'

  # NOTE:
  # This model belongs to both Classification and GroundCover.
  # This is possibly a bad idea.

  class ClassificationGroundCover extends Spine.Model
    @configure 'ClassificationGroundCover'

    toJSON: =>
      @groundCover().description

  module.exports = ClassificationGroundCover
