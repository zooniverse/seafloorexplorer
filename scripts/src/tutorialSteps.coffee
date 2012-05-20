define (require, exports, module) ->
	{Step} = require 'controllers/Tutorial'
	{translate} = require 'util'

	module.exports = [
		new Step
			style: left: 170, top: 200, width: 400, height: 'auto'
			content: translate 'tutorialWelcome'
			modal: true

		new Step
			style: left: 380, top: 100, width: 340, height: 'auto'
			className: 'top right'
			content: translate 'tutorialGroundCover1'
			nextOn: click: '.ground-cover .toggles button:contains("Sand")'

		new Step
			style: left: 380, top: 260, width: 340, height: 'auto'
			className: 'top right'
			content: translate 'tutorialGroundCover2'
			nextOn: click: '.ground-cover .toggles button:contains("Gravel")'

		new Step
			style: left: 380, top: 375, width: 340, height: 'auto'
			className: 'bottom right'
			content: translate 'tutorialGroundCoverFinished'
			nextOn: click: '.ground-cover .finished'

		new Step
			style: left: 300, top: 150, width: 420, height: 'auto'
			className: 'top right'
			content: translate 'tutorialFish'
			nextOn: click: '.species .toggles button:contains("Fish")'

		new Step
			style: left: 240, top: 270, width: 330, height: 'auto'
			className: 'bottom left'
			content: translate 'tutorialFishHead'
			nextOn: 'create-stray-circle': '#classifier'

		new Step
			style: left: 350, top: 250, width: 310, height: 'auto'
			className: 'top right'
			content: translate 'tutorialFishTail'
			nextOn: 'create-stray-axis': '#classifier'

		new Step
			style: left: 130, top: 20, width: 220, height: 'auto'
			className: 'top right'
			content: translate 'tutorialFishLeft'
			nextOn: 'create-stray-circle': '#classifier'

		new Step
			style: left: 220, top: 490, width: 270, height: 'auto'
			className: 'bottom right'
			content: translate 'tutorialFishRight'
			nextOn: 'create-marking': '#classifier'

		new Step
			style: left: 400, top: 100, width: 320, height: 'auto'
			className: 'top right'
			content: translate 'tutorialSeastar'
			nextOn: click: '.species .toggles button:contains("Seastar")'

		new Step
			style: left: 190, top: 130, width: 390, height: 'auto'
			content: translate 'tutorialSeastarExplanation'
			modal: true

		new Step
			style: left: 190, top: 180, width: 210, height: 'auto'
			className: 'bottom left'
			content: translate 'tutorialSeastarCenter'
			nextOn: 'create-stray-circle': '#classifier'

		new Step
			style: left: 250, top: 180, width: 210, height: 'auto'
			className: 'bottom left'
			content: translate 'tutorialSeastarTip'
			nextOn: 'create-marking': '#classifier'

		new Step
			style: left: 300, top: 20, width: '370px', height: 'auto'
			content: translate 'adjustMarkers'
			modal: true

		new Step
			style: left: 240, top: 370, width: 480, height: 'auto'
			className: 'top right'
			content: translate 'tutorialSpeciesFinished'
			nextOn: click: '.species .finished'

		new Step
			style: left: 240, top: 200, width: 390, height: 'auto'
			content: translate 'tutorialComplete'
			modal: true
	]
