$ = require 'jQuery'

CreaturePicker = require 'controllers/CreaturePicker'
Classifier = require 'controllers/Classifier'
Subject = require 'models/Subject'

# TODO: Make this an external resource.
# They've been copied over from Bat Detective for now.
Pager = require 'controllers/Pager'
NestedRoute = require 'NestedRoute'

ScrollMatcher = require 'controllers/ScrollMatcher'

layout = require 'layout'

window.pagers = $('[data-page]').parent().map -> new Pager el: @
NestedRoute.setup()

window.scrollMatchers = $('[data-scroll-name]').parent().map -> new ScrollMatcher el : @

$(window).resize layout
$(document).ready layout

$(document).on 'touchmove', (e) -> e.preventDefault()

# From http://habcam.whoi.edu/habcam2.html
sampleImages = [
	'UNQ.20060928.010920609.jpg'
	'UNQ.20070726.073105937.jpg'
	'UNQ.20080731.043833900.jpg'
	'UNQ.20080811.062244403.jpg'
	'UNQ.20090626.113420984.jpg'
	'UNQ.20090627.090015906.jpg'
	'UNQ.20090629.000241062.jpg'
	'UNQ.20090629.145917171.jpg'
	'UNQ.20090714.222541046.jpg'
	'UNQ.20091201.023850359.jpg'
]

for sampleImage, i in sampleImages
	Subject.create
		image: "sample-images/#{sampleImage}"
		latitude: parseFloat String(Math.random() * 180)[0..4]
		longitude: parseFloat String(Math.random() * 180)[0..4]
		depth: i * 10

window.classifier = new Classifier
	el: $('#classifier')
	picker: new CreaturePicker
		el: $('#subject')
	subject: Subject.first()

exports = window.classifier
