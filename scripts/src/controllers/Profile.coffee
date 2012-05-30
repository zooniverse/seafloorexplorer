define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  ZooniverseProfile = require 'zooniverse/controllers/Profile'

  Map = require 'zooniverse/controllers/Map'
  Scoreboard = require 'controllers/Scoreboard'

  TEMPLATE = require 'views/Profile'
  favoriteTemplate = require 'views/ProfileFavorite'

  class Profile extends ZooniverseProfile
    template: TEMPLATE

    map: null
    scoreboard: null

    elements: $.extend
      '.summary .username': 'usernameContainer'
      '.summary .map': 'mapContainer'
      '.summary .scoreboard': 'scoreboardContainer'
      ZooniverseProfile::elements

    constructor: ->
      super

      @map = new Map
        el: @mapContainer

      @scoreboard = new Scoreboard
        el: @scoreboardContainer
        forUser: true

    userChanged: =>
      super

      if User.current?
        @usernameContainer.html User.current.name
        @scoreboard.update()

    favoriteTemplate: favoriteTemplate

  module.exports = Profile
