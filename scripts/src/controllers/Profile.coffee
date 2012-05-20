define (require, exports, module) ->
  Spine = require 'Spine'

  Scoreboard = require 'controllers/Scoreboard'

  PROFILE_TEMPLATE = require 'views/Profile'

  class Profile extends Spine.Controller
    user: null

    template: PROFILE_TEMPLATE

    map: null
    scoreboard: null

    elements:
      '.summary .map': 'mapContainer'
      '.summary .scoreboard': 'scoreboardContainer'

    constructor: ->
      super
      @html @template

      @scoreboard = new Scoreboard
        el: @scoreboardContainer
        user: null

    render: =>
      # TODO

  module.exports = Profile
