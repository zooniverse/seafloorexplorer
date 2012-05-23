define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'
  Classifier = require 'controllers/Classifier'
  Scoreboard = require 'controllers/Scoreboard'
  Map = require 'zooniverse/controllers/Map'
  Profile = require 'controllers/Profile'

  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  # TODO: Map::tilesId = 61165

  window.app = new App
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

      homeScoreboard:
        controller: Scoreboard
        attributes:
          el: '[data-page="home"] .scoreboard'

      profile:
        controller: Profile
        attributes:
          el: '[data-page="profile"]'

  window.Subject = require 'models/Subject'

  module.exports = window.app
