define (require, exports, module) ->
  ZooniverseClassification = require 'zooniverse/models/Classification'

  Marking = require 'models/Marking'
  Subject = require 'models/Subject'
  User = require 'zooniverse/models/User'
  Project = require 'zooniverse/models/Project'

  class Classification extends ZooniverseClassification
    @configure 'Classification', 'groundCovers', 'otherSpecies'
    @hasMany 'markings', Marking

    constructor: ->
      super
      @groundCovers ?= []

    toJSON: =>
      classification:
        subject_ids: [Subject.current.id]
        ground_covers: @groundCovers
        annotations: (marking.toJSON() for marking in @markings().all())
        other_species: !!@otherSpecies

    persist: =>
      super

      unless Subject.current.zooniverseId is 'TUTORIAL_SUBJECT'
        query = "INSERT INTO #{Project.current.cartoTable} (" +
          'the_geom, user_id, scallops, fish, seastars, crustaceans) ' +
          'VALUES (' +
          "ST_SetSRID(ST_Point(#{Subject.current.latitude}, #{Subject.current.longitude}), 4326), " +
          "'#{User.current?.id || ''}', " +
          "#{(marking for marking in @markings().all() when marking.species is 'scallop').length}, " +
          "#{(marking for marking in @markings().all() when marking.species is 'fish').length}, " +
          "#{(marking for marking in @markings().all() when marking.species is 'seastar').length}, " +
          "#{(marking for marking in @markings().all() when marking.species is 'crustacean').length}" +
          ')'

        $.post "http://#{Project.current.cartoUser}.cartodb.com/api/v2/sql",
          q: query
          api_key: Project.current.cartoApiKey

  Marking.belongsTo 'classification', Classification

  module.exports = Classification
