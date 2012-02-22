{Step} = require 'controllers/Tutorial'

exports = [
	new Step
		style: left: 170, top: 200, width: 400, height: 200
		content: 'Welcome!'
		modal: true

	new Step
		style: left: 550, top: 240, width: 270, height: 30
		content: 'Choose a ground cover from the list.'
		nextOn: click: '.ground-cover.toggles button'

	new Step
		style: left: 550, top: 390, width: 300, height: 30
		content: 'Click "Done" when you\'ve got the best one.'
		nextOn: click: '.ground-cover .finished'

	new Step
		style: left: 550, top: 180, width: 270, height: 30
		content: 'First we\'ll mark the fish. Choose "Fish" from the list of species.'
		nextOn: 'click': '.species.toggles [value="fish"]'

	new Step
		style: left: 450, top: 250, width: 150, height: 60
		content: 'For most species, we\'ll mark its longer and shorter axis.'
		modal: true

	new Step
		style: left: 230, top: 360, width: 250, height: 40
		content: 'First we\'ll measure the longer axis. Click the head...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 510, top: 220, width: 220, height: 30
		content: '...and then the end of the tail.'
		nextOn: 'click': '#subject'

	new Step
		style: left: 260, top: 40, width: 230, height: 100
		content: 'Now, measure the shorter axis. Click the left fin...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 450, top: 480, width: 180, height: 30
		content: '...and then the right fin.'
		nextOn: 'click': '#subject'

	new Step
		style: left: 610, top: 130, width: 200, height: 60
		content: 'Next we\'ll mark the seastar. Choose "Seastar" from the list of species.'
		nextOn: click: '.species.toggles button'

	new Step
		style: left: 100, top: 110, width: 200, height: 60
		content: 'Seastars are a little different. We\'ll click the end of each of its five legs.'
		modal: true

	new Step
		style: left: 100, top: 110, width: 200, height: 30
		content: 'Start by clicking one leg...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 120, top: 120, width: 200, height: 30
		content: '...then the next...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 140, width: 200, height: 30
		content: '...and work your way around...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 140, width: 200, height: 30
		content: '...to the rest...'
		nextOn: 'click': '#subject'

	new Step
		style: left: 110, top: 120, width: 200, height: 30
		content: '...until you mark five.'
		nextOn: 'click': '#subject'

	new Step
		style: left: 130, top: 110, width: 230, height: 60
		content: 'Some seastars have more than five legs. Just try to distrubute the five points around evenly.'
		modal: true

	new Step
		style: left: 560, top: 370, width: 260, height: 40
		content: 'Once we\'re done marking all the species in an image, click "Finished".'
		nextOn: click: '.species .finished'

	new Step
		style: left: 840, top: 270, width: 210, height: 40
		content: 'Now you\'re ready to classify some images on your own!'
		modal: true
]
