$ = require 'jQuery'

Pager = require 'lib/Pager'
window.pagers = (new Pager el: parent for parent in $('[data-page]').parent())

User = require 'models/User'
$.ajaxSetup beforeSend: (xhr) ->
  if User.current?
    # TODO: Use http://stringencoders.googlecode.com/svn/trunk/javascript/base64.js
    auth = btoa "#{ User.current.username }:#{ User.current.apiKey }"
    xhr.setRequestHeader 'Authorization', "Basic #{ auth }"

GroundCover = require 'models/GroundCover'
for description in ['Sand', 'Cobble', 'Boulder', 'Gravel', 'Shell hash', 'Can\'t tell']
  GroundCover.create description: description

Map = require 'controllers/Map'
Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Does Zooniverse have one?
# Map::tilesId = 61165

window.homeMap = new Map el: $('[data-page="home"] .map')

Scoreboard = require 'controllers/scoreboard'
window.homeScoreboard = new Scoreboard
  el: $('[data-page="home"] .scoreboard')
  user: null

Classifier = require 'controllers/Classifier'
window.classifier = new Classifier
	el: $('#classifier')

Profile = require 'controllers/Profile'
window.profile = new Profile el: $('[data-page="profile"]')

window.Authentication = require 'Authentication'
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.Recent = require 'models/Recent'
window.Favorite = require 'models/Favorite'

exports = window.classifier
