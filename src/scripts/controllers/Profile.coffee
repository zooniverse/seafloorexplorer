define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  App = require 'zooniverse/models/App'
  User = require 'zooniverse/models/User'

  ZooniverseProfile = require 'zooniverse/controllers/Profile'

  Map = require 'zooniverse/controllers/Map'
  Scoreboard = require 'controllers/Scoreboard'

  TEMPLATE = require 'views/Profile'
  favoriteTemplate = require 'views/ProfileFavorite'
  recentTemplate = require 'views/ProfileRecent'

  class Profile extends ZooniverseProfile
    template: TEMPLATE
    favoriteTemplate: favoriteTemplate
    recentTemplate: recentTemplate

    map: null
    userLayer: null
    scoreboard: null

    events: $.extend
      'click .sign-out': 'signOut'
      ZooniverseProfile::events

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

        query = "SELECT * FROM #{App.first().cartoTable} WHERE user_id='#{User.current.id}'"
        url = "http://#{App.first().cartoUser}.cartodb.com/tiles/#{App.first().cartoTable}/{z}/{x}/{y}.png?sql=#{query}"
        @userLayer = @map.addLayer url

    signOut: (e) =>
      e.preventDefault()
      User.signOut()

  module.exports = Profile
