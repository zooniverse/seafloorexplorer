$ = require 'jQuery'

$('html').addClass 'pre-load' # Prevent animation while the page is set up.

Pager = require 'controllers/Pager'
window.pagers = (new Pager el: parent for parent in $('[data-page]').parent())

NestedRoute = require 'NestedRoute'
NestedRoute.setup()

ScrollMatcher = require 'controllers/ScrollMatcher'
window.scrollMatchers = (new ScrollMatcher el : parent for parent in $('[data-scroll-name]').parent())

layout = require 'layout'
$(window).on 'resize', layout
$(document).ready layout

# Prevent scrolling the page on iPads.
$(document).on 'touchmove', (e) -> e.preventDefault()

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
		latitude: parseFloat String(Math.random() * 180)[0..4]
		longitude: parseFloat String(Math.random() * 180)[0..4]
		depth: i * 10

Classifier = require 'controllers/Classifier'
CreaturePicker = require 'controllers/CreaturePicker'
window.classifier = new Classifier
	el: $('#classifier')
	picker: new CreaturePicker
		el: $('#subject')
	subject: Subject.first()

Tutorial = require 'controllers/Tutorial'
tutSteps = require 'tutorial-steps'
window.tutorial = new Tutorial
	el: $('section[data-page="classify"]')
	steps: tutSteps

unless loggedInUserAlreadyDidTheTutorial? then tutorial.start()

{delay} = require 'util'
delay -> $('html').removeClass 'pre-load'

exports = window.classifier
