define (require, exports, module) ->
  Spine = require 'Spine'

  Subject = require 'models/Subject'
  Marking = require 'models/Marking'
  ClassificationGroundCover = require 'models/ClassificationGroundCover'

  class Classification extends Spine.Model
    @configure 'Classification', 'other'
    @hasMany 'markings', Marking
    @hasMany 'groundCovers', ClassificationGroundCover

    toJSON: =>
      classification:
        subject_ids: [Subject.current.id]
        other_creatures: !!@other
        ground_covers: (groundCover.toJSON() for groundCover in @groundCovers().all())
        annotations: (marking.toJSON() for marking in @markings().all())

    persist: =>
      @trigger 'persisting'
      savePoint = "#{Subject.server}/projects/#{Subject.projectId}/workflows/#{Subject.workflowId}/classifications"
      $.post savePoint, @toJSON(), => @trigger 'persist'

  Marking.belongsTo 'classification', Classification
  ClassificationGroundCover.belongsTo 'classification', Classification

  module.exports = Classification
