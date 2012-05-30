define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Project = require 'zooniverse/models/Project'

  ZooniverseProfile = require 'zooniverse/controllers/Profile'

  Map = require 'zooniverse/controllers/Map'
  Scoreboard = require 'controllers/Scoreboard'

  TEMPLATE = require 'views/Profile'
  favoriteTemplate = require 'views/ProfileFavorite'

  class Profile extends ZooniverseProfile
    template: TEMPLATE

    map: null
    userLayer: null
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

      @map.removeLayer @userLayer if @userLayer?

      if User.current?
        @usernameContainer.html User.current.name
        @scoreboard.update()

        query = "SELECT * FROM #{Project.current.cartoTable} WHERE user_id='#{User.current.id}'"
        url = "http://#{Project.current.cartoUser}.cartodb.com/tiles/#{Project.current.cartoTable}/{z}/{x}/{y}.png?sql=#{query}"
        @userLayer = @map.addLayer url

    favoriteTemplate: favoriteTemplate

  module.exports = Profile
