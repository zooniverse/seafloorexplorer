$ = require 'jQuery'

User = require 'models/User'
$.ajaxSetup beforeSend: (xhr) ->
  if User.current?
    auth = btoa "#{ User.current.username }:#{ User.current.apiKey }" # TODO: IE
    xhr.setRequestHeader 'Authorization', "Basic #{ auth }"

Pager = require 'lib/Pager'
window.pagers = (new Pager el: parent for parent in $('[data-page]').parent())

GroundCover = require 'models/GroundCover'
for description in ['Sand', 'Cobble', 'Boulder', 'Gravel', 'Shell hash', 'Can\'t tell']
	GroundCover.create description: description

# From http://habcam.whoi.edu/habcam2.html
sampleImages = [
	'sample-images/UNQ.20060928.010920609.jpg'
	'sample-images/UNQ.20070726.073105937.jpg'
	'sample-images/UNQ.20080731.043833900.jpg'
	'sample-images/UNQ.20080811.062244403.jpg'
	'sample-images/UNQ.20090626.113420984.jpg'
	'sample-images/UNQ.20090627.090015906.jpg'
	'sample-images/UNQ.20090629.000241062.jpg'
	'sample-images/UNQ.20090629.145917171.jpg'
	'sample-images/UNQ.20090714.222541046.jpg'
	'sample-images/UNQ.20091201.023850359.jpg'
]

Subject = require 'models/Subject'
for sampleImage, i in sampleImages
	Subject.create
		image: sampleImage
		latitude: parseFloat String(Math.random() * 80)[0..4]
		longitude: parseFloat String(Math.random() * 180)[0..4]
		depth: i * 10

Classifier = require 'controllers/Classifier'
window.classifier = new Classifier
	el: $('#classifier')
	subject: Subject.first()

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

window.Authentication = require 'Authentication'
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.Recent = require 'models/Recent'
window.Favorite = require 'models/Favorite'

exports = window.classifier
