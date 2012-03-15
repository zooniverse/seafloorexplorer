{Step} = require 'controllers/Tutorial'
{translate} = require 'util'

exports = [
	new Step
		style: left: 170, top: 200, width: 400, height: 'auto'
		content: translate 'tutorialWelcome'
		modal: true

	new Step
		style: left: 400, top: 160, width: 340, height: 'auto'
		className: 'top right'
		content: translate 'tutorialGroundCover1'
		nextOn: click: '.ground-cover.toggles button:contains("Sand")'

	new Step
		style: left: 400, top: 270, width: 340, height: 'auto'
		className: 'top right'
		content: translate 'tutorialGroundCover2'
		nextOn: click: '.ground-cover.toggles button:contains("Gravel")'

	new Step
		style: left: 400, top: 340, width: 340, height: 'auto'
		className: 'bottom right'
		content: translate 'tutorialGroundCoverFinished'
		nextOn: click: '.ground-cover .finished'

	new Step
		style: left: 320, top: 200, width: 420, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFish'
		nextOn: click: '.species.toggles button:contains("Fish")'

	new Step
		style: left: 260, top: 280, width: 330, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialFishHead'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 370, top: 250, width: 310, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFishTail'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 130, top: 20, width: 220, height: 'auto'
		className: 'top right'
		content: translate 'tutorialFishLeft'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 220, top: 510, width: 270, height: 'auto'
		className: 'bottom right'
		content: translate 'tutorialFishRight'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 420, top: 160, width: 320, height: 'auto'
		className: 'top right'
		content: translate 'tutorialSeastar'
		nextOn: click: '.species.toggles button:contains("Seastar")'

	new Step
		style: left: 190, top: 130, width: 390, height: 'auto'
		content: translate 'tutorialSeastarExplanation'
		modal: true

	new Step
		style: left: 190, top: 180, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastarCenter'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 250, top: 180, width: 210, height: 'auto'
		className: 'bottom left'
		content: translate 'tutorialSeastarTip'
		nextOn: mousedown: '#subject'

	new Step
		style: left: 260, top: 400, width: 480, height: 'auto'
		className: 'top right'
		content: translate 'tutorialSpeciesFinished'
		nextOn: click: '.species .finished'

	new Step
		style: left: 260, top: 400, width: 390, height: 'auto'
		content: translate 'tutorialComplete'
		modal: true
]
