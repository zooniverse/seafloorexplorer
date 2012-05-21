define (require, exports, module) ->
  require 'amdShims'

  App = require 'zooniverse/controllers/App'
  Classifier = require 'controllers/Classifier'
  Map = require 'zooniverse/controllers/Map'
  Profile = require 'zooniverse/controllers/Profile'

  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  # TODO: Map::tilesId = 61165

  module.exports = new App
    el: '#main'
    projects:
      '4fa4088d54558f3d6a000001':
        workflows:
          '4fa408de54558f3d6a000002':
            controller: Classifier
            attributes:
              el: '#classifier'
    widgets:
      homeMap:
        controller: Map
        attributes:
          el: '[data-page="home"] .map'
      profile:
        controller: Profile
        attributes:
          el: '#profile'


# window.homeMap = new Map el: $('[data-page="home"] .map')

# Scoreboard = require 'controllers/scoreboard'
# window.homeScoreboard = new Scoreboard
#   el: $('[data-page="home"] .scoreboard')
#   user: null

# Classifier = require 'controllers/Classifier'
# window.classifier = new Classifier
# 	el: $('#classifier')

# Profile = require 'controllers/Profile'
# window.profile = new Profile el: $('[data-page="profile"]')
