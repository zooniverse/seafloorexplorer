define (require, exports, module) ->
  ZooniverseClassification = require 'zooniverse/models/Classification'

  Subject = require 'models/Subject'
  Marking = require 'models/Marking'

  class Classification extends ZooniverseClassification
    @configure 'Classification', 'groundCovers', 'otherSpecies'
    @hasMany 'markings', Marking

    constructor: ->
      super
      @groundCovers ?= []
      @otherSpecies ?= false

    toJSON: =>
      classification:
        subject_ids: [Subject.current.id]
        ground_covers: @groundCovers
        annotations: (marking.toJSON() for marking in @markings().all())
        other_species: !!@otherSpecies

  Marking.belongsTo 'classification', Classification

  module.exports = Classification
