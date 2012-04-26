Spine = require 'Spine'

Scoreboard = require 'controllers/Scoreboard'

PROFILE_TEMPLATE = require 'lib/text!views/Profile.html'

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

exports = Profile
