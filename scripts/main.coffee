$ = require 'jQuery'

User = require 'models/User'
$.ajaxSetup beforeSend: (xhr) ->
  if User.current?
    auth = btoa "#{ User.current.username }:#{ User.current.apiKey }" # TODO: IE
    xhr.setRequestHeader 'Authorization', "Basic #{ auth }"

Map = require 'controllers/Map'
Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Does Zooniverse have one?
Map::tilesId = 61165

window.homeMap = new Map el: $('[data-page="home"] .map')

Pager = require 'lib/Pager'
window.pagers = (new Pager el: parent for parent in $('[data-page]').parent())

GroundCover = require 'models/GroundCover'
for description in ['Sand', 'Cobble', 'Boulder', 'Gravel', 'Shell hash', 'Can\'t tell']
	GroundCover.create description: description

Classifier = require 'controllers/Classifier'
window.classifier = new Classifier
	el: $('#classifier')

Tutorial = require 'controllers/Tutorial'
tutorialSteps = require 'tutorialSteps'
window.tutorial = new Tutorial
	el: $('section[data-page="classify"]')
	steps: tutorialSteps

Scoreboard = require 'controllers/scoreboard'
homeScoreboard = new Scoreboard
	el: $('[data-page="home"] .scoreboard')
	user: null

Profile = require 'controllers/Profile'
profile = new Profile el: $('[data-page="profile"]')

unless ~location.search.indexOf 'notut' then tutorial.start()

Subject = require 'models/Subject'
Subject.fetch().then (subject) ->
	Subject.setCurrent subject

window.Authentication = require 'Authentication'
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.Recent = require 'models/Recent'
window.Favorite = require 'models/Favorite'

exports = window.classifier
