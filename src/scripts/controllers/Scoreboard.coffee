define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'
  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  Classification = require 'zooniverse/models/Classification'

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

      User.bind 'sign-in', @update
      Classification.bind 'persist', @update
      delay @update

    update: =>
      return if @forUser and not User.current?

      url = "http://#{config.cartoUser}.cartodb.com/api/v2/sql?callback=?"

      query = 'SELECT ' +
        'SUM(ALL(scallops)) AS scallops, ' +
        'SUM(ALL(fish)) AS fish, ' +
        'SUM(ALL(seastars)) AS seastars, ' +
        'SUM(ALL(crustaceans)) AS crustaceans, ' +
        'COUNT(ALL(created_at)) AS classifications ' +
        "FROM #{config.cartoTable}"

      if @forUser and User.current?
        query += " where user_id='#{User.current.id}'"

      $.getJSON url, q: query, (response) =>
        @render response.rows[0]

    render: ({scallops, fish, seastars, crustaceans, classifications}) =>
      @scallopCount.html scallops || 0
      @fishCount.html fish || 0
      @seastarCount.html seastars || 0
      @crustaceanCount.html crustaceans || 0
      @classificationCount.html classifications || 0

  module.exports = Scoreboard
