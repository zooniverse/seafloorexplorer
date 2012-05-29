define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'

  Subject = require 'models/Subject'
  Classification = require 'models/Classification'
  Classifier = require 'controllers/Classifier'

  Scoreboard = require 'controllers/Scoreboard'
  Map = require 'zooniverse/controllers/Map'
  Profile = require 'controllers/Profile'
  Review = require 'controllers/Review'

  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  # TODO: Map::tilesId = 61165

  window.app = new App
    el: '#main'

    languages: ['en']

    projects:
      '4fa4088d54558f3d6a000001':
        attributes:
          name: 'Seafloor Explorer'
          slug: 'seafloor-explorer'
          description: 'Help explore the ocean floor!'

        workflows:
          '4fa408de54558f3d6a000002':
            subject: Subject
            classification: Classification
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

      review:
        controller: Review
        attributes:
          el: '[data-page="review"]'

  module.exports = window.app
