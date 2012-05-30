define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Project = require 'zooniverse/models/Project'
  Classification = require 'models/Classification'

  SCOREBOARD_TEMPLATE = require 'views/Scoreboard'

  class Scoreboard extends Spine.Controller
    forUser: false

    template: SCOREBOARD_TEMPLATE

    elements:
      '.seastar.score .count': 'seastarCount'
      '.fish.score .count': 'fishCount'
      '.scallop.score .count': 'scallopCount'
      '.crustacean.score .count': 'crustaceanCount'
      '.classifications.score .count': 'classificationCount'

    constructor: ->
      super
      @html @template
      @update()

      Classification.bind 'persist', @update

    update: =>
      return if @forUser and not User.current?

      url = "http://#{Project.current.cartoUser}.cartodb.com/api/v2/sql"

      query = 'SELECT ' +
        'SUM(ALL(scallops)) AS scallops, ' +
        'SUM(ALL(fish)) AS fish, ' +
        'SUM(ALL(seastars)) AS seastars, ' +
        'SUM(ALL(crustaceans)) AS crustaceans, ' +
        'COUNT(ALL(created_at)) AS classifications ' +
        "FROM #{Project.current.cartoTable}"

      if @forUser and User.current?
        query += " where user_id='#{User.current.id}'"

      $.getJSON url, q: query, (response) =>
        @render response.rows[0]

    render: ({scallops, fish, seastars, crustaceans, classifications}) =>
      @scallopCount.html scallops
      @fishCount.html fish
      @seastarCount.html seastars
      @crustaceanCount.html crustaceans
      @classificationCount.html classifications

  module.exports = Scoreboard
