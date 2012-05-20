define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'
  Classifier = require 'controllers/Classifier'

  GroundCover = require 'models/GroundCover'
  for description in ['Sand', 'Cobble', 'Boulder', 'Gravel', 'Shell hash', 'Can\'t tell']
    GroundCover.create description: description

  module.exports = new App
    el: '#main'
    projects:
      '4fa4088d54558f3d6a000001':
        workflows:
          '4fa408de54558f3d6a000002':
            controller: Classifier
            attributes:
              el: '#classifier'

# GroundCover = require 'models/GroundCover'
# for description in ['Sand', 'Cobble', 'Boulder', 'Gravel', 'Shell hash', 'Can\'t tell']
#   GroundCover.create description: description

# Map = require 'controllers/Map'
# Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Does Zooniverse have one?
# # Map::tilesId = 61165

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
